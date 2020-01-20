# Note that this script can accept some limited command-line arguments, run
# `julia build_tarballs.jl --help` to see a usage message.
using BinaryBuilder
using Pkg

name = "SPIRV-LLVM-Translator"
version = v"0.1"

repo = "https://github.com/KhronosGroup/SPIRV-LLVM-Translator.git"
support = Dict(
   #v"7"     => (branch="llvm_release_70", sha="a296c386d666158253c144f3d3cc3d8b82cffa3f"),
   #v"8"     => (branch="llvm_release_80", sha="bb96964181723d32dfe61ef7780dcbdf0f931ccf"),
    v"9.0.1" => (branch="llvm_release_90", sha="f3d0b0bed7a3ed256f8cf4b1091657e5fd9ef54c"),
   #v"10"    => (branch="master",          sha="129232c63aa95235f27af1050effe2007994c5f0")
)

# Bash recipe for building across all platforms
script = raw"""
cd $WORKSPACE/srcdir/SPIRV-LLVM-Translator
mkdir build && cd build
cmake .. -DCMAKE_INSTALL_PREFIX="${prefix}" \
         -DCMAKE_TOOLCHAIN_FILE="${CMAKE_TARGET_TOOLCHAIN}" \
         -DLLVM_DIR="${prefix}/lib/cmake/llvm"
make llvm-spirv -j${nproc}
make install
# FIXME: how to install tools? LLVM_TOOLS_INSTALL_DIR and LLVM_BUILD_TOOLS are ignored
cp tools/llvm-spirv/llvm-spirv "${prefix}/bin"
cd ..

install_license LICENSE.TXT
"""

function main(args::Vector=String[])
    # These are the platforms we will build for by default, unless further
    # platforms are passed in on the command line
    platforms = [
        Linux(:x86_64, libc=:glibc, compiler_abi=CompilerABI(cxxstring_abi=:cxx11))
    ]
    # TODO: platforms = supported_platforms, and then expand_libgfortran and/or expand_cxxstring_abis

    # The products that we will ensure are always built
    products = Product[
        ExecutableProduct("llvm-spirv", :llvm_spirv),
    ]

    for (llvm_version, (branch, commit)) in support
        # Collection of sources required to build this package
        sources = [repo => commit]

        # Dependencies that must be installed before this package can be built
        dependencies = [
            PackageSpec(name="LLVM_jll", version=llvm_version)
        ]

        # Build the tarballs, and possibly a `build.jl` as well.
        build_tarballs(args, name, version, sources, script, platforms, products, dependencies; preferred_gcc_version=v"6")
    end
end

isinteractive() || main(ARGS)
