class Jscoverage < Formula
  homepage "http://siliconforks.com/jscoverage/"
  url "http://siliconforks.com/jscoverage/download/jscoverage-0.5.1.tar.bz2"
  sha256 "c45f051cec18c10352f15f9844f47e37e8d121d5fd16680e2dd0f3b4420eb7f4"

  # Fixes compile errors with clang, int main should return a value
  # Reported upstream: http://siliconforks.com/jscoverage/bugs/42
  patch :DATA

  def install
    # Fix a hardcoded gcc and g++ configure error when clang.
    # Reported upstream: http://siliconforks.com/jscoverage/bugs/42
    inreplace "js/configure.gnu" do |f|
      f.gsub! "export CC=gcc", "export CC=#{ENV.cc}"
      f.gsub! "export CXX=g++", "export CXX=#{ENV.cxx}"
      f.gsub! "gcc -E", "#{ENV.cc} -E"
      f.gsub! "g++ -E", "#{ENV.cxx} -E"
    end

    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    bin.install("jscoverage")
    bin.install("jscoverage-server")
  end
end

__END__
--- a/js/configure	2010-09-23 05:00:00.000000000 -0700
+++ b/js/configure	2012-04-12 16:54:46.000000000 -0700
@@ -7820,7 +7820,6 @@
 int main() {
 
                      int a[sizeof (void*) == $size ? 1 : -1];
-                     return;
                    
 ; return 0; }
 EOF
@@ -7878,7 +7877,6 @@
 int main() {
 
                      int a[offsetof(struct aligner, a) == $align ? 1 : -1];
-                     return;
                    
 ; return 0; }
 EOF
@@ -7919,7 +7917,6 @@
 int main() {
 
                      int a[sizeof (double) == $size ? 1 : -1];
-                     return;
                    
 ; return 0; }
 EOF
