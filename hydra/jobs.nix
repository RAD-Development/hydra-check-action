{ inputs, outputs }:
let
  inherit (inputs.nixpkgs.lib) mapAttrs;

in
{
  packages = outputs.packages;
}
