class Kumofs < Formula
  desc "Scalable, highly available distributed key-value store"
  homepage "http://kumofs.sourceforge.net/"
  url "https://github.com/downloads/etolabo/kumofs/kumofs-0.4.12.tar.gz"
  sha256 "afbe4625a1df13ca9353bb6f2e4739de080de0c36cb1945f1e3869eba6e322bd"

  head "https://github.com/etolabo/kumofs.git"

  depends_on "tokyo-cabinet"
  # msgpack rubygem and the C++ lib are needed
  depends_on "msgpack"
  depends_on "msgpack" => :ruby

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-msgpack=#{Formula["msgpack"].opt_prefix}",
                          "--with-tokyocabinet=#{Formula["tokyo-cabinet"].opt_prefix}"
    system "make", "install"
  end
end
