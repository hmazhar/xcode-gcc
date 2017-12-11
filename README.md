# xcode-gcc
A compiler plugin collection for Xcode 8 and 9.

Supported compilers: GCC 4.9 (not tested), GCC 7.2 (`/usr/local/bin/gcc-7` from Homebrew), MPICC that uses the default `clang` (default installation from Homebrew), NVIDIA NVCC 9.0 (`/usr/local/cuda/bin/nvcc`, requires clang 8.1).

Installation:
If you need to install to non-default Xcode version, set `XCODE` environment variable to the path to used Xcode.

GCC 4.9:

```
make gcc-49
sudo make install-gcc-49
```

GCC 7.2:

```
make gcc-72
sudo make install-gcc-72
```

MPICC:

```
make mpicc-clang
sudo make install-mpicc-clang
```

NVCC:

```
make nvcc
sudo make install-nvcc
```

Plugins are installed into `/Library/Application Support/Developer/Shared/Xcode/Plug-ins`, but each plugin is made for a specific Xcode version and won't load in other versions.

Based off https://github.com/hellobbn/xcode-gcc, fixed localizable strings encoding and modified for MPICC and NVCC.

References:

http://hamelot.co.uk/programming/add-gcc-compiler-to-xcode-6/

https://code.google.com/p/xcode-gcc-plugin/

http://stackoverflow.com/questions/19061966/how-to-use-a-recent-gcc-with-xcode-5
