require "formula"

class Qimageblitz < Formula
  homepage "http://www.kde.org"
  url "ftp://ftp.kde.org/pub/kde/stable/qimageblitz/qimageblitz-0.0.6.tar.bz2"
  sha1 "32bcda9adb262ef49c62e3a7adbfcdeec98f72e4"

  depends_on "cmake" => :build
  depends_on "qt"

  def install
    system "cmake #{std_cmake_parameters} ."
    system "make install"
  end
end
