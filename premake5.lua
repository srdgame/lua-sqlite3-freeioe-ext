-- A solution
workspace "lua-sqlite3"
	configurations { "Debug", "Release"}

project "core"
	kind "SharedLib"
	language "C++"
	location "build"
	targetprefix ""
	targetdir "bin/%{cfg.buildcfg}/sqlite3"

	--includedirs { "/usr/include/lua5.3", ".", "../../build/" }
	includedirs { "/home/cch/mycode/skynet/3rd/lua/", ".", "sqlite3" }
	files { 
		"./sqlite3/**.h", 
		"./sqlite3/**.c",
		"./lua-sqlite3/libluasqlite3.c",
	}
	links { "pthread" }

	filter "configurations:Debug"
		defines { "DEBUG" }
		symbols "On"

	filter "configurations:Release"
		defines { "NDEBUG" }
		optimize "On"

