class Texmacs < Formula
  desc "Free WYSIWYW editing platform for scientists"
  homepage "http://www.texmacs.org"
  url "http://www.texmacs.org/Download/ftp/tmftp/source/TeXmacs-1.99.1-src.tar.gz"
  sha256 "7e8425d65b1a02f270eaa021389cb9c3f627c9064cc986bd1ec7f66e0681b2ac"
  head "svn://svn.savannah.gnu.org/texmacs/trunk/src"

  depends_on "qt"
  depends_on "guile"
  depends_on "ghostscript"
  depends_on "imagemagick"
  depends_on :x11

  # Fails with clang and gcc4.8 due to out-of-spec C++.
  # Success with --cc=gcc-4.2

  def install
    system "./configure", "--disable-debug",
                          "--prefix=#{prefix}",
                          "--enable-guile2=yes"
    system "make"
    system "make", "install"
  end
end
