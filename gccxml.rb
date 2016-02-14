class Gccxml < Formula
  homepage "https://gccxml.github.io/"
  head "https://github.com/gccxml/gccxml.git"

  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end
end
