class Embryo < Formula
  desc "Version of the original Small abstract machine"
  homepage "https://docs.enlightenment.org/stable/efl/embryo_main.html"
  url "https://download.enlightenment.org/releases/embryo-1.7.10.tar.gz"
  sha256 "d6700ba34d7903f53695246ca3edd3fe463ed1acbadd283219ec9678bc4989a0"

  head do
    url "https://git.enlightenment.org/legacy/embryo.git/"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "eina"

  conflicts_with "efl", :because => "both install `embryo_cc` binaries"

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
