
Add the following to ~/.bashrc


```bash
export PATH="/c/HaxeToolkit/haxe:$PATH"
export PATH="/c/HaxeToolkit/neko:$PATH"
```


Run `haxelib setup` and set the following path

`/HaxeToolkit/haxe/lib`


If you need to use `-D HXCPP_M64` you have to use the git version of hxcpp:

```bash
haxelib git hxcpp https://github.com/HaxeFoundation/hxcpp
```
