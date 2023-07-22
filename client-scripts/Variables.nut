lagaVobMaxSize <- 0
lagaVob <- []
lagaVobName <- null //"ITMW_1H_BAU_MACE"//"addon_valleyplant_tree_01_l_357p.3DS" //"Plant_langbush.3DS"
lagaVobGive <- "ITMW_1H_BAU_MACE"
lagavobonelife <- 0
lagavobrespawn <- 0
lagavobdraw <- "przedmiot"
LvobStaminaCost <- 33

lagatoggle <- false

lvobdraws <- [] //infoDrawy, jako elementy ma lvec3

LVshowDraws <- [] //widoczne drawy

lvobEdit <- false;
buttonDown <- false

focused <- null

function debug(x)
{
	debugPacket <- Packet()
	debugPacket.writeUInt8(LvobPacketId)
	debugPacket.writeUInt8(LvobPacket.spawnLagaVobNot) 
	debugPacket.writeString(x)
	debugPacket.send(RELIABLE);
}

function LvobDrawName(draw)
{
	if(LvobStaminaCost>0)
	return draw + " (koszt:" + LvobStaminaCost.tostring() + ")"
	return draw
}

class lvec3
{
	x = 0.0
	y = 0.0
	z = 0.0
	
	constructor(_x, _y, _z) {
        x = _x;
        y = _y;
		z = _z
    }
	
	function setVec(_x, _y, _z) {
        x = _x;
        y = _y;
		z = _z
    }
}