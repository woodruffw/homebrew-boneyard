class Sitecopy < Formula
  desc "Remote websites maintainance"
  homepage "http://www.manyfish.co.uk/sitecopy/"
  url "http://www.manyfish.co.uk/sitecopy/sitecopy-0.16.6.tar.gz"
  sha256 "e06fdda007e54ddc6fae90a4e79768e5bfb7770c1139bcaac2e10d841d7458af"

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-libxml2",
                          "--with-ssl"
    system "make", "install"
  end

  test do
    # Actual functionality testing requires remote access to a server.
    system bin/"sitecopy", "-V"
  end
end
