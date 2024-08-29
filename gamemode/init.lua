AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include( "shared.lua" )
include( "sv_player.lua" )
include( "sv_queue.lua" )
include( "sv_rounds.lua")

DEFINE_BASECLASS( "gamemode_base" )