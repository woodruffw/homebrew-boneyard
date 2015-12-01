class Mysqlreport < Formula
  homepage "http://hackmysql.com/mysqlreport"
  url "http://hackmysql.com/scripts/mysqlreport-3.5.tgz"
  sha256 "e2addf769aab7742183a389bbc79d22f4567906e3f2225fbb2481f8e8a8f9fa3"

  def install
    bin.install "mysqlreport"
    doc.install Dir["*.html"]
  end
end
