class Flusspferd < Formula
  homepage "https://flusspferd.github.io/"
  url "https://github.com/Flusspferd/flusspferd/archive/v0.9.tar.gz"
  sha256 "43f2b74bdde832ca0f85c6ff764956d5bde8945a61e625758a7b0801103317de"

  depends_on "cmake" => :build
  depends_on "arabica"
  depends_on "gmp"
  depends_on "boost"
  depends_on "spidermonkey"

  fails_with_llvm

  def install
    system "cmake -H. -Bbuild #{std_cmake_parameters}"
    system "make", "install"
  end
end
