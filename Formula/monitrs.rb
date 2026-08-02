# A binary formula: it installs the archives the release workflow already builds and
# attests, so nobody needs a Rust toolchain to install monitrs.
#
# Lives in a tap of its own — `gaborini/homebrew-monitrs`, `Formula/monitrs.rb` — because
# homebrew-core's notability bar for a self-submission is 225 stars, 90 forks or 90
# watchers, and this project has none of those yet.
class Monitrs < Formula
  desc "Fast, keyboard-first system cockpit for Linux and macOS"
  homepage "https://github.com/gaborini/monitrs"
  version "1.0.1"
  license any_of: ["MIT", "Apache-2.0"]

  # The URLs interpolate `version` so a release bump touches one version string and
  # four checksums, and nothing else. Before this, the version also appeared twice in
  # each of the four URLs -- eight more places to get wrong, which the release
  # checklist did not mention.
  on_macos do
    on_arm do
      url "https://github.com/gaborini/monitrs/releases/download/v#{version}/monitrs-#{version}-aarch64-apple-darwin.tar.gz"
      sha256 "2a36358e5f86426e394b65a56bed98465193de235818c0a25b60fc7fd104c138"
    end
    on_intel do
      url "https://github.com/gaborini/monitrs/releases/download/v#{version}/monitrs-#{version}-x86_64-apple-darwin.tar.gz"
      sha256 "2b9ce2a424cd7111d19b4c695c62f64de2c6fd0dbe280444a6b4627af5a0546d"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/gaborini/monitrs/releases/download/v#{version}/monitrs-#{version}-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "3923f49e68ae0b879f4d6261e08ec2fb199275ba4f4da97661dfe1785ec58b1c"
    end
    on_intel do
      url "https://github.com/gaborini/monitrs/releases/download/v#{version}/monitrs-#{version}-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "0b330c530f7c6104323193f60564d181f1c563d9b6ff6b9300d4f42341463712"
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
