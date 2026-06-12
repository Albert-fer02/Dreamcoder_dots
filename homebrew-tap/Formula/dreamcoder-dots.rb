class DreamcoderDots < Formula
  desc "Dreamcoder OS - Token-governed visual operating layer"
  homepage "https://github.com/dreamcoder08/dreamcoder-dots"
  version "2.0.0"
  license "MIT"

  on_macos do
    on_arm64 do
      url "https://github.com/dreamcoder08/dreamcoder-dots/releases/download/v2.0.0/dreamcoder-dots-darwin-arm64"
      sha256 "PLACEHOLDER_SHA256_DARWIN_ARM64"
    end
    on_intel do
      url "https://github.com/dreamcoder08/dreamcoder-dots/releases/download/v2.0.0/dreamcoder-dots-darwin-amd64"
      sha256 "PLACEHOLDER_SHA256_DARWIN_AMD64"
    end
  end

  on_linux do
    on_arm64 do
      url "https://github.com/dreamcoder08/dreamcoder-dots/releases/download/v2.0.0/dreamcoder-dots-linux-arm64"
      sha256 "PLACEHOLDER_SHA256_LINUX_ARM64"
    end
    on_intel do
      url "https://github.com/dreamcoder08/dreamcoder-dots/releases/download/v2.0.0/dreamcoder-dots-linux-amd64"
      sha256 "PLACEHOLDER_SHA256_LINUX_AMD64"
    end
  end

  def install
    bin.install "dreamcoder-dots"
  end

  test do
    assert_match "dreamcoder-dots", shell_output("#{bin}/dreamcoder-dots --version")
  end
end
