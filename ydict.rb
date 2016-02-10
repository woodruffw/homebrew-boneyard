class Ydict < Formula
  desc "Command-line interface to Yahoo! Dictionary"
  homepage "https://github.com/chenpc/ydict"
  url "https://github.com/chenpc/ydict/archive/1.3.4.tar.gz"
  sha256 "f542e876d268e09d2a6883529a76937a1f38d0e594aa056b33ec4a1c79a1b8c2"

  bottle :unneeded

  def install
    bin.install "ydict" => "ydict.py"
    (bin/"ydict").write <<-EOS.undent
      #!/bin/sh
      LC_ALL=en_US.UTF-8 "#{bin}/ydict.py" "$@"
    EOS
  end
end
