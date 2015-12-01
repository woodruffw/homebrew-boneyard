class Pngwriter < Formula
  url "https://downloads.sourceforge.net/project/pngwriter/pngwriter/pngwriter-0.5.4/pngwriter-0.5.4.zip"
  homepage "http://pngwriter.sourceforge.net/"
  sha256 "d8b99b9bdd794a9709373812aedd4f89530e387224465b2ae0cd88dfefeeee2f"

  def install
    # the zip file contains one more directory
    cd("pngwriter-0.5.4")
    # use the OSX specific makefile
    ln_sf("make.include.osx", "make.include")
    system "make PREFIX=#{prefix}"
    system "make install PREFIX=#{prefix}"
  end
end
