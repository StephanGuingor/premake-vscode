[Visual Studio Code](https://code.visualstudio.com/) generator for [Premake](https://github.com/premake/premake-core) and [Makefile](https://www.gnu.org/software/make/) support.

# Usage
1. Put these files in a `vscode` subdirectory in one of [Premake's search paths](https://github.com/premake/premake-core/wiki/Locating-Scripts).

2. Add the line `require "vscode"` preferably to your [premake-system.lua](https://github.com/premake/premake-core/wiki/System-Scripts), or to your premake5.lua script.

For cuda support, add `require "premake5-cuda"` to your premake5.lua script and copy the plugins/premake5-cuda folder to your project.
More information about the cuda support can be found [here](https://github.com/theComputeKid/premake5-cuda).

3. Generate 
```sh

premake5 vscode
```
