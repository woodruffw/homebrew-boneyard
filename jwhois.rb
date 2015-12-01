class Jwhois < Formula
  url "http://ftpmirror.gnu.org/jwhois/jwhois-4.0.tar.gz"
  mirror "https://ftp.gnu.org/gnu/jwhois/jwhois-4.0.tar.gz"
  homepage "http://directory.fsf.org/project/jwhois/"
  sha256 "fa9bb86782b915c6d730bb723f876dc9b345a617db375aaf3416ec22553cd64e"

  # No whois entry in /etc/services. Use nicname instead.
  patch :DATA

  def install
    # link fails on libiconv if not added here
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "LIBS=-liconv"
    system "make", "install"
  end
end


__END__
diff --git a/src/dns.c b/src/dns.c
index a818237..b5fe9c8 100644
--- a/src/dns.c
+++ b/src/dns.c
@@ -113,7 +113,7 @@ int
 lookup_host_addrinfo(struct addrinfo **res, const char *host, int port)
 {
   struct addrinfo hints;
-  char ascport[10] = "whois";
+  char ascport[10] = "nicname";
   int error;
 
   memset(&hints, 0, sizeof(hints));
