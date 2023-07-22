local LvGui = null

local function checkModel(x)
{
	local string = x.toupper()
	if( string.find(".3DS", string.len()-5) != null)
	{
		return string;
	}
	else
	{
		try {
			if ( Daedalus.instance(string) == null) {
					throw "Brak visual";
			}
			local instance = Daedalus.instance(string)
			local x = instance.visual;
			if(x!=null)
			return instance.visual;
			return null;
		} 
		catch (err) {
			return null
		}
	}
}

function onCommand(cmd, params)
{
	switch (cmd)
	{
	case "lvobspawn":
		local vec = getPlayerPosition(heroId)
		myPacket <- Packet();
		if(lagaVob.len()>=lagaVobMaxSize)
		{
			myPacket.writeUInt8(LvobPacketId)
			myPacket.writeUInt8(LvobPacket.spawnLagaVobNot) 
			myPacket.writeString("Osiagnieto max vobow: " + lagaVobMaxSize.tostring())
			myPacket.send(RELIABLE);
		}
		else
		{	
			myPacket.writeUInt8(LvobPacketId)
			myPacket.writeUInt8(LvobPacket.spawnLagaVob) 
			myPacket.writeString(lagaVobName) 
			myPacket.writeString(lagaVobGive) 
			myPacket.writeString(lagavobdraw) 
			myPacket.writeFloat(vec.x)  
			myPacket.writeFloat(vec.y)  
			myPacket.writeFloat(vec.z)  
			myPacket.writeInt32(lagavobonelife)
			myPacket.writeInt32(LvobStaminaCost)
			myPacket.send(RELIABLE);
		}
		break

	case "lvobname":
		local x = checkModel(params)
		if( x!=null )
		{	
			namePacket<- Packet();
			namePacket.writeUInt8(LvobPacketId)
			namePacket.writeUInt8(LvobPacket.changelvobname) 
			namePacket.writeString( x )
			namePacket.send(RELIABLE);
		}
		else
		{
			namePacket <- Packet();
			namePacket.writeUInt8(LvobPacketId)
			namePacket.writeUInt8(LvobPacket.spawnLagaVobNot)
			namePacket.writeString("Nie ma takiego obiektu lub modelu.")
			namePacket.send(RELIABLE);
		}
		break
		
	case "lvobgive":
		if( Items.id(params.tostring()) < 0 )
		{
			givePacket <- Packet();
			givePacket.writeUInt8(LvobPacketId)
			givePacket.writeUInt8(LvobPacket.spawnLagaVobNot)
			givePacket.writeString("Nie ma takiego itemu.")
			givePacket.send(RELIABLE);
		}
		else
		{
			givePacket<- Packet();
			givePacket.writeUInt8(LvobPacketId)
			givePacket.writeUInt8(LvobPacket.changelvobgive) 
			givePacket.writeString( params.tostring() )
			givePacket.send(RELIABLE);
		}
		break
		
	case "lvobone":
		givePacket<- Packet();
		givePacket.writeUInt8(LvobPacketId)
		givePacket.writeUInt8(LvobPacket.changelvobonelife) 
		givePacket.writeInt32(params.tointeger())
		givePacket.send(RELIABLE);
		break

	case "lvobstamina":
		givePacket<- Packet();
		givePacket.writeUInt8(LvobPacketId)
		givePacket.writeUInt8(LvobPacket.changelvobstamina) 
		givePacket.writeInt32(params.tointeger())
		givePacket.send(RELIABLE);
		break

	case "lvobmax":
		local newSize = params.tointeger()
		if(newSize!=null)
		{
			lvsizePacket <- Packet();
			lvsizePacket.writeUInt8(LvobPacketId)
			lvsizePacket.writeUInt8(LvobPacket.setlagvobmaxsize)
			lvsizePacket.writeInt32(newSize)
			lvsizePacket.send(RELIABLE);
		}
		break
	
	case "lvobdelete":
		local x = params.tointeger()
		if(x>=0 && x<lagaVob.len())
		{
			lvdelPacket <- Packet();
			lvdelPacket.writeUInt8(LvobPacketId)
			lvdelPacket.writeUInt8(LvobPacket.lvobdelete)
			lvdelPacket.writeInt32(x)
			lvdelPacket.send(RELIABLE);
		}
		else
		{
			lvdelPacket <- Packet();
			lvdelPacket.writeUInt8(LvobPacketId)
			lvdelPacket.writeUInt8(LvobPacket.spawnLagaVobNot)
			lvdelPacket.writeString("Nie ma obiektu o takim ID.")
			lvdelPacket.send(RELIABLE);
		}
		break
	
	case "lvobtoggle":
		lvtogPacket <- Packet();
		lvtogPacket.writeUInt8(LvobPacketId)
		lvtogPacket.writeUInt8(LvobPacket.lvobtoggle)
		lvtogPacket.writeBool(!lagatoggle)
		lvtogPacket.send(RELIABLE);
		break
	
	case "lvobedit":
		local arg = params.tointeger()
		if(arg<lagaVob.len())
		{
			if(arg<0)
			arg = lagaVob.len() - 1
			lveditPacket <- Packet();
			lveditPacket.writeUInt8(LvobPacketId)
			lveditPacket.writeUInt8(LvobPacket.lvobedit)
			lveditPacket.writeUInt32(arg)
			lveditPacket.send(RELIABLE);
		}
		else
		{
			lveditPacket <- Packet();
			lveditPacket.writeUInt8(LvobPacketId)
			lveditPacket.writeUInt8(LvobPacket.spawnLagaVobNot)
			lveditPacket.writeString("Nieprawidlowy parametr")
			lveditPacket.send(RELIABLE);
		}
		break
		
	case "lf":
		myPacket <- Packet()
		myPacket.writeUInt8(LvobPacketId)
		myPacket.writeUInt8(LvobPacket.lvobfind) 
		myPacket.writeString(params.tostring().toupper())
		myPacket.send(RELIABLE);
	break
	
	case "ldraw":
		namePacket<- Packet();
		namePacket.writeUInt8(LvobPacketId)
		namePacket.writeUInt8(LvobPacket.changelvobdraw) 
		namePacket.writeString(params.tostring())
		namePacket.send(RELIABLE);
	break;
	}
}

