class Clay < Formula
  desc "Language designed for generic programming"
  homepage "https://github.com/jckarter/clay"
  url "https://github.com/jckarter/clay/archive/v0.1.2.tar.gz"
  sha256 "a35480b8f995115366308206b518ee81c680b3b9be8ac6e5c02f3205c265cfdd"

  head "https://github.com/jckarter/clay.git"

  depends_on "cmake" => :build
  depends_on "llvm"  => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    system "#{bin}/clay", "-e", "println(\"Hello, Clay!\");"
  end
end
