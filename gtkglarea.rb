class Gtkglarea < Formula
  desc "OpenGL context provider for GTK+"
  homepage "https://github.com/GNOME/gtkglarea"
  url "http://ftp.gnome.org/pub/GNOME/sources/gtkglarea/2.0/gtkglarea-2.0.1.tar.gz"
  sha256 "dffe1cc0512d20d3840d0a1f3eff727bf2207c5c6714125155ca0cee0b177179"

  depends_on :x11
  depends_on "gtk+"
  depends_on "pkg-config" => :build

  def install
    ENV.append "LDFLAGS", "-lX11"
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
