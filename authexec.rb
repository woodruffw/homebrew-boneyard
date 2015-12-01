class Authexec < Formula
  homepage "https://github.com/tcurdt/authexec"
  url "https://github.com/tcurdt/authexec/archive/1.0.tar.gz"
  sha256 "96e2e3479a22b367a402b38b66f7b67a8ce31dcf2aa2ee869f1d66b978831730"

  head "https://github.com/tcurdt/authexec.git"

  # AuthorizationExecuteWithPrivileges was depreciated in OS X 10.7
  # Installing this on newer systems throws up an ugly, blunt OS X warning.
  # Running anything under it on newer systems also gets a `status: -60031` error
  depends_on MaximumMacOSRequirement => :lion

  def install
    system ENV.cc, "authexec.c", "-framework", "Security", "-o", "authexec"
    bin.install "authexec"
  end
end
