class Catdoc < Formula
  homepage "http://wagner.pp.ru/~vitus/software/catdoc/"
  url "http://ftp.wagner.pp.ru/pub/catdoc/catdoc-0.94.2.tar.gz"
  sha256 "03c98b103664e5d1b63de110854e93c2453bc10be5634f86c280303eb843d362"

  fails_with :clang do
    cause "The source uses undocumented behavior (decrementing null)."
  end

  def install
    # catdoc configure says it respects --mandir=, but does not.
    ENV["man1dir"] = man1
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    # The INSTALL file confuses make on case insensitive filesystems.
    system "mv INSTALL INSTALL.txt"
    system "make"
    # There is a race condition in the charsets/Makefile install target. The following line solves it.
    system "make -C charsets install-dirs"
    system "make", "install"
  end
end
