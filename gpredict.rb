class Gpredict < Formula
  homepage "http://gpredict.oz9aec.net/"
  url "https://downloads.sourceforge.net/project/gpredict/Gpredict/1.3/gpredict-1.3.tar.gz"
  sha256 "b0f6beed8da1b2c513ba1f22593195c6097fc7ccfc66cba4bdbc16277238d5a3"

  depends_on :x11
  depends_on "pkg-config" => :build
  depends_on "intltool" => :build
  depends_on "curl"
  depends_on "gettext"
  depends_on "glib"
  depends_on "goocanvas"
  depends_on "gtk+"
  depends_on "hamlib"

  def install
    gettext = Formula["gettext"]
    ENV.append "CFLAGS", "-I#{gettext.include}"
    ENV.append "LDFLAGS", "-L#{gettext.lib}"

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
