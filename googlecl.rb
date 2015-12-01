class Googlecl < Formula
  desc "Manage Google services from the command-line"
  homepage "https://code.google.com/p/googlecl/"
  url "https://googlecl.googlecode.com/files/googlecl-0.9.14.tar.gz"
  sha256 "0a4640b1240104b8020f9af526e24afe53a8327390d95ef28e1ca093673fce5a"

  depends_on :python if MacOS.version <= :snow_leopard

  conflicts_with "osxutils", :because => "both install a google binary"

  resource "gdata" do
    url "https://pypi.python.org/packages/source/g/gdata/gdata-2.0.18.tar.gz"
    sha256 "56e7d22de819c22b13ceb0fe1869729b4287f89ebbd4bb55380d7bcf61a1fdb6"
  end

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python2.7/site-packages"
    resource("gdata").stage do
      system "python", *Language::Python.setup_install_args(libexec/"vendor")
    end

    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python2.7/site-packages"
    system "python", *Language::Python.setup_install_args(libexec)

    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files(libexec+"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    system "#{bin}/google", "help", "docs"
  end
end
