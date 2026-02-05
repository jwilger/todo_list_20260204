{
  description = "todo_list development environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    rust-overlay.url = "github:oxalica/rust-overlay";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, rust-overlay, flake-utils, ... }@inputs:
    flake-utils.lib.eachDefaultSystem (system:
      let
        overlays = [ rust-overlay.overlays.default ];
        pkgs = import nixpkgs {
          inherit system overlays;
        };

        # Rust toolchain from rust-toolchain.toml
        rustToolchain = pkgs.rust-bin.fromRustupToolchainFile ./rust-toolchain.toml;

        # Universal tools (ALWAYS include these)
        universalTools = with pkgs; [
          git
          git-spice
          pre-commit
          nodejs_22
          glow
          just
          jq
        ];

        # Rust-specific tools
        rustTools = with pkgs; [
          rustToolchain
          cargo-nextest
          cargo-audit
          cargo-mutants
          pkg-config
        ];

        # SQLite support
        databaseTools = with pkgs; [
          sqlite
        ];

        # Platform-specific dependencies
        darwinDeps = with pkgs; pkgs.lib.optionals stdenv.isDarwin [
          libiconv
          darwin.apple_sdk.frameworks.Security
          darwin.apple_sdk.frameworks.SystemConfiguration
        ];

        linuxDeps = with pkgs; pkgs.lib.optionals stdenv.isLinux [
        ];

      in {
        devShells.default = pkgs.mkShell {
          buildInputs = universalTools
            ++ rustTools
            ++ databaseTools
            ++ darwinDeps
            ++ linuxDeps;

          # Environment variables
          RUST_SRC_PATH = "${rustToolchain}/lib/rustlib/src/rust/library";

          shellHook = ''
            # Configure git for stacked PR workflow
            git config --local rebase.updateRefs true 2>/dev/null || true

            echo "todo_list development environment loaded"
            echo ""
            echo "Rust toolchain: $(rustc --version)"
            echo "Cargo: $(cargo --version)"
            echo "SQLite: $(sqlite3 --version)"
            echo ""
            echo "Testing tools:"
            echo "  - cargo nextest $(cargo nextest --version | head -n1 | cut -d' ' -f2)"
            echo "  - cargo mutants $(cargo mutants --version | cut -d' ' -f2)"
            echo "  - cargo audit $(cargo audit --version | cut -d' ' -f2)"
            echo ""
            echo "Use 'just' to see available development tasks"
            echo "Use 'glow README.md' to view documentation"
          '';
        };
      }
    );
}
