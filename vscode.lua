--
-- Name:        _preload.lua
-- Purpose:     Define the vscode action.
-- Author:      Stephan Guingor
-- Created:     2022/11/06
--

    local p = premake

    p.modules.vscode = {}
    p.modules.vscode._VERSION = p._VERSION

    local vscode = p.modules.vscode
    local project = p.project

    function vscode.generateWorkspace(wks)
        print("Generating VSCode workspace")
    end
    
    function vscode.generateProject(prj)
    p.eol("\r\n")
    p.indent("  ")

    if project.iscpp(prj) or project.isc(prj) then
        p.generate(prj, prj.location .. '/' .. prj.name .. "/.vscode/c_cpp_properties.json", vscode.project.generateC_CppProperties)
        p.generate(prj, prj.location .. '/' .. prj.name .. "/.vscode/launch.json", vscode.project.generateLaunch)
        p.generate(prj, prj.location .. '/' .. prj.name .. "/.vscode/settings.json", vscode.project.generateSettings)
        p.generate(prj, prj.location .. '/' .. prj.name .. "/.vscode/tasks.json", vscode.project.generateTasks)
    end
    end

    function vscode.cleanWorkspace(wks)
    p.clean.file(wks, wks.name .. ".code-workspace")
    end

    function vscode.cleanProject(prj)
        p.clean.file(prj, prj.name .. ".vscode")
    end

    include("vscode_workspace.lua")
    include("vscode_project.lua")

    include("_preload.lua")

    return vscode

