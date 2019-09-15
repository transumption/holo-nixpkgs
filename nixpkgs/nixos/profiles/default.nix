{
  imports = [ ../modules ];

  nixpkgs.overlays = [ (import ../../../overlays/holo-nixpkgs) ];
}
