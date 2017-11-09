# This can be upstreamed to nixpkgs
# However this is not the official repository because we use a fork of the official one.
# Actually this lib appears unsupported / unmaintained
{ stdenv, fetchFromGitHub } :
stdenv.mkDerivation rec
{
  name = "fontstash-${version}";
  version = "2017-10-17";

  src = fetchFromGitHub {
    owner = "BastiaanOlij";
    repo = "fontstash";
    rev = "24aa2f3";
    sha256 = "0c66zr03vf086hsw9q2bkzmy83g08nq5fpsbfcc14s4nnb29zlxw";
  };

  buildInputs = [ ];

  outputs = [ "dev" "out" ];

  enableParallelBuilding = true;

  buildPhase = ''
    mkdir -p $dev/include/fontstash;
    mkdir $out;
  '';

  installPhase = ''
    mv src/* $dev/include/fontstash
  '';

  meta = with stdenv.lib; {
    description = "Light-weight online font texture atlas builder";
    homepage = "https://github.com/memononen/fontstash";
    license = {
      fullName = "I don't know (looks like a bsd)";
      url = "https://github.com/memononen/fontstash/blob/master/LICENSE.txt";
    };
    platforms = platforms.all;
    maintainers = [ maintainers.guibou ];
  };
}
