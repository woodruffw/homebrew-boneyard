class SyslogNg < Formula
  desc "Log management infrastructure"
  homepage "http://www.balabit.com/network-security/syslog-ng/"
  url "http://www.balabit.com/downloads/files/syslog-ng/sources/3.2.5/source/syslog-ng_3.2.5.tar.gz"
  sha256 "ffc9f3a0ebea836c1c737b1ff49efe731d885af1d8aacf9eca79d9144eeefa89"

  depends_on "pkg-config" => :build
  depends_on "pcre"
  depends_on "eventlog"
  depends_on "glib"

  def install
    ENV.append "LDFLAGS", "-levtlog -lglib-2.0" # help the linker find symbols
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--enable-dynamic-linking",
                          "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}",
                          "--localstatedir=#{var}"

    # the HAVE_ENVIRON check in configure fails
    # discussion for a fix is ongoing on the Homebrew mailing list, but for
    # now this is sufficient
    inreplace "config.h", '#define HAVE_ENVIRON 1', ""

    system "make", "install"
  end
end
