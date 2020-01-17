# Note that this script can accept some limited command-line arguments, run
# `julia build_tarballs.jl --help` to see a usage message.
using BinaryBuilder

name = "SPIRV-LLVM-Translator"
version = v"0.1"

llvm_releases = [v"8.0.1" => "v8.0.1+4"]

llvm_download_info = Dict(
    "LLVM.v8.0.1.aarch64-linux-gnu-libgfortran3.tar.gz" => "4db8f0437f7ccf4b0bbd33cb5edd06f287b31b4a58cb90eee1642555315099aa",
    "LLVM.v8.0.1.aarch64-linux-gnu-libgfortran4.tar.gz" => "0afc7356bf015ade2e9c4d442440f53fc155b28e7d13de328c15d351bd6849fb",
    "LLVM.v8.0.1.aarch64-linux-gnu-libgfortran5.tar.gz" => "8176883e3c3e4d1127ee1740885dd1d49f7c4950c2e4598a1b9f05ab75a351ba",
    "LLVM.v8.0.1.arm-linux-gnueabihf-libgfortran3.tar.gz" => "a6dd9f94e8f9aca161fa9672649f9cb9bcda72edc9db1ddac878a5f753041f8d",
    "LLVM.v8.0.1.arm-linux-gnueabihf-libgfortran4.tar.gz" => "29631334700687b228121423b797ef58bce1b6deba1216fc264c3bd25f0b751c",
    "LLVM.v8.0.1.arm-linux-gnueabihf-libgfortran5.tar.gz" => "acbcdab37647ae5147d5346e49033df09d0eee5dd96f59e598c0b01b3a082d73",
    "LLVM.v8.0.1.i686-linux-gnu-libgfortran3.tar.gz" => "2c843eba88afbc41516048eed8ad99d915d4d8a6d782809281dc8b686d0dc914",
    "LLVM.v8.0.1.i686-linux-gnu-libgfortran4.tar.gz" => "e6d2ae53ad984b5685e29faf7099f0d061bfbd712ddfd48edb62f55fb7c12173",
    "LLVM.v8.0.1.i686-linux-gnu-libgfortran5.tar.gz" => "8fb90de942f649f74dacff7b0b0b846f94c9b4ec8006800e801176b537528d04",
    "LLVM.v8.0.1.i686-w64-mingw32-libgfortran3.tar.gz" => "23de204ff40cc5084b77c4932495e3e7ea67a93cf06104390b55369aa7c7c272",
    "LLVM.v8.0.1.i686-w64-mingw32-libgfortran4.tar.gz" => "a0df68d7e95b0ff42037d5c0282c534c803f017b62901686f38c7f9379c1fb13",
    "LLVM.v8.0.1.i686-w64-mingw32-libgfortran5.tar.gz" => "c84ab75fa9aa579e6d3a857d43cdad5f6c341892a566fca993044910cab8e736",
    "LLVM.v8.0.1.powerpc64le-linux-gnu-libgfortran3.tar.gz" => "c75af41c7f0eae6c2d79e514ed73cc5bb4f2ed0e84632f182104924921e9dae8",
    "LLVM.v8.0.1.powerpc64le-linux-gnu-libgfortran4.tar.gz" => "15e121c3d61fb681682f71dc3493b3c13215c8055a48f7e289c1a7f74c8323e1",
    "LLVM.v8.0.1.powerpc64le-linux-gnu-libgfortran5.tar.gz" => "52569dd6de8fdce5f2bd4ca4e1597001a28801759ece2e22f283b3585383f8d4",
    "LLVM.v8.0.1.x86_64-apple-darwin14-libgfortran3.tar.gz" => "a2d912065751de6a52e6b74eb1453909b96018b543a28e2b917ac1f6fc5d94fe",
    "LLVM.v8.0.1.x86_64-apple-darwin14-libgfortran4.tar.gz" => "ce9c7c571b5016880a77890764c0e80a5637341137f589fe538efe9e7e0cf0ce",
    "LLVM.v8.0.1.x86_64-apple-darwin14-libgfortran5.tar.gz" => "34e263117dfcf43682c44c56f137af6bc14462ff71ca2801923ec56d060756f3",
    "LLVM.v8.0.1.x86_64-linux-gnu-libgfortran3.tar.gz" => "07114e12da3e8e869c01c0ddb634605f8bbd10da4786d0142077396cafec967e",
    "LLVM.v8.0.1.x86_64-linux-gnu-libgfortran4.tar.gz" => "4c7de068ffb86f978418883157622959bb2fb5cfba9c9101fcaf9edea5eca1b4",
    "LLVM.v8.0.1.x86_64-linux-gnu-libgfortran5.tar.gz" => "cc7f7cd1cb085e79d640669b99a7c08d4fb2497e5cf53216210d47b004c0470c",
    "LLVM.v8.0.1.x86_64-linux-musl-libgfortran3.tar.gz" => "d7b3ffe54fcb7f3f9e73f41a94c9e6e7054a3414b4bf19e8486902fdf0bb42d5",
    "LLVM.v8.0.1.x86_64-linux-musl-libgfortran4.tar.gz" => "2002e6f0ae32688ac0782b64a6444edf47027ce0488236ad3464fe9775c60c31",
    "LLVM.v8.0.1.x86_64-linux-musl-libgfortran5.tar.gz" => "9337169fa2cc6cf8e053fc5a60293a3b840e393a31aab536bcef3fd2546ce4bb",
    "LLVM.v8.0.1.x86_64-unknown-freebsd11.1-libgfortran3.tar.gz" => "c754b6cf75bfde83784bdd85f94250f5396bd64f883e74099ee644b72b417fff",
    "LLVM.v8.0.1.x86_64-unknown-freebsd11.1-libgfortran4.tar.gz" => "7118eb9e2014b69ac1e4c155c7fb3e8508d32770f2dc4893e73448ceeda36d38",
    "LLVM.v8.0.1.x86_64-unknown-freebsd11.1-libgfortran5.tar.gz" => "b20ff288172d0c6ea9a47e0157a1316f39d9db3955e343ad5e9abcd9c970ab31",
    "LLVM.v8.0.1.x86_64-w64-mingw32-libgfortran3.tar.gz" => "d33abacb9d4e72755c4acdf69bfbed47a40800df7536e24b71676aba2111b5a8",
    "LLVM.v8.0.1.x86_64-w64-mingw32-libgfortran4.tar.gz" => "51976aa01e82e9f1125a98cfd5d311ceed0ff4bd7a7c6afa3d2779af75d55e31",
    "LLVM.v8.0.1.x86_64-w64-mingw32-libgfortran5.tar.gz" => "bd0436a29aadfc132e60b274b559152ed081000bdd3ac2230dc6bf822eb431a8",
)

