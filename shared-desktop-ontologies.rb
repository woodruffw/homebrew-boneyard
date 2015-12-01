class SharedDesktopOntologies < Formula
  desc "RDF vocabularies for the Semantic Desktop"
  homepage "http://sourceforge.net/apps/trac/oscaf/"
  url "https://downloads.sourceforge.net/project/oscaf/shared-desktop-ontologies/0.5/shared-desktop-ontologies-0.5.tar.bz2"
  sha256 "f904792a4a9f0b5a5a6c7e5e09f4ebc741d617b69bff7d5e1e23903096d02fa8"

  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_parameters
    system "make", "install"
  end
end
