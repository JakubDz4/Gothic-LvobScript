bow <- 0.0

function onPacket(pid, packet) 
{
	local id = packet.readInt32()
	
	switch(id)
	{
		case 0:
		
		sendMessageToPlayer(pid, 255, 0, 0, "obecnie bow: " + bow.tostring())
		
			myPacket <- Packet();
			myPacket.writeInt32(0)
			myPacket.writeFloat(bow)
			myPacket.send(pid, RELIABLE);
		break
		
		case 1:
		case 2:
		
		local x = packet.readFloat()
		bow = x
		sendMessageToPlayer(pid, 255, 0, 0, "Zmieniles wartosc lukow na: " + bow.tostring())
		break
	}
	
	
			
}



addEventHandler("onPacket",onPacket);