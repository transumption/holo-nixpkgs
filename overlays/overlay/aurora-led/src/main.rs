extern crate getopts;
extern crate serial;

use std::env;
use std::io::prelude::*;
use std::process::exit;

use getopts::Options;
use serial::prelude::*;

const SETTINGS: serial::PortSettings = serial::PortSettings {
    baud_rate: serial::Baud19200,
    char_size: serial::Bits8,
    flow_control: serial::FlowNone,
    parity: serial::ParityNone,
    stop_bits: serial::Stop1,
};

const MODES: &str = "Modes:
    aurora      enable Aurora mode
    flash       alternate between on and off with .5s interval, requires setting color
    off         turn LED off
    static      turn LED on, requires setting color
    status      print flags that reproduce the current state of LED controller";

fn print_usage(program: &str, opts: Options) {
    let brief = opts.short_usage(program);
    println!("{}\n{}", opts.usage(&brief), MODES);
}

fn fail(message: &str, program: &str, opts: Options) -> ! {
    println!("{}\n", message);
    print_usage(program, opts);
    exit(1);
}

fn main() {
    let args: Vec<String> = env::args().collect();
    let program = args[0].clone();

    let mut opts = Options::new();
    opts.optopt("", "color", "set color, only available for flash and static modes, one of: blue, green, orange, purple, red, yellow", "COLOR");
    opts.reqopt("", "device", "path to LED controller serial device", "PATH");
    opts.reqopt(
        "",
        "mode",
        "set mode, one of: aurora, flash, off, static",
        "MODE",
    );

    let matches = match opts.parse(&args[1..]) {
        Ok(m) => m,
        Err(f) => {
            fail(&f.to_string(), &program, opts);
        }
    };

    let device = matches.opt_str("device").unwrap();
    let mode = matches.opt_str("mode").unwrap();

    let mode_byte = match mode.as_ref() {
        "aurora" => b'<',
        "flash" => b'*',
        "off" => b'X',
        "static" => b'!',
        _ => fail(&format!("unsupported mode: {}", mode), &program, opts),
    };

    let color_byte = match matches.opt_str("color") {
        Some(x) => match x.as_ref() {
            "blue" => b'B',
            "green" => b'G',
            "orange" => b'O',
            "purple" => b'P',
            "red" => b'R',
            "yellow" => b'Y',
            _ => fail(&format!("unsupported color: {}", x), &program, opts),
        },
        None => match mode.as_ref() {
            "aurora" => b'<',
            "off" => b'X',
            "status" => b'S',
            _ => fail(&format!("missing color for mode: {}", mode), &program, opts),
        },
    };

    let mut port = match serial::open(&device) {
        Ok(p) => p,
        Err(e) => fail(&e.to_string(), &program, opts),
    };

    port.configure(&SETTINGS).unwrap();
    port.write(&[color_byte, mode_byte]).unwrap();
}
