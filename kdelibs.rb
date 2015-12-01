require "formula"

class Kdelibs < Formula
  homepage "http://www.kde.org/"
  url "http://download.kde.org/stable/4.9.5/src/kdelibs-4.9.5.tar.xz"
  sha1 "899a58c5cf2115a1a18fb1690c99b2b3815975c6"

  depends_on "cmake" => :build
  depends_on "automoc4" => :build
  depends_on "gettext"
  depends_on "pcre"
  depends_on "jpeg"
  depends_on "giflib"
  depends_on "strigi"
  depends_on "soprano"
  depends_on "shared-desktop-ontologies"
  depends_on "shared-mime-info"
  depends_on "attica"
  depends_on "docbook"
  depends_on "d-bus"
  depends_on "qt"
  depends_on "libdbusmenu-qt"
  depends_on :x11

  def install
    gettext_prefix = Formula["gettext"].prefix
    docbook_prefix = Formula["docbook"].prefix
    docbook_dtd = "#{docbook_prefix}/docbook/xml/4.5"
    docbook_xsl = Dir.glob("#{docbook_prefix}/docbook/xsl/*").first
    mkdir "build" do
      system "cmake #{std_cmake_parameters} -DCMAKE_PREFIX_PATH=#{gettext_prefix} -DDOCBOOKXML_CURRENTDTD_DIR=#{docbook_dtd} -DDOCBOOKXSL_DIR=#{docbook_xsl} -DBUILD_doc=FALSE -DBUNDLE_INSTALL_DIR=#{bin} .."
      system "make install"
    end
  end
end
