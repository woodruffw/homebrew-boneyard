class Qiv < Formula
  desc "Quick image viewer for X"
  homepage "http://spiegl.de/qiv/"
  url "http://spiegl.de/qiv/download/qiv-2.3.1.tgz"
  sha256 "675396b539e6511135fe73c867f9fdd6d912c24c7562797cb047c27d0c2c8ee6"

  head "http://bitbucket.org/ciberandy/qiv/", :using => :hg

  depends_on "pkg-config" => :build
  depends_on "gtk+"
  depends_on "imlib2"
  depends_on "libmagic"
  depends_on "little-cms2"
  depends_on "libexif"

  def install
    system "make", 'STATUSBAR_FONT="Monaco"', "CC=#{ENV.cc}"
    bin.install "qiv"
    man1.install "qiv.1"
  end

  test do
    system "#{bin}/qiv"
  end
end
