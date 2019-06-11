{ stdenv, kernel }:

with stdenv.lib;

stdenv.mkDerivation ({
  name = "sun50i-a64-gpadc-iio-${kernel.version}";
  src = ./.;

  hardeningDisable = [ "pic" ];

  KERNELDIR = "${kernel.dev}/lib/modules/${kernel.modDirVersion}/build";
  INSTALL_MOD_PATH = "\${out}";

  nativeBuildInputs = kernel.moduleBuildDependencies;

  meta.platforms = platforms.linux;
} // optionalAttrs (stdenv.buildPlatform != stdenv.hostPlatform &&
                    stdenv.hostPlatform.system == "aarch64-linux") {
  ARCH = "arm64";
  CROSS_COMPILE = "aarch64-unknown-linux-gnu-";
})
