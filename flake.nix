{
    description = "A flake to install GPUEngine";

    inputs = {
        nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-24.05";
        unstable.url = "github:nixos/nixpkgs?ref=nixos-unstable";

        ste = {
            url = "path:/home/kimo/Code/Nix/Flakes/ste-flake/";
        };

        QtImageLoader-patch = {
            url = "/home/kimo/Code/Nix/Flakes/GPUEngine-flake/QtImageLoader.patch";
            flake = false;
        };

        OpenGLFunctionLoader-patch = {
            url = "/home/kimo/Code/Nix/Flakes/GPUEngine-flake/linux_OpenGLFunctionLoader.patch";
            flake = false;
        };

        AssimpModelLoader-patch = {
            url = "/home/kimo/Code/Nix/Flakes/GPUEngine-flake/AssimpModelLoader.patch";
            flake = false;
        };
    };

    outputs = { self, nixpkgs, unstable, ... } @ inputs:
    let
        system="x86_64-linux";
        pkgs = nixpkgs.legacyPackages.${system};
        unstable-pkgs = unstable.legacyPackages.${system};
    in
    {
        packages.${system}.default = pkgs.stdenv.mkDerivation {
            name = "GPUEngine";

            src = fetchGit {
                url = "https://github.com/Rendering-FIT/GPUEngine.git";
                ref = "master";
                rev = "b1ed2d51be39e6d1c409c530e9e0c834b26d9d9c";
            };

            # sets up paralel building with 8 cores
            build-cores = 8;
            enableParalelBuilding = true;

            outputs = [ "out" "docs" ];

            # skips fixup phase cause for some reason it likes to cause errors
            dontFixup = true;

            buildInputs = [
                inputs.ste.packages.${system}.default
                unstable-pkgs.glm
                pkgs.qt5Full
                pkgs.assimp


                pkgs.glfw
                pkgs.mesa
                pkgs.libGL
                pkgs.libGLU
                pkgs.openscenegraph
            ];

            # packages defined here will only be avaiable at build phases and not at runtime
            nativeBuildInputs = [
                pkgs.cmake
                pkgs.doxygen
                # another thing for doxygen ig
                pkgs.graphviz-nox
            ];

            # since I am targeting specific files I cant use the patches variable
            patchPhase = ''
                patch ./geGL/src/geGL/private/linux_OpenGLFunctionLoader.h ${inputs.OpenGLFunctionLoader-patch}
                patch ./geAd/QtImageLoader/src/QtImageLoader.h ${inputs.QtImageLoader-patch}
                patch ./geAd/AssimpModelLoader/src/AssimpModelLoader.h ${inputs.AssimpModelLoader-patch}
            '';

            # this should be a replacement for configure phase
            cmake = true;
            cmakeFlags = [
                "-DWIN32=0"
                "-DGPUENGINE_BUILD_GESG=ON"
                "-DGPUENGINE_BUILD_geAd=ON"
                "-DGPUENGINE_BUILD_EXAMPLES=ON"
                "-DGPUENGINE_BUILD_TESTS=ON"
                "-DBUILD_TESTING=ON"
            ];

            # Install docs
            postInstall = ''
                cd ..
                doxygen $src/Doxyfile
                cp -r doc/* $docs
            '';

                # mkdir -p $examples $tests $docs
                # cd tests/
                # make -j8 VERBOSE=1 >&2
                # ls -R ./ >&2
                # find ./ -type f -executable -exec cp {} $tests \;
                # ls -R $tests >&2
                # echo "examples: "
                # ls examples
                # cp -r examples/* $examples
                # echo "tests: "
                # ls tests
                # cp -r tests/* $tests
        };
    };
}
