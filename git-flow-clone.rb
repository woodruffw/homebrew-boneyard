class GitFlowClone < Formula
  homepage "https://github.com/ashirazi/git-flow-clone"
  url "https://github.com/ashirazi/git-flow-clone/archive/0.1.2.tar.gz"
  sha256 "e741d7add3c69ab4da0eddb40edc3f173f1a0cf349bc92131380c64c35eac9f7"

  def install
    system "make", "prefix=#{prefix}", "install"
  end

  def caveats; <<-EOS.undent
    Either git-flow or git-flow-avh (recommended) need to be installed:
      brew install git-flow
    or:
      brew install git-flow-avh

    If installed with git-flow-avh update ~/.gitflow_export with:
      export GITFLOW_DIR=#{HOMEBREW_PREFIX}/bin
    EOS
  end
end
