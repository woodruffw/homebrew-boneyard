class P11Kit < Formula
  desc "Library to load and enumerate PKCS# 11 modules"
  homepage "http://p11-glue.freedesktop.org"
  # As of p11-kit 0.23.1, nothing newer than 0.18.4 works on OS X
  # Don't bother bumping this version unless they've fixed it.
  # https://bugs.freedesktop.org/show_bug.cgi?id=91602
  url "http://p11-glue.freedesktop.org/releases/p11-kit-0.18.4.tar.gz"
  sha256 "df5424ec39e17c2b3b98819bf772626e9b8c73871a8b82e54151f6297d8575fd"

  option :universal

  depends_on "pkg-config" => :build
  depends_on "libtasn1"

  def install
    ENV.universal_binary if build.universal?
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-trust-module"
    system "make"
    system "make", "check"
    system "make", "install"
  end

  test do
    system "#{bin}/p11-kit", "list-modules"
  end
end
