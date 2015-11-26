class CurlXZDownloadStrategy < CurlDownloadStrategy
  def stage
    # As far as I can tell, the LZMA format does not have any magic header bits that we could use to
    # identify LZMA archives in the CurlDownloadStrategy, so use this awesome hack
    safe_system "lzma -k --force --stdout --decompress #{@tarball_path} | /usr/bin/tar x"

    # You could also do this, but it leaves the tar file lying around...
    # safe_system '/usr/local/bin/lzma', '-k', '--force', '--decompress', @tarball_path
    # safe_system '/usr/bin/tar', 'xf', @tarball_path.to_s.gsub( ".lzma", "" )
    chdir
  end
end

class TexLive < Formula
  desc "Easy way to get up and running with TeX"
  homepage "http://www.tug.org/texlive/"
  # OpenBSD mirrors are slower but more reliable
  url "ftp://tug.org/texlive/historic/2008/texlive-20080816-source.tar.lzma",
    :using => CurlXZDownloadStrategy
  sha256 "60cf277a60311756ea51ed7e6c50b50d4069f4b4c007b11c114ca5c640e5a3c2"

  depends_on "xz" => :build
  depends_on "gd"
  depends_on :x11

  fails_with :llvm

  env :std

  resource "texmf" do
    url "ftp://tug.org/texlive/historic/2008/texlive-20080822-texmf.tar.lzma",
      :using => CurlXZDownloadStrategy
    sha256 "112da34afd287340188ce73261ca4e57ea0242c3056f7a4b8a6094a063c54df3"
  end

  def patches
    # Steal all the TexLive 2008 OpenBSD patches
    patches = [
      "configure?rev=1.1",
      "libs_configure?rev=1.1",
      "libs_graphite-engine_configure?rev=1.1",
      "libs_icu-xetex_Makefile_in?rev=1.2",
      # Hijacked: we needed to add a CFLAG to the patch, so I merged this and my change below
      # {}"libs_lua51_Makefile",
      "libs_lua51_lcoco_c?rev=1.1",
      "libs_lua51_lcoco_h?rev=1.1",
      "texk_afm2pl_Makefile_in?rev=1.2",
      "texk_bibtex8_Makefile_in?rev=1.2",
      "texk_cjkutils_conv_Makefile_in?rev=1.3",
      "texk_cjkutils_hbf2gf_Makefile_in?rev=1.2",
      "texk_cjkutils_scripts_Makefile_in?rev=1.3",
      "texk_dtl_Makefile_in?rev=1.2",
      "texk_dvidvi_Makefile_in?rev=1.2",
      "texk_dviljk_Makefile_in?rev=1.2",
      "texk_dvipdfm_Makefile_in?rev=1.2",
      "texk_dvipng_configure?rev=1.1",
      "texk_dvipos_Makefile_in?rev=1.2",
      "texk_dvipsk_Makefile_in?rev=1.2",
      "texk_gsftopk_Makefile_in?rev=1.2",
      "texk_kpathsea_Makefile_in?rev=1.2",
      # Replaced with some ruby code below, we need a different approach
      # "texk_kpathsea_texmf_cnf?rev=1.1",
      "texk_lacheck_Makefile_in?rev=1.2",
      "texk_make_man_mk?rev=1.2",
      "texk_makeindexk_Makefile_in?rev=1.2",
      "texk_musixflx_Makefile_in?rev=1.2",
      "texk_ps2pkm_Makefile_in?rev=1.2",
      "texk_seetexk_Makefile_in?rev=1.2",
      "texk_tetex_Makefile_in?rev=1.2",
      "texk_tex4htk_Makefile_in?rev=1.2",
      "texk_texlive_Makefile_in?rev=1.2",
      "texk_texlive_linked_scripts_texdoc_tlu?rev=1.1",
      "texk_ttf2pk_Makefile_in?rev=1.2",
      "texk_web2c_Makefile_in?rev=1.2", # not in OPENBSD_4_6_BASE
      "texk_web2c_alephdir_aleph_mk?rev=1.2",
      "texk_web2c_configure?rev=1.2",
      "texk_web2c_doc_Makefile_in?rev=1.2",
      "texk_web2c_luatexdir_luatex_mk?rev=1.1",
      "texk_web2c_mpware_Makefile_in?rev=1.2",
      "texk_web2c_omegadir_omega_mk?rev=1.2",
      "texk_web2c_omegafonts_Makefile_in?rev=1.2",
      "texk_web2c_otps_Makefile_in?rev=1.2",
      "texk_web2c_pdftexdir_pdftex_mk?rev=1.2",
      "texk_xdvik_Makefile_in?rev=1.2",
      "texk_xdvipdfmx_Makefile_in?rev=1.1",
      "texk_xdvipdfmx_configure?rev=1.1",
      "utils_dialog_Makefile_in?rev=1.3",
      "utils_tpic2pdftex_Makefile_in?rev=1.1",
    ].collect! { |middle| "http://www.openbsd.org/cgi-bin/cvsweb/ports/print/texlive/base/patches/patch-#{middle};content-type=text%2Fplain" }
    # Putting DATA in p0 seemed to cause trouble, so we put nonsense in the filenames and put it in p1
    { :p0 => patches, :p1 => DATA }
  end

  def install
    # Notes:
    # Several OSX-specific files (texk/web2c/xetexdir/XeTeXFontMgr_Mac.mm and others) can't build in
    # 64 bit mode on OSX, since they use deprecated functions only available when building in 32bit.
    ENV.m32
    ENV.deparallelize

    # Some of the makefiles doesn't use CFLAGS during linking, which causes things to break when building as 32bit.
    # Ugly hack to force -m32 always and forever.
    ENV["CC"]="gcc-4.2 -m32 -arch i386"
    ENV["CXX"]="g++-4.2 -m32 -arch i386"
    # I even had to patch a Makefile since it hardcoded using cc and c++, see below.

    x11_libdir = MacOS::X11.lib
    x11_includedir = MacOS::X11.include

    # The build scripts don't create this directory for no apparent reason...
    # It's easier to just do it here than it is to patch the Makefiles
    # Actually, if compilation fails brew thinks that we succeeded because this directory exists. Maybe we should patch the makefiles...
    man5.mkpath

    # Replaces the texk_kpathsea_texmf_cnf OpenBSD patch with our own version
    inreplace "texk/kpathsea/texmf.cnf", "$SELFAUTOPARENT/", "#{share}/"

    mkdir "Work" do
      system "../configure", "--prefix=#{prefix}/",
                             "--datadir=#{prefix}/",
                             "--with-xdvi-x-toolkit=xaw",
                             "--disable-threads",
                             "--with-old-mac-fonts",
                             "--without-xindy",
                             "--x-libraries=#{x11_libdir}",
                             "--x-includes=#{x11_includedir}",
                             "--with-freetype2-libdir=#{x11_libdir}",
                             "--with-freetype2-include=#{x11_includedir}",
                             "--with-pnglib-libdir=#{x11_libdir}",
                             "--with-pnglib-include=#{x11_includedir}",
                             "--with-system-ncurses",
                             "--with-system-freetype2",
                             "--with-system-pnglib",
                             "--with-system-zlib",
                             "--with-system-gd",
                             "--disable-multiplatform",
                             "--without-texinfo",
                             "--without-xdvipdfmx",
                             "--without-texi2html",
                             "--without-psutils"
      system "make", "world"
    end

    # Installs texmf, which has necessary support files for tex-live
    resource("texmf").stage do
      # Update a conf file to use the proper directories, replaces OpenBSD patch
      # Yes, this file exists in both tex-live and texmf. With this change they're identical, though.
      inreplace "texmf/web2c/texmf.cnf", "$SELFAUTOPARENT/", "#{share}/"
      share.install Dir["*"]
    end

    ENV.append_path "PATH", bin

    # The texlive makefiles are supposed to do this, I don't know why they don't...
    # We need this ugly path hack because texlinks and fmtutil-sys call other scripts in bin
    system "texlinks", "-f", "#{share}/texmf/web2c/fmtutil.cnf"
    system "fmtutil-sys", "--all"
  end
