{ stdenv, fetchurl }: 
 
stdenv.mkDerivation rec { 
  name = "tbb-${version}"; 
  version = "2018_U1"; 
 
  src = fetchurl { 
    url = "https://github.com/01org/tbb/archive/2018_U1.tar.gz"; 
    sha256 = "1iazn1lfynks96fqjs9q97zzdd4x3zrzsg76zi22pvzcshbj4in6"; 
  }; 
 
  checkTarget = "test"; 
  doCheck = false; 
 
  installPhase = '' 
    mkdir -p $out/{lib,share/doc} 
    cp "build/"*release*"/"*${stdenv.hostPlatform.extensions.sharedLibrary}* $out/lib/ 
    mv include $out/ 
    rm $out/include/index.html 
    mv doc/html $out/share/doc/tbb 
  ''; 
 
  enableParallelBuilding = true; 
 
  meta = { 
    description = "Intel Thread Building Blocks C++ Library"; 
    homepage = http://threadingbuildingblocks.org/; 
    license = stdenv.lib.licenses.lgpl3Plus; 
    longDescription = '' 
      Intel Threading Building Blocks offers a rich and complete approach to 
      expressing parallelism in a C++ program. It is a library that helps you 
      take advantage of multi-core processor performance without having to be a 
      threading expert. Intel TBB is not just a threads-replacement library. It 
      represents a higher-level, task-based parallelism that abstracts platform 
      details and threading mechanisms for scalability and performance. 
    ''; 
    platforms = with stdenv.lib.platforms; linux ++ darwin; 
  }; 
} 