repo = "https://github.com/KhronosGroup/SPIRV-LLVM-Translator.git"
branches = Dict("llvm_release_80" => "bb96964181723d32dfe61ef7780dcbdf0f931ccf")

# Bash recipe for building across all platforms
script = raw"""
# FIXME: the CMake files in the LLVM build aren't relocatable, so move to the destdir
#        https://github.com/staticfloat/LLVMBuilder/issues/50
real_prefix="$WORKSPACE/real_destdir"
mv "${prefix}" "${real_prefix}"
# FIXME: the LLVM archives don't have a containing directory, so move srcdir in its entirety
#        https://github.com/staticfloat/LLVMBuilder/issues/49
mv "$WORKSPACE/srcdir" "${prefix}"
mkdir "$WORKSPACE/srcdir"
mv "${prefix}/SPIRV-LLVM-Translator" "$WORKSPACE/srcdir"

cd $WORKSPACE/srcdir/SPIRV-LLVM-Translator
mkdir build && cd build
cmake .. -DCMAKE_INSTALL_PREFIX="${real_prefix}" \
         -DCMAKE_TOOLCHAIN_FILE="${CMAKE_TARGET_TOOLCHAIN}" \
         -DLLVM_DIR="${prefix}/lib/cmake/llvm"
make llvm-spirv -j${nproc}
make install
# FIXME: how to install tools? LLVM_TOOLS_INSTALL_DIR and LLVM_BUILD_TOOLS are ignored
mkdir "${real_prefix}/bin" && cp tools/llvm-spirv/llvm-spirv "${real_prefix}/bin"
cd ..

rm -rf ${prefix}
mv ${real_prefix} ${prefix}

install_license LICENSE.TXT
"""

function main()
    # These are the platforms we will build for by default, unless further
    # platforms are passed in on the command line
    platforms = [
        Linux(:x86_64, libc=:glibc, compiler_abi=CompilerABI(libgfortran_version=v"5.0.0"))
    ]
    # TODO: platforms = supported_platforms, and then expand_libgfortran and/or expand_cxxstring_abis

    # The products that we will ensure are always built
    products = Product[
        ExecutableProduct("llvm-spirv", :llvm_spirv),
    ]

    # Dependencies that must be installed before this package can be built
    dependencies = [
    ]

    for (llvm_version, llvm_release) in llvm_releases
        branch = "llvm_release_$(llvm_version.major)$(llvm_version.minor)"
        commit = branches[branch]
        for platform in platforms
            llvm_filename = "LLVM.v$(llvm_version).$(triplet(platform)).tar.gz"
            llvm_url = "https://github.com/staticfloat/LLVMBuilder/releases/download/$(llvm_release)/$(llvm_filename)"
            llvm_hash = llvm_download_info[llvm_filename]
            sources = [
                repo => commit,
                llvm_url => llvm_hash,
            ]

            # Build the tarballs, and possibly a `build.jl` as well.
            build_tarballs(ARGS, name, version, sources, script, platforms, products, dependencies)
        end
    end
end