end

# OpenBSD patches:
# http://www.openbsd.org/cgi-bin/cvsweb/ports/print/texlive/

# Notes for below:
# Patch 1: No idea why this declaration is wrong, but we'll go ahead and fix it.
# Patch 2: Slightly modified patch from OpenBSD. Adding the _XOPEN_SOURCE preprocessor flag in
#   libs/lua51/Makefile undeprecates some things in /usr/include/ucontext.h (Snow Leopard).
# Patch 3: These are hardcoded and do not respect CFLAGS, so force them to use 32bit mode.
__END__
--- nonsense/texk/web2c/xetexdir/XeTeX_ext.h	2009-10-28 02:27:34.000000000 -0700
+++ nonsense/texk/web2c/xetexdir/XeTeX_ext.h	2009-10-28 02:31:38.000000000 -0700
@@ -300,7 +300,7 @@
 
 #ifdef XETEX_MAC
 /* functions in XeTeX_mac.c */
-	void* loadAATfont(ATSFontRef fontRef, integer scaled_size, const char* cp1);
+	void* loadAATfont(ATSFontRef fontRef, long scaled_size, const char* cp1);
 	void DoAtsuiLayout(void* node, int justify);
 	void GetGlyphBBox_AAT(ATSUStyle style, UInt16 gid, GlyphBBox* bbox);
 	float GetGlyphWidth_AAT(ATSUStyle style, UInt16 gid);
  $OpenBSD: patch-libs_lua51_Makefile,v 1.2 2008/12/04 22:29:06 steven Exp $
