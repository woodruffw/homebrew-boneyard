class Qfits < Formula
  homepage "http://www.eso.org/sci/software/eclipse/qfits/index.html"
  url "ftp://ftp.eso.org/pub/qfits/qfits-6.2.0.tar.gz"
  sha256 "3271469f8c50310ed88d1fd62a07c8bbd5b361e102def1dce3478d1a6b104b54"

  def install
    # qfits does not support 64bit build
    ENV.m32
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "install"
  end
end
