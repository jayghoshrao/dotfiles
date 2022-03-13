{
    packageOverrides = pkgs: with pkgs; {
        gmsh = pkgs.gmsh.overrideAttrs (oldAttrs: rec {
                cmakeFlags = [
                "-DENABLE_BUILD_LIB=1"
                "-DENABLE_BUILD_SHARED=1"
                "-DENABLE_BUILD_DYNAMIC=1"
                ];
                });

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
