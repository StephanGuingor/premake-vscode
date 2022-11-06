--
-- Name:        vscode_project.lua
-- Purpose:     Define the vscode action.
-- Author:      Stephan Guingor
-- Created:     2022/11/06
--

local p = premake
local tree = p.tree
local project = p.project
local config = p.config
local vscode = p.modules.vscode

vscode.project = {}
local m = vscode.project

function m.getCompiler(cfg)
    local toolset = p.tools[_OPTIONS.cc or cfg.toolset]

    if not toolset then
        error("No toolset found for '" .. (_OPTIONS.cc or cfg.toolset) .. "'")
    end

    return toolset
end

function m.cudaSupport(cfg)
    if cfg.cudaFiles ~= nil then
        return true
    end
end

function m.getTaskName(cfg)
    local taskName = "Build " .. cfg.buildtarget.name .. " (" .. cfg.buildcfg .. ")"
    
    return taskName
end

--
-- Project: Generate vscode launch.json.
--
function m.generateTasks(prj)
    p.utf8()

    p.push('{')
        p.w('"version": "2.0.0",')
        p.push('"tasks": [')
            for cfg in project.eachconfig(prj) do
                p.push('{')
                    p.w('"label": "%s",', m.getTaskName(cfg))
                    p.w('"type": "shell",')
                    p.w('"command": "make",')
                    
                    -- if windows then
                    p.push('"windows": {')
                        p.w('"command": "mingw32-make"')
                    p.pop('},')
                    -- end

                    p.push('"problemMatcher": [')
                    
                    local toolset = m.getCompiler(cfg)
                    local problemMatcher = "$gcc"

                    if m.cudaSupport(cfg) then
                        problemMatcher = "$nvcc"
                    end

                    p.w('"' .. problemMatcher .. '",')

                    p.pop('],')

                    p.push('"args": [')
                        p.w('"config=%s"', string.lower(cfg.buildcfg))
                    p.pop('],')

                    p.push('"group": {')
                        p.w('"kind": "build",')
                        p.w('"isDefault": true')
                    p.pop('}')

                    p.pop('},')
            end 
        p.pop("]")
    p.pop("}")
end

--
-- Project: Generate vscode launch.json.
--
function m.generateLaunch(prj)
    p.utf8()

    p.push('{')
        p.w('"version": "0.2.0",')
        p.push('"configurations": [')
            for cfg in project.eachconfig(prj) do
                p.push('{')
                    p.w('"name": "%s %s",', cfg.buildtarget.name, cfg.buildcfg)
                    p.w('"type": "cppdbg",')

                    -- build target directory relative to workspace
                    local buildTargetDir = path.getrelative(prj.location, cfg.buildtarget.directory)
                    p.w('"program": "%s/%s",', buildTargetDir, cfg.buildtarget.name)

                    p.w('"request": "launch",')
                    p.w('"args": [],')
                    p.w('"stopAtEntry": false,')
                    p.w('"cwd": "${workspaceFolder}",')
                    p.w('"environment": [],')
                    p.w('"externalConsole": false,')
                    p.w('"MIMode": "gdb",')
                    p.w('"miDebuggerPath": "/usr/bin/gdb",')
                    p.push('"setupCommands": [')
                        p.push('{')
                            p.w('"description": "Enable pretty-printing for gdb",')
                            p.w('"text": "-enable-pretty-printing",')
                            p.w('"ignoreFailures": true')
                        p.pop('},')
                        p.push('{')
                            p.w('"description": "Enable break on all-exceptions",')
                            p.w('"text": "catch throw",')
                            p.w('"ignoreFailures": true')
                        p.pop('}')
                    p.pop('],')
                    p.w('"preLaunchTask": "%s"', m.getTaskName(cfg))
                p.pop('},')
            end
        p.pop(']')
    p.pop('}')
end

--
-- Project: Generate vscode c_cpp_properties.json.
--
function m.generateC_CppProperties(prj)
    p.utf8()

    p.push("{")
        p.w('"version": 4,')
        p.push('"configurations": [')
            for cfg in project.eachconfig(prj) do
                p.push("{")
                    p.w('"name": "%s (%s)",', prj.name, cfg.name)
                    p.push('"includePath": [')
                        for _, dir in ipairs(cfg.includedirs) do
                            p.w('"%s",', dir)
                        end
                    p.pop("],")
                    p.push('"defines": [')
                        for _, define in ipairs(cfg.defines) do
                            p.w('"%s",', define)
                        end
                    p.pop("],")
                    -- get compiler path in premake
                    p.w('"compilerPath": "/usr/bin/gcc",')

                    if cfg.cdialect then
                        p.w('"cStandard": "%s",', cfg.cdialect)
                    end

                    if cfg.cppdialect then
                        p.w('"cppStandard": "%s",', cfg.cppdialect)
                    end

                    -- get intelisense mode based on platform
                    if cfg.system == "windows" then
                        p.w('"intelliSenseMode": "msvc-x64",')
                    else
                        p.w('"intelliSenseMode": "gcc-x64",')
                    end

                    p.w('"configurationProvider": "ms-vscode.makefile-tools",')

                p.pop("},")
            end
        p.pop("]")
    p.pop("}")
end

--
-- Project: Generate vscode settings.json.
--
function m.generateSettings(prj)
    p.utf8()

    
end


--
-- Project: Generate vscode extensions.json.
--
function m.generateExtensions(prj)
    p.utf8()

    p.push('{')
        p.push('"recommendations": [')
            p.w('"ms-vscode.cpptools",')
            p.w('"ms-vscode.makefile-tools",')

            -- if any cuda files then
            for cfg in project.eachconfig(prj) do
                if m.cudaSupport(cfg) then
                   p.w('"nvdia.nsight-vscode-edition"')
                   break
                end
            end

        p.pop(']')
    p.pop('}')
end
