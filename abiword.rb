class Abiword < Formula
  homepage "http://www.abisource.com/"
  url "http://www.abisource.com/downloads/abiword/2.8.6/source/abiword-2.8.6.tar.gz"
  sha256 "d99089a63a6cfc1a6a4a026be9278028d47d224088d24b1853acb67e95683a15"

  devel do
    url "http://www.abisource.com/downloads/abiword/2.9.4/source/abiword-2.9.4.tar.gz"
    sha256 "d06b731feb23cbe7b28f5a4afd875e013bfecf8482f7a8bead0afaf74370bbd4"
  end

  depends_on "libpng"
  depends_on "jpeg"
  depends_on "fribidi"
  depends_on "libgsf"
  depends_on "enchant"
  depends_on "cairo"
  depends_on "pango"
  depends_on "wv"
  depends_on "imagemagick"

  fails_with :clang do
    build 421
    cause "error: static_cast from 'id' to 'XAP_Menu_Id' (aka 'int') is not allowed"
  end

  def patches
    {
      # Fixes newer libpng versions; needed for libpng 1.2, too
      :p0 => "https://trac.macports.org/export/102401/trunk/dports/editors/abiword-x11/files/patch-libpng-1.5.diff",
      # Fixes bad glib include
      :p1 => DATA,
    } if build.stable?
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end

__END__
diff --git a/src/af/util/xp/ut_go_file.h b/src/af/util/xp/ut_go_file.h
index e29d7b7..8d5f608 100644
--- a/src/af/util/xp/ut_go_file.h
+++ b/src/af/util/xp/ut_go_file.h
@@ -31,7 +31,6 @@
 
 #include <glib.h>
 #include <gsf/gsf.h>
-#include <glib/gerror.h>
 #include <time.h>
 
 G_BEGIN_DECLS
