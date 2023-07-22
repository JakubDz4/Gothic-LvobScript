local lagaVobMaxSize = 4//zapisac do bazy danych
local LagVobData = []//zapisac do bazy danych
local MinPermission = PlayerRole.GameMaster

class Lagvob
{
	draw = ""
	name = ""//visual
	give = ""
	x = 0.0
	y = 0.0
	z = 0.0
	oneLife = 0
	rx  =0.0
	ry  =0.0
	rz  =0.0
	staminaCost = 0
	
	respawnTime = 0
	respawnLeft = 0
	
	constructor(_name, _give, _x, _y, _z, oL, _draw, stamina) {
		name = _name
		give = _give
        x = _x;
        y = _y;
		z = _z
		oneLife = oL
		draw = _draw
		staminaCost = stamina
    }
	
	function checkRespawn()
	{
		if(respawnLeft == 0)
			return false
		respawnLeft -= 5
		if(respawnLeft<1)
		{
			respawnLeft = 0
			return true
		}
	}
	
	function setRespawn()
	{
		respawnLeft = respawnTime
	}
}

	setTimer(function() {// co 5 minut iteruje bo lvob i odejmuje im czas do respawnu. moze sie zdarzyc, ze item ustawiony na 5 min pojawi sie zaraz po zebraniu, ale jest to uczciwa cena za 1 timer 8-)
		local i = 0
		foreach(lvob in LagVobData)
		{
			if(lvob.checkRespawn())
			{
				showpacket <- Packet()
				showpacket.writeUInt8(LvobPacketId)
				showpacket.writeUInt8(LvobPacket.lvobshow) 
				showpacket.writeInt32(i)
				showpacket.sendToAll(RELIABLE)	
			}
			i++
		}	
    }, 5000, 0);//300000 - 5min


