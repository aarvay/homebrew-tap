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

Requires an authenticated `gh` with attestation support and `shasum`. The script verifies the release manifest against the tag and release workflow, checks the source bundle against that manifest, and generates `Formula/zvm.rb`. Never hash a local rebuild in place of the published artifact.

Open one PR for the formula update. Wait for **Formula CI** to install the formula from the published bundle and run `brew test` on macOS, then merge the PR with a merge commit to preserve the reviewed commits. zvm is a Bash script, so the formula installs directly from the release bundle without compiling anything. There is no bottle publish or autobump step.
