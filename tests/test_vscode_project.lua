local suite = test.declare("vscode_project")

local p = premake
local vscode = p.modules.vscode

---------------------------------------------------------------------------
-- Setup/Teardown
---------------------------------------------------------------------------

local wks, prj

function suite.setup()
    p.action.set("vscode")
    wks = test.createWorkspace()
end

local function prepare()
    wks = p.oven.bakeWorkspace(wks)
    prj = test.getproject(wks, 1)
end

---------------------------------------------------------------------------
function suite.generateC_CppProperties()
    kind "ConsoleApp"

	includedirs { "/include" }
	defines { "DEBUG" }
    
    prepare()
    vscode.project.generateC_CppProperties(prj)

	test.capture [[
{
	"version": 4,
	"configurations": [
		{
			"name": "MyProject (Debug)",
			"includePath": [
				"/include",
			],
			"defines": [
				"DEBUG",
			],
			"compilerPath": "/usr/bin/gcc",
			"intelliSenseMode": "gcc-x64",
			"configurationProvider": "ms-vscode.makefile-tools",
		},
		{
			"name": "MyProject (Release)",
			"includePath": [
				"/include",
			],
			"defines": [
				"DEBUG",
			],
			"compilerPath": "/usr/bin/gcc",
			"intelliSenseMode": "gcc-x64",
			"configurationProvider": "ms-vscode.makefile-tools",
		},
	]
}
	]]
end

function suite.generateSettings()
    kind "ConsoleApp"

    prepare()
    vscode.project.generateSettings(prj)

    test.capture [[
    ]]
end

function suite.generateTasks()
    kind "ConsoleApp"

    prepare()
    vscode.project.generateTasks(prj)

    test.capture [[
{
	"version": "2.0.0",
	"tasks": [
		{
			"label": "Build MyProject (Debug)",
			"type": "shell",
			"command": "make",
			"windows": {
				"command": "mingw32-make"
			},
			"problemMatcher": [
				"$gcc",
			],
			"args": [
				"config=debug"
			],
			"group": {
				"kind": "build",
				"isDefault": true
			}
		},
		{
			"label": "Build MyProject (Release)",
			"type": "shell",
			"command": "make",
			"windows": {
				"command": "mingw32-make"
			},
			"problemMatcher": [
				"$gcc",
			],
			"args": [
				"config=release"
			],
			"group": {
				"kind": "build",
				"isDefault": true
			}
		},
	]
}
    ]]

end

function suite.generateLaunch()
    kind "ConsoleApp"

    prepare()
    vscode.project.generateLaunch(prj)

    test.capture [[
{
	"version": "0.2.0",
	"configurations": [
		{
			"name": "MyProject Debug",
			"type": "cppdbg",
			"program": "bin/Debug/MyProject",
			"request": "launch",
			"args": [],
			"stopAtEntry": false,
			"cwd": "${workspaceFolder}",
			"environment": [],
			"externalConsole": false,
			"MIMode": "gdb",
			"miDebuggerPath": "/usr/bin/gdb",
			"setupCommands": [
				{
					"description": "Enable pretty-printing for gdb",
					"text": "-enable-pretty-printing",
					"ignoreFailures": true
				},
				{
					"description": "Enable break on all-exceptions",
					"text": "catch throw",
					"ignoreFailures": true
				}
			],
			"preLaunchTask": "Build MyProject (Debug)"
		},
		{
			"name": "MyProject Release",
			"type": "cppdbg",
			"program": "bin/Release/MyProject",
			"request": "launch",
			"args": [],
			"stopAtEntry": false,
			"cwd": "${workspaceFolder}",
			"environment": [],
			"externalConsole": false,
			"MIMode": "gdb",
			"miDebuggerPath": "/usr/bin/gdb",
			"setupCommands": [
				{
					"description": "Enable pretty-printing for gdb",
					"text": "-enable-pretty-printing",
					"ignoreFailures": true
				},
				{
					"description": "Enable break on all-exceptions",
					"text": "catch throw",
					"ignoreFailures": true
				}
			],
			"preLaunchTask": "Build MyProject (Release)"
		},
	]
}
    ]]
end

function suite.generateExtensions()
	kind "ConsoleApp"

	prepare()
	vscode.project.generateExtensions(prj)

	test.capture [[
{
	"recommendations": [
		"ms-vscode.cpptools",
		"ms-vscode.makefile-tools"
	]
}
	]]
end

---------------------------------------------------------------------------