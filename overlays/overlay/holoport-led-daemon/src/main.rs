extern crate getopts;
extern crate reqwest;

use std::env;
use std::fs;
use std::i64;
use std::process::exit;
use std::process::Command;
use std::thread::sleep;
use std::time::Duration;

use getopts::Options;

fn aurora_led(args: &[&str]) {
    Command::new("aurora-led").args(args).status().ok();
}

const THERMAL_ZONE: &str = "/sys/class/thermal/thermal_zone0/temp";

fn get_temp() -> i64 {
    return fs::read_to_string(THERMAL_ZONE)
        .unwrap()
        .trim()
        .parse()
        .unwrap();
}

// TODO: replace with a standalone TCP packet based service
const REACHABLE_URL: &str =
  "http://storage.bhs5.cloud.ovh.net/v1/AUTH_69eb89512d2e41329d542cd1abe12534/holoport-led-daemon";

fn is_reachable() -> bool {
    return match reqwest::get(REACHABLE_URL) {
        Err(_) => false,
        Ok(res) => res.status() == 204,
    };
}

fn print_usage(program: &str, opts: Options) {
    let brief = opts.short_usage(program);
    println!("{}\n", opts.usage(&brief));
}

fn main() {
    let args: Vec<String> = env::args().collect();
    let program = args[0].clone();

    let mut opts = Options::new();
    opts.reqopt("", "device", "path to Aurora LED controller device", "PATH");

    let matches = match opts.parse(&args[1..]) {
        Ok(m) => m,
        Err(f) => {
            println!("{}\n", f.to_string());
            print_usage(&program, opts);
            exit(1);
        }
    };

    let device = matches.opt_str("device").unwrap();

    loop {
        sleep(Duration::new(5, 0));

        match get_temp() {
            79000...98999 => {
                aurora_led(&["--device", &device, "--mode", "flash", "--color", "red"]);
                continue;
            }
            99000...i64::MAX => {
                aurora_led(&["--device", &device, "--mode", "flash", "--color", "red"]);
                continue;
            }
            _ => {}
        }

        if !is_reachable() {
            aurora_led(&["--device", &device, "--mode", "flash", "--color", "purple"]);
            continue;
        }

        aurora_led(&["--device", &device, "--mode", "aurora"]);
    }
}
