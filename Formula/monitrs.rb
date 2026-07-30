# A binary formula: it installs the archives the release workflow already builds and
# attests, so nobody needs a Rust toolchain to install monitrs.
#
# Lives in a tap of its own — `gaborini/homebrew-monitrs`, `Formula/monitrs.rb` — because
# homebrew-core's notability bar for a self-submission is 225 stars, 90 forks or 90
# watchers, and this project has none of those yet.
class Monitrs < Formula
  desc "Fast, keyboard-first system cockpit for Linux and macOS"
  homepage "https://github.com/gaborini/monitrs"
  version "0.2.0"
  license any_of: ["MIT", "Apache-2.0"]

  on_macos do
    on_arm do
      url "https://github.com/gaborini/monitrs/releases/download/v0.2.0/monitrs-0.2.0-aarch64-apple-darwin.tar.gz"
      sha256 "590f97123bbf50f7fe711246547d7c27a1008bef178a98d179b94895031a3405"
    end
    on_intel do
      url "https://github.com/gaborini/monitrs/releases/download/v0.2.0/monitrs-0.2.0-x86_64-apple-darwin.tar.gz"
      sha256 "75ecd8f427a26fe31fe735f89b9fddb5ab2d1a45d9de60775171ba28b49e584f"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/gaborini/monitrs/releases/download/v0.2.0/monitrs-0.2.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "82deba4c0321a5243d4dbd4878c716fc55e823f7085f6376f31e1bd4bf742abb"
    end
    on_intel do
      url "https://github.com/gaborini/monitrs/releases/download/v0.2.0/monitrs-0.2.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "e65ec1dd226c0d8fcbb38951fe189c625059f1f7c92d0954d1f257a0197889bc"
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
