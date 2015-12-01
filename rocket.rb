require "language/go"

class Rocket < Formula
  desc "App Container runtime"
  homepage "https://github.com/coreos/rocket"
  head "https://github.com/coreos/rocket.git"

  url "https://github.com/coreos/rocket/archive/v0.1.0.tar.gz"
  sha256 "594bfdf68efe7e675c12a2bcf19ae33bd22453375ede446256e4e892e0a228d0"

  depends_on "go" => :build
  depends_on "squashfs" => :build

  go_resource "github.com/jteeuwen/go-bindata" do
    url "https://github.com/jteeuwen/go-bindata/archive/v3.0.7.tar.gz"
    sha256 "77a7214479e5ce9004e4afa6d0eb8ce14289030fadc55a3444249ab1fe2c7980"
  end

  def install
    ENV["GOPATH"] = buildpath
    Language::Go.stage_deps resources, buildpath/"src"
    cd "#{buildpath}/src/github.com/jteeuwen/go-bindata" do
      system "go", "install", "github.com/jteeuwen/go-bindata/..."
    end
    ENV.prepend_path "PATH", buildpath/"bin"

    inreplace "build", "GOOS=linux", "GOOS=#{`uname`.downcase}"

    # Fix non-POSIX commands realpath and mktemp
    # See https://github.com/coreos/rocket/pull/196
    inreplace "build", "$(mktemp -d)", "$(mktemp -d -t rocket-XXXXXX)"
    inreplace "stage1/mkrootfs.sh", '$(realpath "${BINDIR}")', '"${PWD}${BINDIR}"'

    system "./build"
    bin.install "bin/actool", "bin/rkt"
    doc.install "README.md"
  end

  test do
    system "#{bin}/actool", "help"
    system "#{bin}/rkt", "help"
    assert_equal "sha256-08699361d40a0728924ffe6fcd67dc933d7311cf8e6f403048c9271181b20e2e\n",
      `#{bin}/rkt --dir=$PWD fetch https://github.com/coreos/rocket/releases/download/v0.1.0/ace-validator-main.aci`
  end
end
