class DreamcoderDots < Formula
  desc "Dreamcoder OS - Token-governed visual operating layer"
  homepage "https://github.com/dreamcoder08/dreamcoder-dots"
  version "2.0.0"
  license "MIT"

  on_macos do
    on_arm64 do
      url "https://github.com/dreamcoder08/dreamcoder-dots/releases/download/v2.0.0/dreamcoder-dots-darwin-arm64"
      sha256 "b368e1532d2320a238f31acdd0767bd8b9bba26fee9fab3fab69d549150fc5df"
    end
    on_intel do
      url "https://github.com/dreamcoder08/dreamcoder-dots/releases/download/v2.0.0/dreamcoder-dots-darwin-amd64"
      sha256 "eda2f591edad9b487466dd4bd8cc89f984325391f33967de9ef9c8608ed0c2d0"
    end
  end

  on_linux do
    on_arm64 do
      url "https://github.com/dreamcoder08/dreamcoder-dots/releases/download/v2.0.0/dreamcoder-dots-linux-arm64"
      sha256 "3145ce981091ac80a09eca584cf0f768db4c7b81497a38621b49cf5eae4bb61e"
    end
    on_intel do
      url "https://github.com/dreamcoder08/dreamcoder-dots/releases/download/v2.0.0/dreamcoder-dots-linux-amd64"
      sha256 "d7ba3e22205fbfa00fb2a7aaedea33873cb6f9932738c70c430520a146c70915"
    end
  end

  def install
    bin.install "dreamcoder-dots"
  end

  test do
    assert_match "dreamcoder-dots", shell_output("#{bin}/dreamcoder-dots --version")
  end
end
