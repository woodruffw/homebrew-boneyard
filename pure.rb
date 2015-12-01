class Pure < Formula
  homepage "http://purelang.bitbucket.org/"
  url "https://bitbucket.org/purelang/pure-lang/downloads/pure-0.64.tar.gz"
  sha256 "efd55229342aec9d79e8fa4732a30f140e1773064f3869abde053e01468f7b07"

  needs :cxx11

  depends_on "llvm"
  depends_on "gmp"
  depends_on "readline"
  depends_on "mpfr"

  resource "docs" do
    url "https://bitbucket.org/purelang/pure-lang/downloads/pure-docs-0.64.tar.gz"
    sha256 "a140456f7d6feff8a15f5505a8fa3f9376afef88f1831ca98b93dc1d1764d110"
  end

  def install
    ENV.cxx11

    system "./configure", "--disable-debug",
                          "--prefix=#{prefix}",
                          "--enable-release",
                          "--without-elisp"

    system "make"
    system "make", "install"
    resource("docs").stage { system "make", "prefix=#{prefix}", "install" }
  end

  test do
    system "#{bin}/pure", "--version"
  end
end
