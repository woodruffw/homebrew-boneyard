class Tinyscheme < Formula
  desc "Very small Scheme implementation"
  homepage "http://tinyscheme.sourceforge.net"
  url "https://downloads.sourceforge.net/project/tinyscheme/tinyscheme/tinyscheme-1.41/tinyscheme-1.41.tar.gz"
  sha256 "eac0103494c755192b9e8f10454d9f98f2bbd4d352e046f7b253439a3f991999"

  # Modify compile flags for Mac OS X per instructions
  patch :p0 do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/2771d17/tinyscheme/patch-makefile.diff"
    sha256 "7833c190bb5527e18ea86c43ba26f6d26ff226334c0dd467988534c171890df0"
  end

  def install
    system "make", "INITDEST=#{share}"
    lib.install("libtinyscheme.dylib")
    share.install("init.scm")
    bin.install("scheme")
  end

  test do
    assert_match "Usage: tinyscheme", shell_output("#{bin}/scheme -\?", 1)
  end
end
