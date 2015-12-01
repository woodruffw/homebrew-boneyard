# FIXME: this can be removed on the next release
# OSX has case-insensitive file names, and the Mat archive contains a "MAT"
# directory *and* a "mat" file. `tar xf` will fail on it, so we rename "mat"
# into "mat-cli" here.
class MatDownloadStrategy < CurlDownloadStrategy
  def stage
    with_system_path { safe_system "#{xzpath} -dc \"#{cached_location}\" | tar xf - -s ',/mat$,/mat-cli,'" }
    chdir
  end
end

class Mat < Formula
  desc "Metadata anonymization toolkit"
  homepage "https://mat.boum.org/"
  url "https://mat.boum.org/files/mat-0.5.2.tar.xz", :using => MatDownloadStrategy
  sha256 "93b850a733373b98965516a743f09de7a1a07a4d40597363517c0fe92c7df113"

  depends_on :python => :optional
  depends_on "coreutils"
  depends_on "poppler"
  depends_on "intltool" => :build
  depends_on "gettext" => :build

  depends_on "exiftool" => :optional

  option "with-massive-audio", "Enable massive audio format support"

  # mat relies on `shred`, which is called `gshred` on OSX with coreutils, and
  # import the "gi" python module which is not available here.
  # Fixed upstream for next version.
  patch :DATA

  resource "hachoir-core" do
    url "https://pypi.python.org/packages/source/h/hachoir-core/hachoir-core-1.3.3.tar.gz"
    sha256 "ecf5d16eccc76b22071d6062e54edb67595f70d827644d3a6dff04289b4058df"
  end

  resource "hachoir-parser" do
    url "https://pypi.python.org/packages/source/h/hachoir-parser/hachoir-parser-1.3.4.tar.gz"
    sha256 "775be5e10d72c6122b1ba3202dfce153c09ebcb60080d8edbd51aa89aa4e6b3f"
  end

  resource "pdfrw" do
    url "https://pypi.python.org/packages/source/p/pdfrw/pdfrw-0.1.tar.gz"
    sha256 "8a85cb87b888c030d87cc3fce10ad93e5f99e721b80b99bf50e29a074c048f83"
  end

  resource "distutils-extra" do
    url "https://launchpad.net/python-distutils-extra/trunk/2.38/+download/python-distutils-extra-2.38.tar.gz"
    sha256 "3d100d5d3492f40b3e7a6a4500f71290bfa91e2c50dc31ba8e3ff9b5d82ca153"
  end

  resource "mutagen" do
    url "https://pypi.python.org/packages/source/m/mutagen/mutagen-1.22.tar.gz"
    sha256 "a2ea5b5099ce14ab84c628e9d0a91217df20d2e3459a707f2eba9a354f52da91"
  end

  def install
    ENV["PYTHONPATH"] = lib+"python2.7/site-packages"
    ENV.prepend_create_path "PYTHONPATH", libexec+"lib/python2.7/site-packages"

    %w[hachoir-core hachoir-parser pdfrw distutils-extra].each do |r|
      resource(r).stage do
        pyargs = ["setup.py", "install", "--prefix=#{libexec}"]
        unless %w[hachoir-core hachoir-parser pdfrw].include? r
          pyargs << "--single-version-externally-managed" << "--record=installed.txt"
        end
        system "python", *pyargs
      end
    end

    if build.with? "massive-audio"
      resource("mutagen").stage do
        system "python", "setup.py", "install", "--prefix=#{libexec}"
      end
    end

    # Installs Mat as mat-cli temporarily
    inreplace "setup.py", "'mat'", "'mat-cli'"

    system "python", "setup.py", "install", "--prefix=#{prefix}"

    # move executable back to its real name
    mv bin/"mat-cli", bin/"mat"
    # Since we don't support it, Let's remove the GUI binary.
    rm bin/"mat-gui"
    # Install manpages into expected directory.
    man1.install Dir["*.1"]

    bin.env_script_all_files(libexec+"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    system "#{bin}/mat", "-l"
    system "touch", "foo"
    system "tar", "cf", "foo.tar", "foo"
    system "#{bin}/mat", "-c", "foo.tar"
  end

  def caveats; <<-EOS.undent
      MAT was built without PDF support nor GUI.
    EOS
  end
end
__END__
diff --git a/mat-0.5.2/_MAT/mat.py b/mat-0.5.2/_MAT/mat.py
index 5b1fbda..5ea2b22 100644
--- a/MAT/mat.py
+++ b/MAT/mat.py
@@ -120,7 +120,7 @@ def secure_remove(filename):
         raise MAT.exceptions.UnableToWriteFile

     try:
-        if not subprocess.call(['shred', '--remove', filename]):
+        if not subprocess.call(['gshred', '--remove', filename]):
             return True
         else:
             raise OSError
diff --git a/mat-0.5.2/_MAT/strippers.py b/mat-0.5.2/_MAT/strippers.py
index aea98da..42ea8fc 100644
--- a/MAT/strippers.py
+++ b/MAT/strippers.py
@@ -3,7 +3,6 @@

 import archive
 import audio
-import gi
 import images
 import logging
 import mat
