{
    # allowUnfree = true;

    packageOverrides = pkgs: with pkgs; {
        gmsh = pkgs.gmsh.overrideAttrs (oldAttrs: rec {
                cmakeFlags = [
                "-DENABLE_BUILD_LIB=1"
                "-DENABLE_BUILD_SHARED=1"
                "-DENABLE_BUILD_DYNAMIC=1"
                ];
                });

        vtk910-mpi = (vtk_9.overrideAttrs(oldAttrs: rec{

                majorVersion = "9.1";
                minorVersion = "0";

                version = "${majorVersion}.${minorVersion}";

                src = fetchurl {
                url = "https://www.vtk.org/files/release/${majorVersion}/VTK-${version}.tar.gz";
                sha256 = "8fed42f4f8f1eb8083107b68eaa9ad71da07110161a3116ad807f43e5ca5ce96";
                };

                cmakeFlags = oldAttrs.cmakeFlags ++ [
                    "-DVTK_USE_MPI=ON"
                    "-DVTK_SMP_IMPLEMENTATION_TYPE=TBB"
                ];

                buildInputs = oldAttrs.buildInputs ++ [
                    tbb
                    mpi
                ];

                preFixup = "";

                postInstall = '' 
                ln -s $out/include/vtk-${majorVersion} $out/include/vtk
                '';

        }) ).override { stdenv = gcc11Stdenv; };

        # myhello = pkgs.hello.overrideAttrs (oldAttrs: rec {
        #             doCheck = false;
        #         });

        # paraview = pkgs.paraview.overrideAttrs (oldAttrs: rec {
        #
        #         cmakeFlags = [
        #         "-DCMAKE_BUILD_TYPE=Release"
        #         "-DPARAVIEW_ENABLE_FFMPEG=ON"
        #         "-DPARAVIEW_USE_MPI=ON"
        #         "-DPARAVIEW_USE_PYTHON=ON"
        #         "-DPARAVIEW_USE_QT=OFF"
        #         "-DVTK_USE_X=OFF"
        #         "-DVTK_SMP_IMPLEMENTATION_TYPE=TBB"
        #         "-DVTKm_ENABLE_MPI=ON"
        #         "-DCMAKE_INSTALL_LIBDIR=lib"
        #         "-DCMAKE_INSTALL_INCLUDEDIR=include"
        #         "-DCMAKE_INSTALL_BINDIR=bin"
        #         "-GNinja"
        #         ];
        #
        #
        #         buildInputs = [
        #             # pkgs.mesa
        #             pkgs.libGLU
        #             pkgs.libGL
        #             pkgs.xorg.libXt
        #             pkgs.mpi
        #             pkgs.tbb
        #             pkgs.boost
        #             pkgs.ffmpeg
        #             pkgs.gdal
        #         ];
        #
        #         propagatedBuildInputs = [ 
        #             pkgs.mesa 
        #             (pkgs.python3.withPackages (ps: with ps; [ numpy matplotlib mpi4py ]))
        #         ];
        #
        #         });

        # myPackages = pkgs.buildEnv {
        #     name = "my-packages";
        #     paths = [
        #         tmux
        #         neovim
        #         zsh
        #         fd
        #     ];
        # };

    };

}
