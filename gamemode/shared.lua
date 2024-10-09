GM.Name 	= "Trash Compactor"
GM.Author 	= "VictimofScience & Landmine752 & vicentefelipechile"
GM.Email 	= ""
GM.Website 	= "http://www.gmodstore.com"
GM.Help		= "Beware the Trashman"

DeriveGamemode( "sandbox" )

GM.TeamBased = true

if ( CLIENT ) then
	CreateConVar( "cl_playercolor", "0.24 0.34 0.41", { FCVAR_ARCHIVE, FCVAR_USERINFO, FCVAR_DONTRECORD }, "The value is a Vector - so between 0-1 - not between 0-255" )
	CreateConVar( "cl_weaponcolor", "0.30 1.80 2.10", { FCVAR_ARCHIVE, FCVAR_USERINFO, FCVAR_DONTRECORD }, "The value is a Vector - so between 0-1 - not between 0-255" )
	CreateConVar( "cl_playermodel", "0", { FCVAR_ARCHIVE, FCVAR_USERINFO, FCVAR_DONTRECORD }, "The skin to use, if the model has any" )
	CreateConVar( "cl_playerbodygroups", "0", { FCVAR_ARCHIVE, FCVAR_USERINFO, FCVAR_DONTRECORD }, "The bodygroups to use, if the model has any" )
end

TrashCompactor = {}
TrashCompactor.DefaultUInt = 3

if SERVER then
	AddCSLuaFile( "modules/sh_cami.lua" )
	AddCSLuaFile( "sh_privileges.lua" )

	AddCSLuaFile( "sh_config.lua" )
	AddCSLuaFile( "sh_team.lua" )
	AddCSLuaFile( "sh_rounds.lua" )
	AddCSLuaFile( "sh_queue.lua" )

	AddCSLuaFile( "cl_init.lua" )
	AddCSLuaFile( "cl_scoreboard.lua" )
	AddCSLuaFile( "cl_configmenu.lua" )
end

include( "modules/sh_cami.lua" )
include( "sh_privileges.lua" )

include( "sh_config.lua" )
include( "sh_team.lua" )
include( "sh_rounds.lua" )
include( "sh_queue.lua" )

if CLIENT then
	include( "cl_init.lua" )
	include( "cl_scoreboard.lua" )
	include( "cl_configmenu.lua" )
end