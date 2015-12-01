class Clam < Formula
  homepage "http://clam-project.org"
  url "http://clam-project.org/download/src/CLAM-1.4.0.tar.gz"
  sha256 "36fb156b01bb88276962763fef18cd1533cc10d64f8d7824b4623bf5d761bd4d"

  depends_on "scons" => :build
  depends_on "xerces-c"
  depends_on "fftw"
  depends_on "libsndfile"
  depends_on "libvorbis"
  depends_on "mad"
  depends_on "jack"
  depends_on "portaudio"
  depends_on "id3lib"

  def install
    scons "configure", "prefix=#{prefix}", "with_ladspa=no", "xmlbackend=none"
    scons
    scons "install"
  end
end
