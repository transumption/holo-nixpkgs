## Add package to overlay

First, enter `nix-shell`. This will set up local overlay and Nixpkgs pin in
such a way that completely reproduces production environment.

Then, add a new package to `overlays/overlay/default.nix`:

```nix
{
  package-name = callPackage ./package-name {};
}
```

Create `overlays/overlay/package-name/default.nix` and write the derivation as
you normally would. To test if it builds, run `nix-build '<nixpkgs>' -A package-name`.
