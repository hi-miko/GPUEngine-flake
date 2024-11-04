# GPUEngine flake

This is a minimally working nix flake for the GPUEngine [repository](https://github.com/Rendering-FIT/GPUEngine).
It creates a GPUEngine and links the GPUEngine library and also creates it's documentation.

I have also included 3 patches that need to be applied for the code to actually compile on linux, these patches don't change
the behavior of the code, 1 adds the `cstdint` library where it's needed and the other 2 add library class visibility to default via a macro,
which I assume is what the original macro is doing, but I couldn't find the macro anywhere.

The library has also been tested on examples found [here](https://github.com/forry/GPUEngine-examples) and so it should work

It is also important to mention that this flake is no at all optimalized and requires qtFull among other things. This might change in
do time.
