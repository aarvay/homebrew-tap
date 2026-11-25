#!/usr/bin/env bash
# Generate Formula/zvm.rb from published, attested release assets.
set -euo pipefail
if [[ $# != 1 || ! $1 =~ ^v[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    printf 'Usage: bash scripts/update-zvm.sh vX.Y.Z\n' >&2
    exit 1
fi
tag=$1
root=$(cd "$(dirname "$0")/.." && pwd -P)
tmp=$(mktemp -d)
trap 'rm -rf -- "$tmp"' EXIT
repo=aarvay/zvm
gh release download "$tag" --repo "$repo" --dir "$tmp" --pattern SHA256SUMS --pattern zvm-source.tar.gz
gh attestation verify "$tmp/SHA256SUMS" --repo "$repo" \
    --signer-workflow "$repo/.github/workflows/release.yml" --source-ref "refs/tags/$tag"
expected=$(awk '$2 == "zvm-source.tar.gz" { print $1 }' "$tmp/SHA256SUMS")
actual=$(shasum -a 256 < "$tmp/zvm-source.tar.gz")
[[ $expected =~ ^[a-f0-9]{64}$ && $expected == "${actual%% *}" ]] || { echo 'Archive checksum mismatch' >&2; exit 1; }
sed -e "s/@TAG@/$tag/g" -e "s/@VERSION@/${tag#v}/g" -e "s/@SHA256@/$expected/g" "$root/templates/zvm.rb.in" > "$tmp/zvm.rb"
mkdir -p "$root/Formula"
cp "$tmp/zvm.rb" "$root/Formula/zvm.rb"
printf 'Generated Formula/zvm.rb for %s. Review it and submit it to the tap.\n' "$tag"
