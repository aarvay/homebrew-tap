class Zvm < Formula
  desc "Install and switch between Zig toolchains and matching language servers"
  homepage "https://github.com/aarvay/zvm"
  url "https://github.com/aarvay/zvm/releases/download/v1.0.0/zvm-source.tar.gz"
  sha256 "b667fb5d337a5cee3b10d936431b1fe43d3451dce4c920bf414a6fa3cd7cdcbe"
  license "MIT"

  bottle do
    root_url "https://github.com/aarvay/homebrew-tap/releases/download/zvm-1.0.0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "fa21ef248aa349280a9796ef7def303c0a2129990b8a63829073790939fecc8a"
  end

  depends_on "flock"
  depends_on "jq"
  depends_on :macos

  def install
    bin.install "zvm"
    bash_completion.install "completions/zvm-completion.bash" => "zvm"
    zsh_completion.install "completions/_zvm"
    fish_completion.install "completions/zvm.fish"
  end

  def caveats
    <<~EOS
      zvm links the selected zig and zls into ~/.local/bin.
      Include that directory in your PATH to use the selected toolchain.
    EOS
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}/zvm --version").strip
    assert_match "install", shell_output("#{bin}/zvm --help")
    assert_path_exists zsh_completion/"_zvm"
    assert_path_exists bash_completion/"zvm"
    assert_path_exists fish_completion/"zvm.fish"
  end
end