--- nonsense/libs/lua51/Makefile.orig	Mon Mar 24 15:47:15 2008
+++ nonsense/libs/lua51/Makefile	Sun Oct 26 15:30:26 2008
@@ -8,7 +8,7 @@
 PLAT= none

 CC= gcc
-CFLAGS= -g -O2 -Wall $(XCFLAGS) $(MYCFLAGS) $(COCOFLAGS)
+LOCALCFLAGS= -g -O2 -Wall -D_XOPEN_SOURCE $(MYCFLAGS) $(COCOCFLAGS)
 AR= ar rcu
 RANLIB= ranlib
 RM= rm -f
@@ -77,12 +77,14 @@ clean:
 	$(RM) $(ALL_T) $(ALL_O)

 depend:
-	@$(CC) $(CFLAGS) -MM l*.c print.c
+	@$(CC) $(LOCALCFLAGS) $(CFLAGS) $(XCFLAGS) -MM l*.c print.c

 echo:
 	@echo "PLAT = $(PLAT)"
 	@echo "CC = $(CC)"
+	@echo "LOCALCFLAGS = $(LOCALCFLAGS)"
 	@echo "CFLAGS = $(CFLAGS)"
+	@echo "XCFLAGS = $(XCFLAGS)"
 	@echo "AR = $(AR)"
 	@echo "RANLIB = $(RANLIB)"
 	@echo "RM = $(RM)"
@@ -96,7 +98,7 @@ none:
 	@echo "Please choose a platform: $(PLATS)"

 aix:
-	$(MAKE) a CC="xlc" CFLAGS="-O2 -DLUA_USE_POSIX -DLUA_USE_DLOPEN" MYLIBS="-ldl" MYLDFLAGS="-brtl -bexpall"
+	$(MAKE) a CC="xlc" LOCALCFLAGS="-O2 -DLUA_USE_POSIX -DLUA_USE_DLOPEN" MYLIBS="-ldl" MYLDFLAGS="-brtl -bexpall"

 ansi:
 	$(MAKE) a MYCFLAGS=-DLUA_ANSI
@@ -130,6 +132,10 @@ posix:

 solaris:
 	$(MAKE) a MYCFLAGS="-DLUA_USE_POSIX -DLUA_USE_DLOPEN" MYLIBS="-ldl"
+
+.c.o:
+	$(CC) $(LOCALCFLAGS) $(CFLAGS) $(XCFLAGS) -c $<
+

 # list targets that do not create files (but not all makes understand .PHONY)
 .PHONY: all $(PLATS) default o a clean depend echo none
--- nonsense/texk/xdv2pdf/Makefile.in.orig	2009-10-28 15:18:25.000000000 -0700
+++ nonsense/texk/xdv2pdf/Makefile.in	2009-10-28 15:18:51.000000000 -0700
@@ -4,8 +4,8 @@
 kpse_include ../make/common.mk
 kpse_include ../make/programs.mk

-CXX = c++
-OBJC = cc
+CXX = c++ -m32 -arch i386
+OBJC = cc -m32 -arch i386
 CXXLD = $(CXX)
 cxx_link_command = $(CXXLD) -o $@ $(LDFLAGS)
 kpathsea_cxx_link = $(LIBTOOL) --mode=link $(cxx_link_command)
