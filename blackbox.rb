class Blackbox < Formula
  homepage "http://www.cs.rochester.edu/u/kautz/satplan/blackbox/"
  url "http://www.cs.rochester.edu/u/kautz/satplan/blackbox/Blackbox44.tgz"
  sha256 "bf63cb7dffa8be6871bc2d059cd636f9ecb40cfacf510ec66880a6af43625ff1"

  def install
    system "make"
    bin.install "blackbox"
  end
end
