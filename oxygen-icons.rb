require "formula"

class OxygenIcons < Formula
  homepage "http://www.oxygen-icons.org/"
  url "ftp://ftp.kde.org/pub/kde/stable/4.11.4/src/oxygen-icons-4.11.4.tar.xz"
  sha1 "52350a2c230142b078dc5dfe95503ec82025c34d"

  depends_on "cmake" => :build

  def install
    system "cmake #{std_cmake_parameters} ."
    system "make install"
  end
end
