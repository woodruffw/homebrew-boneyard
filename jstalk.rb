class Jstalk < Formula
  homepage "http://jstalk.org/"
  url "https://github.com/ccgus/jstalk/archive/v1.0.1.tar.gz"
  sha256 "7e84581efd67fe3c0a144bda40755db9718369e57e88860e7ce52a2a9194d036"

  head "https://github.com/ccgus/jstalk.git"

  depends_on :macos => :snow_leopard
  depends_on :xcode => :build

  def install
    ["JSTalk Framework", "jstalk command line", "JSTalk Editor"].each do |t|
      xcodebuild "-target", t, "-configuration", "Release", "ONLY_ACTIVE_ARCH=YES", "SYMROOT=build"
    end

    cd "build/Release" do
      bin.install "jstalk"
      prefix.install "JSTalk Editor.app"
      frameworks.install "JSTalk.framework"
    end
  end
end
