class Mydumper < Formula
  homepage "https://launchpad.net/mydumper"
  url "https://launchpad.net/mydumper/0.5/0.5.2/+download/mydumper-0.5.2.tar.gz"
  sha256 "a7f780f030036eb360488613a220029d59a2e20733641cc9e24ef6f3431e88cd"

  depends_on "pkg-config" => :build
  depends_on "cmake" => :build
  depends_on :mysql
  depends_on "glib"
  depends_on "pcre"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    system "#{bin}/mydumper", "--version"
  end
end
