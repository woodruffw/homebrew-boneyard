class Drizzle < Formula
  homepage "http://www.drizzle.org"
  url "https://launchpad.net/drizzle/7.1/7.1.36/+download/drizzle-7.1.36-stable.tar.gz"
  sha256 "ee7fb86a58c6c017e451d68ca1b7b9247183e6f9f188035b01b04818f1d9269c"

  depends_on :macos => :lion
  depends_on "intltool" => :build

  # https://github.com/mxcl/homebrew/issues/14289
  depends_on "boost149"
  depends_on "protobuf"
  depends_on "libevent"
  depends_on "pcre"
  depends_on "libgcrypt"
  depends_on "readline"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
