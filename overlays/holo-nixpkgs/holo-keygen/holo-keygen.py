import subprocess
import sys

def holochain_keygen(path):
    return subprocess.run(['hc', 'keygen', '-np', path, '-q'], capture_output=True) \
        .stdout \
        .split(b'\n')[0] \
        .decode('utf-8')

def main(path):
    public_key = holochain_keygen(path)
    with open(path + '.pub', 'w') as f:
        print(public_key, file=f)
        print(public_key)

if __name__ == "__main__":
    main(sys.argv[1])
