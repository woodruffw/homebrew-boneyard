class Tmap < Formula
  desc "Torrent Mapping Alignment Program"
  homepage "https://github.com/iontorrent/TMAP"
  url "https://github.com/iontorrent/TMAP.git",
    :tag => "tmap.3.2.0", :revision => "115c3149c64ef808fad8908e37aca0023f032cff"

  head "https://github.com/iontorrent/TMAP.git"

  env :std

  option "with-32-bit"
  option "with-indels", "Enable adjacent insertion and deletions in the alignment"
  option "with-perf", "Enable google performance tools for profiling and heap checking"
  option "without-color", "Disable terminal coloring"

  deprecated_option "32-bit" => "with-32-bit"
  deprecated_option "indels" => "with-indels"
  deprecated_option "perf" => "with-perf"
  deprecated_option "nocolor" => "without-color"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "google-perftools" if build.with? "perf"

  fails_with :clang do
    build 425
    cause "Missing symbols being discussed in iontorrent/TMAP#3"
  end

  def install
    system "sh", "autogen.sh"
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
    ]
    args << "--enable-32bit-support" if build.with?("32-bit") || !MacOS.prefer_64_bit?
    args << "--enable-perftools" if build.with? "perf"
    args << "--disable-coloring" if build.without? "color"
    args << "--enable-adjacent-indels" if build.with? "indels"

    system "./configure", *args
    ENV.j1
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/tmap", "-v"
  end
end
