class Gtkglextmm < Formula
  homepage "http://projects.gnome.org/gtkglext"
  url "https://downloads.sourceforge.net/gtkglext/gtkglextmm-1.2.0.tar.gz"
  sha256 "8f499c1f95678c56cce908c10bf2c1d0f2267b87e0c480385fa4b128c75bdf7b"

  depends_on "pkg-config" => :build
  depends_on "gtkglext"
  depends_on "gtkmm"
  depends_on :x11

  # Fixes header include order, using patch from macports: https://trac.macports.org/ticket/27059
  # Upstream bug report: https://bugzilla.gnome.org/show_bug.cgi?id=636831
  def patches
    { :p0 => "https://trac.macports.org/export/89836/trunk/dports/devel/gtkglextmm/files/patch-gtkglext_gtkmm_gl-widget.cc.diff" }
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
