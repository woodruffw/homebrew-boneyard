class Mlkit < Formula
  homepage "http://sourceforge.net/apps/mediawiki/mlkit"
  url "https://downloads.sourceforge.net/project/mlkit/mlkit-4.3.7/mlkit-4.3.7.tgz"
  sha256 "3fc4342baa0bf5ae9f1afdde4257e295d9756cd2b569107fd4b61da525eb0f73"

  depends_on "autoconf" => :build
  depends_on "mlton" => :build
  depends_on :tex
  depends_on "gmp"

  def install
    system "./autobuild; true"
    system "./configure", "--prefix=#{prefix}"
    ENV.m32
    system "make", "mlkit"
    system "make mlkit_libs"
    system "make", "install"
  end

  test do
    system "#{bin}/mlkit", "-V"
  end
end
