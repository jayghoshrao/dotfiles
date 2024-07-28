{ lib, stdenv, fetchgit, cmake, hdf5, suitesparse, mkl}:

stdenv.mkDerivation rec {
      name = "cadet";
      version = "4.4.0";

      src = fetchgit {
        url = "https://github.com/modsim/CADET";
        rev = "6dfe1f04231aa62874ac4ab3ca4cdbf295708cf0";
        sha256 = "KCpwcNq2byqL9zEuWAz9w5KDFKEiPUofwEs9slrtWeQ=";
      };

      nativeBuildInputs = [ cmake ];

      buildInputs = [ 
            hdf5
            suitesparse
            mkl
      ];

      cmakeFlags = [
        "-DENABLE_CADET_MEX=OFF" 
        "-DENABLE_TESTS=OFF" 
        "-DBLA_VENDOR=Intel10_64lp"
      ];
}
