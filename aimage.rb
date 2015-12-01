class Aimage < Formula
  homepage "http://www.forensicswiki.org/wiki/Aimage"
  url "http://pkgs.fedoraproject.org/repo/pkgs/aimage/aimage-3.2.5.tar.gz/07a11d653cdd1d7a5aefe4d99cdbd408/aimage-3.2.5.tar.gz"
  sha256 "9c362dbb24a064af014677c30d9511ed65b4f2b2c5ea3ba051bc4c5ada635b11"

  depends_on "afflib"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
