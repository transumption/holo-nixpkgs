{
  imports = [ ../modules ];

  nixpkgs.overlays = [ (import ../overlays/overlay) ];
}