addEventHandler("onCommand", onCommand)


local function getFocusHandler(type, id, name)
{
	focused = Mob(getFocusVob())
}
addEventHandler("onTakeFocus", getFocusHandler)

local function lostFocusHandler(type, id, name)
{
	focused = null
}
addEventHandler("onLostFocus", lostFocusHandler)


function LvobPickItemHandler(key)
{
	if(getPlayerWeaponMode(heroId) != 0 || focused == null)
		return;
	if(key == MOUSE_LMB && lagaVob != null && !lvobEdit && Hero.stamina > LvobStaminaCost)
	{
		local i = 0
		local vecP = getPlayerPosition(heroId)
		foreach (vob in lagaVob)
		{
			local vecV = vob.getPosition()
			if(getDistance3d(vecP.x,vecP.y,vecP.z, vecV.x,vecV.y,vecV.z)<150)
			{
				myPacket <- Packet();
				myPacket.writeUInt8(LvobPacketId)
				myPacket.writeUInt8(LvobPacket.GiveItem) 
				myPacket.writeInt32(i) 
				myPacket.send(RELIABLE);

				return;
			} 
			i++
		}
	}
}

addEventHandler("onMouseClick", LvobPickItemHandler)

local function RefreshDraws()
{
	local id = 0
	foreach (draw in lvobdraws)
	{
		local d = Draw3d(draw.x, draw.y, draw.z)
		d.insertText("ID: " + id.tostring())
		d.visible = true
		d.distance = 3000
		id++
		LVshowDraws.append(d)
	}		
}

