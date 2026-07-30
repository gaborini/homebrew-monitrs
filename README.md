# homebrew-monitrs

A Homebrew tap for [monitrs](https://github.com/gaborini/monitrs) — a fast,
keyboard-first system cockpit for Linux and macOS, built in Rust.

```sh
brew tap gaborini/monitrs
brew install monitrs
```

`brew upgrade monitrs` afterwards, as usual.

## Why a tap rather than homebrew-core

Homebrew's [package acceptance
policy](https://docs.brew.sh/Package-Acceptance-Policy#notability) asks a project
submitted by its own author to have at least 225 stars, 90 forks or 90 watchers. monitrs
has none of those yet, so this tap is the honest route: it installs exactly the same
binaries, from the same release, with the same checksums — it just does not claim to have
cleared a bar it has not cleared.

## What it installs

The formula is a **binary** formula: it downloads the archive that
[monitrs's release workflow](https://github.com/gaborini/monitrs/blob/main/.github/workflows/release.yml)
already built, so installing needs no Rust toolchain. Four platforms are covered — macOS
on Apple Silicon and Intel, Linux on aarch64 and x86_64 (glibc).

Beside the binary it installs the manpage and the bash, zsh and fish completions that ship
in the archive.

Every archive carries a [build
attestation](https://docs.github.com/actions/security-guides/using-artifact-attestations),
so you can check that what you installed came from that workflow and that commit rather
than from someone's laptop:

```sh
gh attestation verify \
  "$(brew --cache)/monitrs--0.2.0.tar.gz" --repo gaborini/monitrs
```

Homebrew verifies the SHA-256 in the formula on every install, which covers the archive
being the one this formula was written against. The attestation is the separate question
of where that archive came from.

## Updating

Each monitrs release needs the version and the four checksums in
[`Formula/monitrs.rb`](Formula/monitrs.rb) changed. They come from the release's own
`SHA256SUMS`:

```sh
curl -sL https://github.com/gaborini/monitrs/releases/download/vX.Y.Z/SHA256SUMS
```

This is deliberately manual for now. Automating it from the monitrs repository would mean
putting a cross-repository write token in that repository's secrets, and monitrs's own
§18.4 says no publishing token belongs there — so the trade is a real one and has not been
made yet.

## Licence

The formula is dual licensed under [MIT](LICENSE-MIT) or
[Apache-2.0](LICENSE-APACHE), matching monitrs itself.
