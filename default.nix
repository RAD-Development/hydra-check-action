{
  lib,
  config,
  dream2nix,
  ...
}: {
  imports = [
    dream2nix.modules.dream2nix.nodejs-package-json-v3
    dream2nix.modules.dream2nix.nodejs-granular-v3
  ];

  deps = {nixpkgs, ...}: {
    inherit
      (nixpkgs)
      gnugrep
      stdenv
      ;
  };

  nodejs-granular-v3 = {
    buildScript = ''
      npm run package
      chmod +x ./dist/index.js
      patchShebangs .
    '';
  };

  name = lib.mkForce "typescript-action";
  version = lib.mkForce "0.0.1";

  mkDerivation = {
    src = lib.cleanSource ./.;
    checkPhase = ''
      npm run format:check
      npm run lint
      npm run ci-test
      npm run test:coverage -- --passWithNoTests
    '';
    doCheck = true;
  };
}
