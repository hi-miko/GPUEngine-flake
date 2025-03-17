# GPUEngine flake

## Dependencies

For this flake to work you need the [ste flake](https://github.com/hi-miko/ste-flake)

## Description

This is a working nix flake for the GPUEngine [repository](https://github.com/Rendering-FIT/GPUEngine).
It compiles GPUEngine and links the GPUEngine library.

I have also included 3 patches that need to be applied for the code to actually compile on linux, these patches don't change
the behavior of the code, 1 adds the `cstdint` library where it's needed and the other 2 add library class visibility to default via a macro,
which I assume is what the original macro is doing, but I couldn't find the macro anywhere.

The library has also been tested on examples found [here](https://github.com/forry/GPUEngine-examples) and so it should work. Although
it's important to mention that the **paths currently are set up for a specific machine**. They should be update to be relative.

It is also important to mention that this flake is not at all optimalized and requires qtFull among other things. This might change in
do time.
