class Comparepdf < Formula
  homepage "http://www.qtrac.eu/comparepdf.html"
  url "http://www.qtrac.eu/comparepdf-1.0.1.tar.gz"
  sha256 "cfb092fc40a8ed1317af36a574a470280eaeffcb9056095a65c974abd060c82c"

  depends_on "qt"
  depends_on "poppler" => "with-qt4"

  def install
    # Generate makefile and disable .app creation
    if MacOS.version >= :mavericks && ENV.compiler == :clang
      spec = "unsupported/macx-clang-libc++"
    else
      spec = "macx-g++"
    end
    system "qmake", "-spec", spec, "CONFIG-=app_bundle"
    system "make"

    bin.install "comparepdf"
    man1.install "comparepdf.1"
  end
end
