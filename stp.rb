class Stp < Formula
  desc "Simple Theorem Prover"
  homepage "https://stp.github.io/"
  head "http://stp-fast-prover.svn.sourceforge.net/svnroot/stp-fast-prover/trunk/stp",
    :revision => "1134"

  def install
    system "./scripts/configure", "--with-prefix=#{prefix}"
    system "make", "install"
  end
end
