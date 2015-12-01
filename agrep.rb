class Agrep < Formula
  homepage "http://en.wikipedia.org/wiki/Agrep"
  url "ftp://ftp.cs.arizona.edu/agrep/agrep-2.04.tar.Z"
  sha256 "31275a2fee28fb8966e1978d26fe8113b61ce49b39e68ddf4cad3964db72d5f8"

  def install
    system "make", "CFLAGS=#{ENV.cflags}"
    bin.install "agrep"
    man1.install "agrep.1"
  end
end
