luk <- 0.0;

local function keyHandler(key)
{
    switch(key)
    {
        case KEY_Z:
			luk-=500.0;
			
			myPacket <- Packet();
			myPacket.writeInt32(1)
			myPacket.writeFloat(luk)
			myPacket.send(RELIABLE);
        break
		
		case KEY_X:
			luk+=500.0;
			
			myPacket <- Packet();
			myPacket.writeInt32(2)
			myPacket.writeFloat(luk)
			myPacket.send(RELIABLE);
        break
		
		case KEY_H:
		/*	myPacket <- Packet();
			myPacket.writeInt32(3)
			myPacket.writeString("Uleczony")
			myPacket.send(RELIABLE);
			setPlayerMaxHealth(1, 1000)
			setPlayerHealth(1, 1000)
			setPlayerMaxHealth(0, 1000)
			setPlayerHealth(0, 1000)*/
        break
    }
}

addEventHandler("onKey", keyHandler)

local function init_handler() {

	local id = createNpc("szkielet")
    spawnNpc(id, "SKELETON")
	setPlayerPosition(id, 0, 1, 1);	

	myPacket <- Packet();
	myPacket.writeInt32(0)
	myPacket.send(RELIABLE);

}

addEventHandler("onInit", init_handler)

function onPacket(packet) 
{
	local id = packet.readInt32()
	switch(id)
	{
		case 0:
		
		myPacket <- Packet();
			myPacket.writeInt32(2)
			myPacket.writeFloat(luk)
			myPacket.send(RELIABLE);
		
		local x = packet.readFloat()
		luk = x
		Daedalus.symbol("RANGED_CHANCE_MINDIST").setValue(luk);
		Daedalus.symbol("RANGED_CHANCE_MAXDIST").setValue(luk);
		break
	}	
}

addEventHandler("onPacket",onPacket);