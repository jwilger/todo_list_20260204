# CLAUDE.md

This project uses a Nix-based development environment.

## Development Environment

The dev shell should already be loaded via direnv. If not, run `nix develop`.

### Running utilities not in the dev shell

Use `nix shell` to temporarily run utilities:
```bash
nix shell nixpkgs#<package> -c <command>
```

### Universal Tools Available

- `just` - Task runner (see Justfile if present)
- `glow` - Render markdown in terminal (`glow README.md`)
- `jq` - JSON processing
- `git-spice` - Stacked PR workflow (`gs` commands)
- `pre-commit` - Git hooks

### Rust Development Tools

This project uses a reproducible Rust toolchain managed via `rust-toolchain.toml`:

- **Rust Toolchain**: Stable channel with rustfmt, clippy, rust-src, and rust-analyzer
- **Testing Tools**:
  - `cargo nextest` - Next-generation test runner (runs tests in separate processes)
  - `cargo mutants` - Mutation testing for code quality verification
- **Security**: `cargo audit` - Audits dependencies for known vulnerabilities
- **Database**: SQLite development libraries for native bindings

### Rust Environment Variables

- `RUST_SRC_PATH` - Set automatically for rust-analyzer functionality

### SQLite Integration

The environment includes SQLite development libraries for native Rust crates like `rusqlite` or `diesel`. The `pkg-config` tool is available to help the build process find SQLite.

## Testing Workflow

### Running Tests with Nextest

```bash
cargo nextest run
```

### Mutation Testing

```bash
cargo mutants
```

To use nextest with cargo-mutants, create `.cargo/mutants.toml`:
```toml
test_tool = "nextest"
```

Or pass it directly:
```bash
cargo mutants --test-tool=nextest
```

### Security Auditing

```bash
cargo audit
```

## Git Workflow

This project uses git-spice for stacked PRs:
- `gs repo sync` - Sync with remote
- `gs stack submit` - Submit all stacked PRs
- `gs branch create <name>` - Create new stacked branch

## Commit Message Guidelines

Use commitizen-style commit messages:

```
<type>(<scope>): <subject>

<body>
```

**Types:** feat, fix, docs, style, refactor, perf, test, build, ci, chore, revert

Commit messages should explain the *WHY*, not just what changed.

## Building and Running

```bash
# Build the project
cargo build

# Run the CLI tool
cargo run -- [args]

# Build optimized release
cargo build --release
```

## Platform-Specific Notes

### macOS (Darwin)
The environment includes required Apple frameworks:
- Security framework
- SystemConfiguration framework
- libiconv

### Linux
SQLite headers are provided via the `sqlite` package. No special configuration needed.

## Troubleshooting

### rust-analyzer not working
Ensure your editor is started from within the direnv-loaded shell, or restart your editor after the environment loads.

### SQLite linking errors
The environment includes `pkg-config` and SQLite libraries. If you see linking errors, ensure you're running commands within the Nix shell.

### Test failures
Use `cargo nextest run` for more detailed test output and better parallelization than standard `cargo test`.
