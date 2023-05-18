fx_version "adamant"
games {"rdr3"}
rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'

name "hails_loot"
author "Hailey-Ross"
description "Time and weather synchronization for FiveM and RedM"
url "https://github.com/Hailey-Ross/hails_loot"

shared_scripts {
	"config.lua"
}

client_scripts {
	"client.lua"
}

server_scripts {
	"server.lua"
}

version '0.1.1'
vorp_checker 'yes'
vorp_name '^4Resource version Check^3'
vorp_github 'https://github.com/Hailey-Ross/hails_loot'