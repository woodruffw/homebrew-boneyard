class TelepathyGlib < Formula
  desc "Telepathy GLib library for clients and connection managers"
  homepage "https://wiki.freedesktop.org/telepathy/"
  url "http://telepathy.freedesktop.org/releases/telepathy-glib/telepathy-glib-0.99.11.tar.gz"
  sha256 "268cbf0199804ecb6001c7c11e5596bc3cea40a600091c144d14f837ac90cd97"

  depends_on "pkg-config" => :build
  depends_on "intltool" => :build
  depends_on "gobject-introspection"
  depends_on "dbus-glib"

  def install
    system "./configure", "--disable-debug",
                          "--prefix=#{prefix}",
                          "--enable-introspection=yes",
                          "--disable-installed-tests",
                          "--disable-installed-examples",
                          "--disable-gtk-doc-html"
    system "make", "install"
  end
end
