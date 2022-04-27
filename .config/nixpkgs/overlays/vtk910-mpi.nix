self: super: 
{

  vtk910-mpi = (super.vtk_9.overrideAttrs(oldAttrs: rec{

    majorVersion = "9.1";
    minorVersion = "0";

    version = "${majorVersion}.${minorVersion}";

    src = builtins.fetchurl {
      url = "https://www.vtk.org/files/release/${majorVersion}/VTK-${version}.tar.gz";
      sha256 = "8fed42f4f8f1eb8083107b68eaa9ad71da07110161a3116ad807f43e5ca5ce96";
      };

      cmakeFlags = oldAttrs.cmakeFlags ++ [
        "-DVTK_USE_MPI=ON"
        "-DVTK_SMP_IMPLEMENTATION_TYPE=TBB"
      ];

      buildInputs = oldAttrs.buildInputs ++ [
        self.tbb
        self.mpi
      ];

      preFixup = "";

      postInstall = '' 
      ln -s $out/include/vtk-${majorVersion} $out/include/vtk
      '';

    }) ).override { stdenv = self.gcc11Stdenv; };

}
