class Llvm32 < Formula
  homepage "http://llvm.org/"
  url "http://llvm.org/releases/3.2/llvm-3.2.src.tar.gz"
  sha256 "125090c4d26740f1d5e9838477c931ed7d9ad70d599ba265f46f3a42cb066343"

  option :universal
  option "with-clang", "Build Clang C/ObjC/C++ frontend"
  option "with-asan", "Include support for -faddress-sanitizer (from compiler-rt)"
  option "disable-shared", "Don't build LLVM as a shared library"
  option "all-targets", "Build all target backends"
  option "rtti", "Build with C++ RTTI"
  option "disable-assertions", "Speeds up LLVM, but provides less debug information"

  depends_on :python => :recommended
  depends_on "homebrew/versions/gmp4"
  depends_on "homebrew/versions/isl011"
  depends_on "homebrew/versions/cloog018"
  depends_on MaximumMacOSRequirement => :mountain_lion

  resource "clang" do
    url "http://llvm.org/releases/3.2/clang-3.2.src.tar.gz"
    sha256 "2aaaf03f7c0f6b16fe97ecc81247dc2bf2d4bec7620a77cc74670b7e07ff5658"
  end

  resource "compiler-rt" do
    url "http://llvm.org/releases/3.2/compiler-rt-3.2.src.tar.gz"
    sha256 "4ac311df0eead459cbb0f0890c06b55dae529ab45827ac73fef40bec632994aa"
  end

  resource "polly" do
    url "http://llvm.org/releases/3.2/polly-3.2.src.tar.gz"
    sha256 "67b5a69b9e3675084bd596228a0e9fd96e3ed0002d9b6f36bb27cfdae54ac192"
  end

  def install
    if build.with?("python") && build.include?("disable-shared")
      raise "The Python bindings need the shared library."
    end

    (buildpath/"tools/polly").install resource("polly")
    (buildpath/"tools/clang").install resource("clang") if build.with? "clang"
    (buildpath/"projects/compiler-rt").install resource("compiler-rt") if build.with? "asan"

    if build.universal?
      ENV.permit_arch_flags
      ENV["UNIVERSAL"] = "1"
      ENV["UNIVERSAL_ARCH"] = Hardware::CPU.universal_archs.join(" ")
    end

    ENV["REQUIRES_RTTI"] = "1" if build.include? "rtti"

    install_prefix = lib/"llvm-#{version}"

    args = [
      "--prefix=#{install_prefix}",
      "--enable-optimized",
      # As of LLVM 3.1, attempting to build ocaml bindings with Homebrew's
      # OCaml 3.12.1 results in errors.
      "--disable-bindings",
      "--with-gmp=#{Formula["gmp4"].opt_prefix}",
      "--with-isl=#{Formula["isl011"].opt_prefix}",
      "--with-cloog=#{Formula["cloog018"].opt_prefix}",
    ]

    if build.include? "all-targets"
      args << "--enable-targets=all"
    else
      args << "--enable-targets=host"
    end
    args << "--enable-shared" unless build.include? "disable-shared"

    args << "--disable-assertions" if build.include? "disable-assertions"

    system "./configure", *args
    system "make", "VERBOSE=1"
    system "make", "VERBOSE=1", "install"

    # Install Clang tools
    (share/"clang-#{version}/tools").install buildpath/"tools/clang/tools/scan-build", buildpath/"tools/clang/tools/scan-view" if build.with? "clang"

    if build.with? "python"
      # Install llvm python bindings.
      mv buildpath/"bindings/python/llvm", buildpath/"bindings/python/llvm-#{version}"
      (lib+"python2.7/site-packages").install buildpath/"bindings/python/llvm-#{version}"
      # Install clang tools and bindings if requested.
      if build.with? "clang"
        mv buildpath/"tools/clang/bindings/python/clang", buildpath/"tools/clang/bindings/python/clang-#{version}"
        (lib+"python2.7/site-packages").install buildpath/"tools/clang/bindings/python/clang-#{version}"
      end
    end

    # Link executables to bin and add suffix to avoid conflicts
    Dir.glob(install_prefix/"bin/*") do |exec_path|
      basename = File.basename(exec_path)
      bin.install_symlink exec_path => "#{basename}-#{version}"
    end

    # Also link man pages
    Dir.glob(install_prefix/"share/man/man1/*") do |manpage|
      basename = File.basename(manpage, ".1")
      man1.install_symlink manpage => "#{basename}-#{version}.1"
    end
  end

  test do
    system "#{bin}/llvm-config-#{version}", "--version"
  end

  def caveats
    if build.with? "clang"
      "Extra tools are installed in #{HOMEBREW_PREFIX}/share/clang-#{version}."
    end
  end
end
