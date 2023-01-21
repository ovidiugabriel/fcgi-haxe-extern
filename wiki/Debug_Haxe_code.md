## Debug in VS Code

### For HXCPP

1. Install HXCPP debugger extension for VSCode
https://marketplace.visualstudio.com/items?itemName=vshaxe.hxcpp-debugger
2. Install the hxcpp-debugger using haxelib
`haxelib install hxcpp-debug-server`

Add `-lib hxcpp-debug-server` to `build.hxml` as it is specified on the [vshaxe](https://marketplace.visualstudio.com/items?itemName=vshaxe.hxcpp-debugger) extension page.

```
--cpp output
-lib hxcpp-debug-server
-main Test 
-debug
```

Add a launch configuration as it is specified on the [vshaxe](https://marketplace.visualstudio.com/items?itemName=vshaxe.hxcpp-debugger) extension page.

```json
{
    "version": "0.2.0",
    "configurations": [        
        {
            "name": "Haxe HXCPP",
            "type": "hxcpp",
            "request": "launch",
            "program": "${workspaceFolder}/output/Test-debug"
        }
    ]
}
```

**IMPORTANT**  First you have to build the binary then you can debug it. The debugger won't create it for you.



## Debug in the browser Dev Tools

