class Soprano < Formula
  desc "Object-oriented C++/Qt4 framework for RDF data"
  homepage "http://soprano.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/soprano/Soprano/2.6.0/soprano-2.6.0.tar.bz2"
  sha256 "02f754662cff357d54f4e978f648574e3c29b8c4235c3e76e5b388cd2061cd35"

  depends_on "cmake" => :build
  depends_on "qt"
  depends_on "clucene" => :optional
  depends_on "raptor" => :optional
  depends_on "redland" => :optional

  def install
    ENV["CLUCENE_HOME"] = HOMEBREW_PREFIX

    system "cmake", ".", *std_cmake_parameters
    system "make", "install"
  end
end