function onPacket(packet) {
	local GetPacket = packet.readUInt8()
	if(GetPacket != LvobPacketId)
		return;
	local descr = packet.readUInt8()
	switch(descr)
	{
		case LvobPacket.spawnLagaVob:
			local name = packet.readString()
			local give = packet.readString()
			local draw = packet.readString()
			local x = packet.readFloat()
			local y = packet.readFloat()
			local z = packet.readFloat()

			local vob = Mob(name)
			vob.name = LvobDrawName(draw)
			vob.addToWorld()
			vob.setPosition(x, y, z)
			
			local drawPos = lvec3(x,y,z)
			
			lagaVob.append(vob)
			lvobdraws.append(drawPos)
			if(lagatoggle)
			{
				local id = lvobdraws.len()-1
				local d = Draw3d(lvobdraws[id].x, lvobdraws[id].y, lvobdraws[id].z)
				d.insertText("ID: " + id.tostring())
				d.visible = true
				d.distance = 3000
				id++
				LVshowDraws.append(d)
			}
		break
		
		case LvobPacket.LagaVobInit:
			lagaVobMaxSize = packet.readUInt32()	
			local num = packet.readUInt32()			
			if(num != 0)
			{
				for(local i=0; i<num; i++)
				{
					local name = packet.readString()
					local give = packet.readString()
					local draw = packet.readString()
					local x = packet.readFloat()
					local y = packet.readFloat()
					local z = packet.readFloat()
					local rx = packet.readFloat()
					local ry = packet.readFloat()
					local rz = packet.readFloat()
					local respawnTimeLeft = packet.readUInt32()
					local staminaCost = packet.readInt32()

					local vob = Mob(name)
					vob.name = LvobDrawName(draw)
					if(respawnTimeLeft == 0)
					vob.addToWorld()
					vob.setPosition(x, y, z)
					vob.setRotation(rx, ry, rz)
					local drawPos = lvec3(x,y,z)
					
					lagaVob.append(vob)
					lvobdraws.append(drawPos)
				}
			}
		break
		
		case LvobPacket.setlagvobmaxsize:
			lagaVobMaxSize = packet.readInt32();
			if(lagaVob.len()>lagaVobMaxSize)
			{
				local leng = lagaVob.len() - lagaVobMaxSize;
				
				for(local i=0; i<leng; i++)
				{
					lagaVob.remove(0);
					lvobdraws.remove(0);
				}
				LVshowDraws.clear()
				if(lagatoggle)
				{
					RefreshDraws()
				}
			}
		break
		
		case LvobPacket.lvobdelete:
			local x = packet.readInt32();
			lagaVob.remove(x);
			lvobdraws.remove(x);
			LVshowDraws.clear()
			if(lagatoggle)
			{
				RefreshDraws()
			}
		break
		
		case LvobPacket.changelvobname:
			lagaVobName = packet.readString();
			if(lvobEdit)
			{
				LvGui.changeName()
				disableControls(true)
			}
		break
		
		case LvobPacket.changelvobgive:
			lagaVobGive = packet.readString();
			if(lvobEdit)
			{
				LvGui.changeGive()
				disableControls(true)
			}
		break
		
		case LvobPacket.changelvobstamina:
			LvobStaminaCost = packet.readInt32();
			if(lvobEdit)
			{
				LvGui.changeStamina()
				disableControls(true)
			}
		break
		
		case LvobPacket.changelvobdraw:
			lagavobdraw = packet.readString();
			if(lvobEdit)
			{
				LvGui.changeDraw()
				disableControls(true)
			}
		break
		
		case LvobPacket.changelvobonelife:
			lagavobonelife = packet.readInt32();
		break
		
		case LvobPacket.lvobtoggle:
			if(lagatoggle)
			{
				LVshowDraws.clear()
				lagatoggle = false
			}
			else
			{
				RefreshDraws()
				lagatoggle = true
			}
		break
		
		case LvobPacket.lvobedit:
			local id = packet.readUInt32()
			lagavobonelife = packet.readUInt32()
			LvobStaminaCost = packet.readUInt32()
			lagavobrespawn = packet.readUInt32()
			lagaVobGive = packet.readString()
			lagavobdraw = packet.readString()
		
			lagaVobName = lagaVob[id].getVisual()
			lvobEdit = true;
			if(LvGui == null)
			LvGui = LvobGui()
			LvGui.initVisuals(id)
			setCursorVisible(true)
			
			//Camera.movementEnabled = false
			disableControls(true)
			Camera.setTargetVob(lagaVob[id])
			LvGui.oldPos = lagaVob[id].getPosition()
			LvGui.oldRot = lagaVob[id].getRotation()
			LvGui.oldVisual = lagaVobName
		break
		
		case LvobPacket.UpdatelvPacket:
			local id = packet.readInt32()
			local x = packet.readFloat()
			local y = packet.readFloat()
			local z = packet.readFloat()
			local rx = packet.readFloat()
			local ry = packet.readFloat()
			local rz = packet.readFloat()
			local newModel = packet.readString()
			local newDraw = packet.readString()
			
			lagaVob[id].setPosition(x, y, z)
			lagaVob[id].setRotation(rx, ry, rz)
			lagaVob[id].setVisual(newModel)
			lagaVob[id].name = LvobDrawName(newDraw)
			
			lvobdraws[id].setVec(x, y, z)
			LVshowDraws[id].setWorldPosition(x, y, z)
			
			//tutaj packet.sendToAll(RELIABLE)
		break
		
		case LvobPacket.lvobhide:
			local id = packet.readInt32()
			lagaVob[id].removeFromWorld()
		break
		
		case LvobPacket.lvobshow:
			local id = packet.readInt32()
			lagaVob[id].addToWorld()
		break
		
		case LvobPacket.lvobfind:
			LvGui.changeTypedText(packet.readString())
			if(lvobEdit)
			{
				disableControls(true)
			}
			if(LvGui.changingVob || LvGui.changingVobGive)
			{
				LvGui.updateRender()
			}
		break
		
		case LvobPacket.GiveItem:
			playAni(heroId, "T_PLUNDER")
			/*local x = (vecV.x - vecP.x);
			local y = (vecV.z - vecP.z);
			local angle = (arctan2(x, y)*180)/PI;
			setPlayerAngle(heroId, angle)*/
			
			Hero.stamina -= LvobStaminaCost;
		break;
	}
}

