class Eet < Formula
  desc "Library for writing arbitrary chunks of data to a file using compression"
  homepage "https://docs.enlightenment.org/auto/eet/eet_main.html"
  url "https://download.enlightenment.org/releases/eet-1.7.10.tar.gz"
  sha256 "c424821eb8ba09884d3011207b1ecec826bc45a36969cd4978b78f298daae1ee"

  conflicts_with "efl", :because => "efl aggregates formerly distinct libs, one of which is eet"

  head do
    url "https://git.enlightenment.org/legacy/eet.git/"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "eina"
  depends_on "jpeg"
  depends_on "lzlib"
  depends_on "openssl"

  conflicts_with "efl", :because => "both install `eet` binaries"

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    cp "#{pkgshare}/examples/eet-basic.c", testpath
    eina = Formula["eina"]
    system ENV.cc, "-o", "eet-basic", "eet-basic.c",
        "-I#{include}/eet-1",
        "-I#{eina.include}/eina-1",
        "-I#{eina.include}/eina-1/eina",
        "-L#{lib}",
        "-leet"
    system "./eet-basic"
  end
end
