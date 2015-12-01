class Dupx < Formula
  homepage "http://www.isi.edu/~yuri/dupx/"
  url "http://www.isi.edu/~yuri/dupx/dupx-0.1.tar.gz"
  sha256 "7837501162a6387320d1327ec61abc260c3b8c06c9985d41e1f0c3b52f9f9f41"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end
end
