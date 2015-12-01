require "formula"

class Attica < Formula
  homepage "http://www.kde.org/"
  url "ftp://ftp.kde.org/pub/kde/stable/attica/attica-0.2.0.tar.bz2"
  sha1 "724c6e9aab662280ec5b6570b23cf1cfc6c28cc7"

  depends_on "cmake" => :build

  def install
    system "cmake #{std_cmake_parameters} ."
    system "make install"
  end
end
