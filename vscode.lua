--
-- Name:        vscode.lua
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

        p.utf8()

        p.escaper(p.modules.gmake2.esc)
		wks.projects = table.filter(wks.projects, function(prj) return p.action.supports(prj.kind) and prj.kind ~= p.NONE end)

		p.generate(wks, p.modules.gmake2.getmakefilename(wks, false), p.modules.gmake2.generate_workspace)
    end
    
    function vscode.generateProject(prj)
    p.eol("\r\n")
    p.indent("  ")

    if project.iscpp(prj) or project.isc(prj) then
        p.generate(prj, path.join(prj.location, ".vscode/c_cpp_properties.json"), vscode.project.generateC_CppProperties)
        p.generate(prj, path.join(prj.location, ".vscode/settings.json"), vscode.project.generateSettings)
        p.generate(prj, path.join(prj.location, ".vscode/tasks.json"), vscode.project.generateTasks)
        p.generate(prj, path.join(prj.location, ".vscode/extensions.json"), vscode.project.generateExtensions)

       
        if prj.kind == "ConsoleApp" then
            p.generate(prj, path.join(prj.location , ".vscode/launch.json"), vscode.project.generateLaunch)
        end
      
    end

    p.escaper(p.modules.gmake2.esc)
	
    -- Generate makefile
    p.generate(prj, p.modules.gmake2.getmakefilename(prj, true), p.modules.gmake2.cpp.generate)
    end

    function vscode.cleanWorkspace(wks)
    p.clean.file(wks, wks.name .. ".code-workspace")

    p.clean.file(wks, p.modules.gmake2.getmakefilename(wks, false))
    end

    function vscode.cleanProject(prj)
        p.clean.file(prj, prj.name .. ".vscode")

        p.clean.file(prj, p.modules.gmake2.getmakefilename(prj, true))
    end

    include("vscode_workspace.lua")
    include("vscode_project.lua")

    include("_preload.lua")

    return vscode

