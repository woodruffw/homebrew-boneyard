class Guilt < Formula
  homepage "http://packages.debian.org/wheezy/guilt"
  url "http://ftp.de.debian.org/debian/pool/main/g/guilt/guilt_0.35.orig.tar.gz"
  sha256 "82df72571b8f50b5428ad75ccc7388ceb7f8e3b57e2c03b16e5b6cfe930f6381"

  def install
    # Skip the documentation, it depends on xmlto.
    system "make", "PREFIX=#{prefix}", "install"
  end
end
