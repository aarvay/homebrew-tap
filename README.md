# Aarvay’s Homebrew tap

Install [zvm](https://github.com/aarvay/zvm) on macOS with its runtime dependencies and shell completions:

```sh
brew install aarvay/tap/zvm
```

Use `brew upgrade aarvay/tap/zvm` to update the manager. Use `zvm install --use latest` to update Zig itself.

## Maintaining the zvm formula

From this tap’s root, after publishing a tagged zvm release:

```sh
bash scripts/update-zvm.sh v1.0.0   # use the actual release tag
```

Requires an authenticated `gh` with attestation support and `shasum`. The script verifies the release manifest against the tag and release workflow, checks the source bundle against that manifest, and generates `Formula/zvm.rb`. It does not commit or publish. Review the generated formula in a tap pull request so `brew test-bot` exercises it before merging. Use this process for the first release and for each subsequent version; never hash a local rebuild in place of the published artifact.
