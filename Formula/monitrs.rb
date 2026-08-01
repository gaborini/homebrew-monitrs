# A binary formula: it installs the archives the release workflow already builds and
# attests, so nobody needs a Rust toolchain to install monitrs.
#
# Lives in a tap of its own — `gaborini/homebrew-monitrs`, `Formula/monitrs.rb` — because
# homebrew-core's notability bar for a self-submission is 225 stars, 90 forks or 90
# watchers, and this project has none of those yet.
class Monitrs < Formula
  desc "Fast, keyboard-first system cockpit for Linux and macOS"
  homepage "https://github.com/gaborini/monitrs"
  version "1.0.0"
  license any_of: ["MIT", "Apache-2.0"]

  # The URLs interpolate `version` so a release bump touches one version string and
  # four checksums, and nothing else. Before this, the version also appeared twice in
  # each of the four URLs -- eight more places to get wrong, which the release
  # checklist did not mention.
  on_macos do
    on_arm do
      url "https://github.com/gaborini/monitrs/releases/download/v#{version}/monitrs-#{version}-aarch64-apple-darwin.tar.gz"
      sha256 "659e2c0f936849d60c5af353d65b877bffe0945b380c49aeaed9aaf669609e07"
    end
    on_intel do
      url "https://github.com/gaborini/monitrs/releases/download/v#{version}/monitrs-#{version}-x86_64-apple-darwin.tar.gz"
      sha256 "047c591d11a98f40d918150a73d657f7285fccfb7df352a1a4cbb314e495f95d"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/gaborini/monitrs/releases/download/v#{version}/monitrs-#{version}-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "92b9ca821d385d46707883dc3f9585ca370d4e062866efcf01a19b6ab6c5cae2"
    end
    on_intel do
      url "https://github.com/gaborini/monitrs/releases/download/v#{version}/monitrs-#{version}-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "1df25ae08ae5a2763d458b0fc5c415166b6e20e380a9adbb756f4f9a55b82e41"
    end
  end

  def install
    bin.install "monitrs"
    man1.install "man/monitrs.1"
    bash_completion.install "completions/monitrs.bash" => "monitrs"
    zsh_completion.install "completions/monitrs.zsh" => "_monitrs"
    fish_completion.install "completions/monitrs.fish"
  end

  test do
    assert_match "monitrs #{version}", shell_output("#{bin}/monitrs --version")
    # `snapshot` reads the live machine and exits, so it exercises the collector without
    # needing a tty — which `brew test` does not provide.
    assert_match "schema_version", shell_output("#{bin}/monitrs snapshot --format json")
  end
end
