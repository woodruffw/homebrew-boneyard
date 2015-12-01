class Mailtomutt < Formula
  url "https://downloads.sourceforge.net/project/mailtomutt/MailtoMutt/v0.4.1/mailtomutt-0.4.1.tar.bz2"
  homepage "http://mailtomutt.sourceforge.net"
  sha256 "138df68ca8b7a2fde047cab898060e4ee4da3d9e5dd856339fcf1a23f086f88e"

  def install
    xcodebuild "SYMROOT=build"
    prefix.install "build/Default/MailtoMutt.app"
  end

  def caveats; <<-EOS.undent
    MaitoMutt.app was installed in:
      #{prefix}

    To symlink into ~/Applications:
      brew linkapps
    EOS
  end
end