function onPacket(pid, packet) 
{
	local GetPacket = packet.readUInt8()
	if(GetPacket != LvobPacketId)
		return;
	local descr = packet.readUInt8()
	if(descr == LvobPacket.GiveItem)
	{
		local i = packet.readInt32()
		if(LagVobData[i].respawnLeft<1)
		{
			sendMessageToPlayer(pid, 255, 255, 0, "Podnosisz przedmiot") 
			giveItem(pid, Items.id(LagVobData[i].give), 1)
			packet.send(pid, RELIABLE)
		}
		
		if(LagVobData[i].oneLife==1)
		{
			LagVobData.remove(i);
			packet.reset()
			packet.writeUInt8(LvobPacketId)
			packet.writeUInt8(LvobPacket.lvobdelete) 
			packet.writeInt32(i)
			packet.sendToAll(RELIABLE)
		}
		else 
		{
			if(LagVobData[i].oneLife>0)
				LagVobData[i].oneLife--
			if(LagVobData[i].respawnTime>0)
			{
				LagVobData[i].setRespawn()
				hidepacket <- Packet()
				hidepacket.writeUInt8(LvobPacketId)
				hidepacket.writeUInt8(LvobPacket.lvobhide) 
				hidepacket.writeInt32(i)
				hidepacket.sendToAll(RELIABLE)	
			}
		}
		return
	}

	local player = getAdmin(pid)
	if(player.role >= MinPermission)
	{
		switch (descr)
		{
			case LvobPacket.spawnLagaVob:
			sendMessageToPlayer(pid, 255, 0, 0, "Dokonujesz edycji nowego Voba!")
				local name = packet.readString()
				local give = packet.readString()
				local draw = packet.readString()
				local x = packet.readFloat()
				local y = packet.readFloat()
				local z = packet.readFloat()
				local onelife = packet.readInt32()
				local staminaCst = packet.readInt32()
				
				LagVobData.append(Lagvob(name, give, x, y, z, onelife, draw, staminaCst))
				packet.sendToAll(RELIABLE)
				
				local id = LagVobData.len()-1
				newPacket <- Packet();
				newPacket.writeUInt8(LvobPacketId)
				newPacket.writeUInt8(LvobPacket.lvobedit)
				newPacket.writeUInt32(id)
				newPacket.writeUInt32(LagVobData[id].oneLife)
				newPacket.writeUInt32(LagVobData[id].staminaCost)
				newPacket.writeUInt32(LagVobData[id].respawnTime)
				newPacket.writeString(LagVobData[id].give)
				newPacket.writeString(LagVobData[id].draw)
				newPacket.send(pid, RELIABLE)
			break
			
			case LvobPacket.lvobedit:
				local id = packet.readUInt32();
				sendMessageToPlayer(pid, 255, 0, 0,"Modyfikujesz LagVoba o ID: " + id.tostring())
				packet.writeUInt32(LagVobData[id].oneLife)
				packet.writeUInt32(LagVobData[id].staminaCost)
				packet.writeUInt32(LagVobData[id].respawnTime)
				packet.writeString(LagVobData[id].give)
				packet.writeString(LagVobData[id].draw)
				packet.send(pid, RELIABLE)
			break
			
			case LvobPacket.spawnLagaVobNot:
				sendMessageToPlayer(pid, 255, 0, 0, packet.readString())
			break
			
			case LvobPacket.changelvobname:
				local newName = packet.readString()
				sendMessageToPlayer(pid, 255, 0, 0, "Zmiana modelu lagvoba na: " + newName) 
				packet.send(pid, RELIABLE)
			break
			
			case LvobPacket.changelvobgive:
				local newGive = packet.readString()
				sendMessageToPlayer(pid, 255, 0, 0, "Zmiana otrzymywanego przedmiotu na: " + newGive) 
				packet.send(pid, RELIABLE)
			break
			
			case LvobPacket.changelvobdraw:
				local newDraw = packet.readString()
				sendMessageToPlayer(pid, 255, 0, 0, "Zmiana drawu nad przedmiotem na: " + newDraw) 
				packet.send(pid, RELIABLE)
			break
			
			case LvobPacket.changelvobonelife:
				local oneLife = packet.readInt32()
				sendMessageToPlayer(pid, 255, 0, 0, "Czy Vob ma tylko jedno zycie ustawione na: " + oneLife) 
				packet.send(pid, RELIABLE)
			break
			
			case LvobPacket.changelvobstamina:
				local newStamina = packet.readInt32()
				sendMessageToPlayer(pid, 255, 0, 0, "Koszt staminy ustawiony na: " + newStamina) 
				packet.send(pid, RELIABLE)
			break
			
			case LvobPacket.LagaVobInit:
				packet.writeUInt32(lagaVobMaxSize)
				packet.writeUInt32(LagVobData.len())
				if(LagVobData.len() != 0)
				{
					for (local i=0;i<LagVobData.len();i++)
					{
						packet.writeString(LagVobData[i].name);
						packet.writeString(LagVobData[i].give);
						packet.writeString(LagVobData[i].draw);
						packet.writeFloat(LagVobData[i].x);
						packet.writeFloat(LagVobData[i].y);
						packet.writeFloat(LagVobData[i].z);
						
						packet.writeFloat(LagVobData[i].rx);
						packet.writeFloat(LagVobData[i].ry);
						packet.writeFloat(LagVobData[i].rz);
						
						packet.writeUInt32(LagVobData[i].respawnLeft)
						packet.writeInt32(LagVobData[i].staminaCost)
					}
				}
				packet.send(pid, RELIABLE)
			break
			
			case LvobPacket.setlagvobmaxsize:
				lagaVobMaxSize = packet.readInt32();
				sendMessageToPlayer(pid, 255, 0, 0,"Zmieniam maksymalna ilosc LagVob na: " + lagaVobMaxSize.tostring())
				if(LagVobData.len()>lagaVobMaxSize)
				{
					local leng = LagVobData.len() - lagaVobMaxSize;
					
					for(local i=0; i<leng; i++)
					{
						LagVobData.remove(0);
					}
				}
				packet.sendToAll(RELIABLE)
			break
			
			case LvobPacket.lvobdelete:
				local id = packet.readInt32();
				sendMessageToPlayer(pid, 255, 0, 0,"Usuwam wybrany LagVob nr: " + id.tostring())
				LagVobData.remove(id);

				packet.sendToAll(RELIABLE)
			break
			
			case LvobPacket.lvobtoggle:
				local toggle = packet.readBool()
				sendMessageToPlayer(pid, 255, 0, 0, "Zmieniono pokazywanie id LagVob na: " + toggle.tostring()) 
				packet.send(pid, RELIABLE)
			break

			case LvobPacket.UpdatelvPacket:
				sendMessageToPlayer(pid, 255, 0, 0,"Zapisano zmiany Voba.")
				local id = packet.readInt32()
				
				LagVobData[id].x = packet.readFloat()
				LagVobData[id].y = packet.readFloat()
				LagVobData[id].z = packet.readFloat()
				LagVobData[id].rx = packet.readFloat()
				LagVobData[id].ry = packet.readFloat()
				LagVobData[id].rz = packet.readFloat()
				LagVobData[id].name = packet.readString()
				LagVobData[id].draw = packet.readString()
				LagVobData[id].give = packet.readString()
				LagVobData[id].oneLife = packet.readUInt32()
				LagVobData[id].respawnTime = packet.readUInt32()
				LagVobData[id].staminaCost = packet.readUInt32()
				
				packet.sendToAll(RELIABLE)
			break
			
			case LvobPacket.lvobfind:
				sendMessageToPlayer(pid, 255, 0, 0, "Wyszukam item po wyrazie: " + packet.readString())
				packet.send(pid, RELIABLE)
			break
		}
	}
}



addEventHandler("onPacket",onPacket);