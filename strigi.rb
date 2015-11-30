class Strigi < Formula
  desc "Program for fast indexing and searching personal data"
  homepage "http://www.vandenoever.info/software/strigi/"
  url "http://www.vandenoever.info/software/strigi/strigi-0.7.2.tar.bz2"
  sha256 "1ca421bbe420d1839bbe6bfe7c4b52a05590a9b7a7eda77924b554c98e602ab8"

  depends_on "cmake" => :build
  depends_on "clucene"
  depends_on "exiv2" => :optional

  def install
    ENV["CLUCENE_HOME"] = HOMEBREW_PREFIX
    ENV["EXPAT_HOME"] = "/usr/"

    system "cmake", ".", "-DENABLE_EXPAT:BOOL=ON",
                         "-DENABLE_DBUS:BOOL=OFF",
                         *std_cmake_parameters
    system "make", "install"
  end
end
