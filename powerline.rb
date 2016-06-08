class Powerline < Formula
  desc "statusline plugin for vim, and provides statuslines & prompts"
  homepage "https://github.com/powerline/powerline"
  url "https://github.com/powerline/powerline/archive/2.4.tar.gz"
  sha256 "04050051e033fd1d9b3c60b1183cbe6801185cd5b7495789647ddec72f1bd789"

  depends_on :python if MacOS.version <= :snow_leopard

  def install
    system "python", *Language::Python.setup_install_args(prefix)
  end

  test do
    system "#{bin}/powerline", "--help"
  end
end
