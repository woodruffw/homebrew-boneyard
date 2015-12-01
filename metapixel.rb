class Metapixel < Formula
  homepage "http://www.complang.tuwien.ac.at/schani/metapixel/"
  url "http://www.complang.tuwien.ac.at/schani/metapixel/files/metapixel-1.0.2.tar.gz"
  sha256 "8d77810978da397c070b9b4e228ae6204e9f5c524518ad1a4fcab9462171f55b"

  depends_on "jpeg"
  depends_on "giflib"

  def install
    man1.mkpath
    # separate steps
    system "make", "CC=#{ENV.cc}",
                   "MACOS_LDOPTS=-L#{HOMEBREW_PREFIX}/lib",
                   "MACOS_CCOPTS=#{ENV.cflags} -I#{HOMEBREW_PREFIX}/include"
    system "make", "PREFIX=#{prefix}", "install"
  end
end