addEventHandler("onPacket",onPacket);

local function lagVobInit()
{
	initPacket <- Packet();
	initPacket.writeUInt8(LvobPacketId)
	initPacket.writeUInt8(LvobPacket.LagaVobInit) 
	initPacket.send(RELIABLE);
}

addEventHandler("onInit", lagVobInit)


local function lvGuiHandler(param)
{
	if(lvobEdit)
	{
		buttonDown = true;
	}
}

addEventHandler("onMouseClick", lvGuiHandler)


local function lvGuiHandler2(param)
{
	if(lvobEdit)
	{
		buttonDown = false;
	}
}

addEventHandler("onMouseRelease", lvGuiHandler2)
 
 
local function mainLoop()
{
	if(lvobEdit)
	{
		if(buttonDown)
		{
			local mouseVec = getCursorPosition()
			
			local buttonid = LvGui.checkCol(mouseVec.x, mouseVec.y)
			if(buttonid != null)
			LvGui.buttonPressed(buttonid)
			if(LvGui.changingVob)
			{
				local newVobId = LvGui.checkColRend(mouseVec.x, mouseVec.y)
				if(newVobId != null){
					local instance = Daedalus.instance(Items.name(newVobId))
					LvGui.draw[12].text = Items.name(newVobId)
					local newModel = instance.visual
					lagaVob[LvGui.id].setVisual(newModel)
				}
			}
			else if(LvGui.changingVobGive)
			{
				local newVobId = LvGui.checkColRend(mouseVec.x, mouseVec.y)
				if(newVobId != null){
					LvGui.draw[13].text = Items.name(newVobId)
					lagaVobGive = Items.name(newVobId)
				}
			}
		}
	}
}

addEventHandler("onRender", mainLoop)