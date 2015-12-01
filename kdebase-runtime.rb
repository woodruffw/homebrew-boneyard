require "formula"

class KdebaseRuntime < Formula
  homepage "http://www.kde.org/"
  url "ftp://ftp.kde.org/pub/kde/stable/4.6.0/src/kdebase-runtime-4.6.0.tar.bz2"
  sha1 "024b7035a410f7c08e501ea1250553e746a469d2"

  depends_on "cmake" => :build
  depends_on "kde-phonon"
  depends_on "oxygen-icons"

  def install
    phonon = Formula.factory "kde-phonon"
    system "cmake #{std_cmake_parameters} -DPHONON_INCLUDE_DIR=#{phonon.include} -DPHONON_LIBRARY=#{phonon.lib}/libphonon.dylib -DBUNDLE_INSTALL_DIR=#{bin} ."
    system "make install"
  end
end
