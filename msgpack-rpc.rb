class MsgpackRpc < Formula
  homepage "https://github.com/msgpack/msgpack-rpc"
  url "http://msgpack.org/releases/cpp/msgpack-rpc-0.3.1.tar.gz"
  sha256 "9f54c13e393c6e568ded1b45adec143473caf7284a8013d333fb783ccef921ff"

  depends_on "msgpack"
  depends_on "mpio"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
