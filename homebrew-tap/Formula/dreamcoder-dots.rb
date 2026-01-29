class DreamcoderDots < Formula
  desc "Interactive TUI installer for Dreamcoder.Dots softwart engineering environment"
  homepage "https://github.com/Albert-fer02/Dreamcoder_dots"
  version "5.0.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/Albert-fer02/Dreamcoder_dots/releases/download/v#{version}/dreamcoder-installer-darwin-arm64"
      sha256 "PLACEHOLDER_SHA256_MAC_ARM"
    end
    on_intel do
      url "https://github.com/Albert-fer02/Dreamcoder_dots/releases/download/v#{version}/dreamcoder-installer-darwin-amd64"
      sha256 "PLACEHOLDER_SHA256_MAC_INTEL"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/Albert-fer02/Dreamcoder_dots/releases/download/v#{version}/dreamcoder-installer-linux-arm64"
      sha256 "PLACEHOLDER_SHA256_LINUX_ARM"
    end
    on_intel do
      url "https://github.com/Albert-fer02/Dreamcoder_dots/releases/download/v#{version}/dreamcoder-installer-linux-amd64"
      sha256 "PLACEHOLDER_SHA256_LINUX_INTEL"
    end
  end

  def install
    if OS.mac? && Hardware::CPU.arm?
      bin.install "dreamcoder-installer-darwin-arm64" => "dreamcoder-dots"
    elsif OS.mac? && Hardware::CPU.intel?
      bin.install "dreamcoder-installer-darwin-amd64" => "dreamcoder-dots"
    elsif OS.linux? && Hardware::CPU.arm?
      bin.install "dreamcoder-installer-linux-arm64" => "dreamcoder-dots"
    elsif OS.linux? && Hardware::CPU.intel?
      bin.install "dreamcoder-installer-linux-amd64" => "dreamcoder-dots"
    end
  end

  test do
    system "#{bin}/dreamcoder-dots", "--help"
  end
end
