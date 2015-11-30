class Solfege < Formula
  desc "Ear training software"
  homepage "https://www.gnu.org/software/solfege/"
  url "http://ftpmirror.gnu.org/solfege/solfege-3.20.6.tar.xz"
  mirror "https://ftp.gnu.org/gnu/solfege/solfege-3.20.6.tar.xz"
  sha256 "f84b336ae7e24ce2472cd50df178061df4ad76f785540b926dc097d680622730"

  depends_on "pkg-config" => :build
  depends_on "gettext"      => :build
  depends_on "pygtk"        => :recommended
  depends_on "qtplay"       => :recommended
  depends_on "librsvg"      => :recommended
  depends_on "vorbis-tools" => :recommended

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  def caveats
    <<-EOS.undent
      After installing Solfege, one of your programs, gdk-pixbuf, needs to be
      told to update its loader cache so it can read svg files. Run this once:

          export GDK_PIXBUF_MODULEDIR=#{HOMEBREW_PREFIX}/lib/gdk-pixbuf-2.0/2.10.0/loaders
          gdk-pixbuf-query-loaders --update-cache

      After doing that, you will be able to run solfege normally. You can go
      into Solfege Preferences and set your external programs to qtplay and
      ogg123 which get installed as dependencies, or you can use your own apps.
    EOS
  end
end
