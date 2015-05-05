class ShellFm < Formula
  url "https://github.com/jkramer/shell-fm/archive/v0.8.tar.gz"
  homepage "http://nex.scrapping.cc/shell-fm/"
  sha256 "e640b614f733a61f281cffe300a4f2419e0968f8f5592d2059dd51d0e430eab0"
  head "https://github.com/jkramer/shell-fm.git"

  # homepage says that libao is optional, but it doesn't seem
  # to build without it
  depends_on "pkg-config" => :build
  depends_on "libao"
  depends_on "mad"

  def install
    # 'make install' fails if this exists
    rm "INSTALL"
    system "make"
    system "make", "MANDIR=#{man}", "PREFIX=#{prefix}", "install"
  end

  test do
    system "#{bin}/shell-fm", "-h"
  end
end
