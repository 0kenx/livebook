{
  description = "HTMX ecommerce demos — Bun/TS, Go, Elixir/Phoenix";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            # --- Elixir / Phoenix ---
            beam28Packages.elixir_1_19
            beam28Packages.erlang
            beam28Packages.hex
            beam28Packages.rebar3
            inotify-tools

            # --- Go ---
            go
            gopls

            # --- Bun / TypeScript ---
            bun
            nodejs_22

            # --- Database ---
            postgresql_17

            # --- Utilities ---
            curl
            jq
            oha
          ];

          shellHook = ''
            # Elixir
            export MIX_HOME="$PWD/.nix-mix"
            export HEX_HOME="$PWD/.nix-hex"
            export ERL_AFLAGS="-kernel shell_history enabled"
            export PATH="$MIX_HOME/bin:$MIX_HOME/escripts:$HEX_HOME/bin:$PATH"
            mkdir -p "$MIX_HOME" "$HEX_HOME"

            # Go
            export GOPATH="$PWD/.go"
            export PATH="$GOPATH/bin:$PATH"
            mkdir -p "$GOPATH"
          '';
        };
      });
}
