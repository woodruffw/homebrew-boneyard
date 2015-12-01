class Maatkit < Formula
  homepage "https://code.google.com/p/maatkit/"
  url "https://maatkit.googlecode.com/files/maatkit-7540.tar.gz"
  sha256 "618b8ba8f8df1c8ac04d127986a7bb6a834643523000c9c5ea4ee7d95aeef9a8"

  depends_on "DBD::mysql" => :perl

  def install
    system "perl Makefile.PL PREFIX=#{prefix}"
    system "make", "install"
  end
end
