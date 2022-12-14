--------------------------------------------
>> Premake5 module for CUDA
--------------------------------------------

Extends Premake5 by enabling the use of CUDA in native MSVC or GNU make projects

Enabled macros (listed in premake5-cuda/cuda-exported-variables.lua):
- cudaFiles (Table) -> list of files to be compiled by NVCC (absolute path from solution root)
- cudaRelocatableCode (Bool) -> triggers -rdc=true
- cudaExtensibleWholeProgram (Bool) -> triggers extensible whole program compilation
- cudaCompilerOptions (Table) -> passed to nvcc
- cudaLinkerOptions (Table) -> passed to nvlink
- cudaFastMath (Bool) -> triggers fast math optimizations
- cudaVerbosePTXAS (Bool) -> triggers code gen verbosity
- cudaMaxRegCount (String) -> number to determine the max used registers
- cudaPath (string) -> Path to CUDA root directory on Linux

To use: 
- Copy the premake5-cuda folder to your project
- Include it in your premake5.lua file

An example of the usage of these macros is given in a sample premake5.lua (for CUDA 11.4) at the root of this project.

Tested with:
- Visual Studio 2019 (toolkit v142) with CUDA toolkit 11.4 integrated
- GNU make on Linux with CUDA toolkit 11.4

Note:
- Requires installing CUDA toolkit integration for Visual Studio
- Be careful not to tell Visual Studio to compile the same file with both its compiler AND NVCC - pick one!
- Written by a C++ developer with no experience in LUA
- Tokens (e.g. %{wks.location}) can not yet be consumed by these settings but globs can be taken by cudaFiles
- MIT license: Enjoy!