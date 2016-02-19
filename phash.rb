class Phash < Formula
  desc "Perceptual hash library"
  homepage "http://www.phash.org/"
  url "http://phash.org/releases/pHash-0.9.6.tar.gz"
  sha256 "3c8258a014f9c2491fb1153010984606805638a45d00498864968a9a30102935"
  revision 1

  option "without-image-hash", "Disable image hash"
  option "without-video-hash", "Disable video hash"
  option "without-audio-hash", "Disable audio hash"

  deprecated_option "disable-image-hash" => "without-image-hash"
  deprecated_option "disable-video-hash" => "without-video-hash"
  deprecated_option "disable-audio-hash" => "without-audio-hash"

  depends_on "cimg" if build.with?("image-hash") || build.with?("video-hash")
  depends_on "ffmpeg" if build.with? "video-hash"

  if build.with? "audio-hash"
    depends_on "libsndfile"
    depends_on "libsamplerate"
    depends_on "mpg123"
  end

  fails_with :clang do
    build 318
    cause "configure: WARNING: CImg.h: present but cannot be compiled"
  end

  def install
    inreplace "src/ph_fft.h", "/usr/include/complex.h", "#{MacOS.sdk_path}/usr/include/complex.h"

    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
      --enable-shared
    ]

    args << "--disable-image-hash" if build.without? "image-hash"
    args << "--disable-video-hash" if build.without? "video-hash"
    args << "--disable-audio-hash" if build.without? "audio-hash"

    system "./configure", *args
    system "make", "install"
  end
end
