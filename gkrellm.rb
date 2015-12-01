class Gkrellm < Formula
  homepage "http://members.dslextreme.com/users/billw/gkrellm/gkrellm.html"
  url "http://members.dslextreme.com/users/billw/gkrellm/gkrellm-2.3.5.tar.bz2"
  sha256 "702b5b0e9c040eb3af8e157453f38dd6f53e1dcd8b1272d20266cda3d4372c8b"

  depends_on :x11
  depends_on "pkg-config" => :build
  depends_on "atk"
  depends_on "cairo"
  depends_on "fontconfig"
  depends_on "freetype"
  depends_on "gdk-pixbuf"
  depends_on "gettext"
  depends_on "glib"
  depends_on "gtk+"
  depends_on "pango"

  patch :p0 do
    url "https://trac.macports.org/export/115088/trunk/dports/sysutils/gkrellm/files/207a0519ac73290ba65b6e5f7446549a2a66f5d2.patch"
    sha256 "d005e7ad9b4c46d4930ccb4391481716b72c9a68454b8d8f4dfd2b597bfd77cc"
  end

  patch :p0 do
    url "https://trac.macports.org/export/115088/trunk/dports/sysutils/gkrellm/files/patch-src-Makefile.diff"
    sha256 "0c24c66ea0163bc7d3fcbe87f742a2fe66afdc76d6af19fcd5137a4749518d90"
  end

  def install
    inreplace "Makefile", "$(PREFIX)", prefix
    inreplace "src/gkrellm.h" do |s|
      s.gsub! "/usr/local/share/gkrellm2/themes", "#{share}/gkrellm2/themes"
      s.gsub! "src/gkrellm.h", "/usr/share/gkrellm2/themes", "#{share}/gkrellm2/themes"
      s.gsub! "src/gkrellm.h", "/usr/local/lib/gkrellm2/plugins", "#{libexec}/gkrellm2/plugins"
      s.gsub! "src/gkrellm.h", "/usr/lib/gkrellm2/plugins", "#{libexec}/gkrellm2/plugins"
    end

    system "make", "darwin9"
    system "make", "install_darwin9"
  end
end
