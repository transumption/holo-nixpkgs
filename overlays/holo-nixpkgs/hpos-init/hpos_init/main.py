from functools import lru_cache
from glob import glob
from twisted.internet import reactor
from twisted.internet.defer import ensureDeferred
from wormhole.errors import WormholeError
import hpos_seed
import logging
import os
import sys
import time


log = logging.getLogger(__name__)


@lru_cache()
def runtime_dir():
    return os.getenv('RUNTIME_DIRECTORY', '.')


@lru_cache()
def state_dir():
    return os.getenv('STATE_DIRECTORY', '.')


@lru_cache()
def runtime_config_path():
    return runtime_dir() + '/hpos-config.json'


@lru_cache()
def state_config_path():
    return state_dir() + '/hpos-config.json'


@lru_cache()
def wormhole_code_path():
    return runtime_dir() + '/wormhole-code.txt'


def on_wormhole_code(wormhole_code):
    with open(wormhole_code_path(), 'w') as f:
        f.write(wormhole_code)


async def receive_config():
    backoff_exp = 1
    while True:
        try:
            return await hpos_seed.receive(on_wormhole_code, reactor)
        except WormholeError as e:
            pass
        finally:
            if os.path.exists(wormhole_code_path()):
                os.remove(wormhole_code_path())
        backoff = 2 ** backoff_exp
        backoff_exp += 1
        (exc_type, _, _) = sys.exc_info()
        log.warning("receive failed with %s, retrying in %d seconds",
                    exc_type, backoff)
        time.sleep(backoff)


async def resolve_config_path():
    paths = glob(state_config_path()) + glob('/media/*/hpos-config.json')
    if paths == []:
        config = await receive_config()
        with open(state_config_path(), 'wb') as f:
            f.write(config)
        return state_config_path()
    else:
        return paths[0]


async def hpos_init():
    try:
        if glob(runtime_config_path()) == []:
            config_path = await resolve_config_path()
            os.symlink(config_path, runtime_config_path())
    finally:
        reactor.callLater(0, reactor.stop)


def main():
    ensureDeferred(hpos_init())
    reactor.run()


if __name__ == '__main__':
    main()
