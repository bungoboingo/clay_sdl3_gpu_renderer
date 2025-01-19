A WIP odin clay renderer for SDL3 gpu with homegrown SDL3 bindings

### Currently supports:
- Quads
- Rounded corners
- Text
- Borders (single color, single size)

### Supported shader fmts:
- SPIR-V, Metal

(You can very easily add support for DirectX shaders with some transpile tool from SPIRV, I just don't care about Windows atm)

### TODO:
- [ ] Image support
- [ ] Floating element support (waiting on [clay-184](https://github.com/nicbarker/clay/issues/184))
- [ ] Probably should add support for different color borders at some point
- Probably will never add support for borders of different widths

### **Use at your own risk!**
This is very much a personal project that I've implemented the bare minimum of what I need to get my UI done.
This is very poorly tested outside my specific setup (MacOS). SDL3 bindings may be incorrect in some cases.

I am posting this here so others can see how to do a basic SDL3 gpu setup with Clay.

## To run:
- Run `./compile_shaders.sh`
  - This needs `glslangValidator` & `spirv-cross`
- `odin run . -collection:library=/path/to/library -debug`
  - If on MacOS, might need to add `-extra-linker-flags="-L/usr/local/lib -Wl,-rpath,/usr/local/lib"` depending on where your SDL3 is installed