{ buildGoPackage, fetchgit }:

buildGoPackage {
  name = "holoport-led";

  src = fetchgit {
    fetchSubmodules = true;

    url = "https://gitlab.com/transumption/unstable/aurora-led";
    rev = "7564e393dcd10ac576f532a23f2656d6227be1c3";
    sha256 = "1zrhhsq69d60js56rc92gz9xmpc159smsayglags09m6ws36g292";
  };

  goPackagePath = "gitlab.com/transumption/clients/holoport-led";
}
