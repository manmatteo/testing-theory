{
  description = "A dev shell with coq-lsp and autosubst-ocaml";
  inputs.opam-nix.url = "github:tweag/opam-nix";
  inputs.opam-repository.url = "github:ocaml/opam-repository";
  inputs.opam-repository.flake = false;
  inputs.flake-utils.url = "github:numtide/flake-utils";
  inputs.nixpkgs.url = "github:nixos/nixpkgs";
  outputs =
  {
    self,
    nixpkgs,
    opam-nix,
    opam-repository,
    flake-utils,
  }:
  flake-utils.lib.eachDefaultSystem (system: {
    legacyPackages =
      let
        opam-rocq = nixpkgs.legacyPackages.${system}.fetchFromGitHub {
          owner = "rocq-prover";
          repo = "opam";
          rev = "2848a7701bf24771a8d8491cdf8cdebcc624f4eb";
          sha256 = "PcbKXEZkYHiJrmZQB67wtMYmkRHv7AtIR8Q7jsgA7AI=";
          fetchSubmodules = true;
        };
        inherit (opam-nix.lib.${system}) queryToScope;
      in
      queryToScope {
        repos = [ "${opam-repository}"
                  "${opam-rocq}/released" ];
          }
          {
            coq-autosubst-ocaml = "*";
            coq-stdpp = "*";
            coq-lsp = "*";
          };
    packages.default = nixpkgs.legacyPackages.${system}.bash;
    devShells.default = nixpkgs.legacyPackages.${system}.mkShell {
        buildInputs = with self.legacyPackages.${system}; [
          coq-autosubst-ocaml
          coq-stdpp
          coq-lsp
        ];
      };
  });
}

