Hero <- {
    stamina = 100.0,
	}
	
enum PlayerRole {
    GameMaster
}	
	
local function showStamina()
{
	setPlayerMaxHealth(0, Hero.stamina.tointeger())
}

addEventHandler("onInit", showStamina)



local function mainLoopbar()
{
	setPlayerMaxHealth(0, 100)
	setPlayerHealth(0, Hero.stamina)
}

addEventHandler("onRender", mainLoopbar)

class Roles
{
	role = 10
}

function getAdmin(pid)
{
	local r = Roles()
	return r;
}