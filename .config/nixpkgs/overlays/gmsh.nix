self: super: 
{
  gmsh_with_libs = super.gmsh.overrideAttrs (old: {
    cmakeFlags = [
      "-DENABLE_BUILD_LIB=1"
      "-DENABLE_BUILD_SHARED=1"
      "-DENABLE_BUILD_DYNAMIC=1"
    ];
  });
}
