class Bcwipe < Formula
  homepage "http://www.jetico.com/linux/bcwipe-help/"
  url "http://www.jetico.com/linux/BCWipe-1.9-9.tar.gz"
  sha256 "831f69ae920b27629738ad25228e0c507fa934ce3f75ef10e829b1061299653f"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "CFLAGS=#{ENV.cflags}", "LDFLAGS=#{ENV.ldflags}", "install"
  end
end
