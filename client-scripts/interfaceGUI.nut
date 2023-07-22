class LvobGui
{
	//8200 - max 8000 - na styk
	paragraph = 500;
	space = 450;
	id = 0

	draw = []
	texture = []
	render = []
	backgroundtex = []
	
	oldPos = lvec3(0,0,0)
	oldRot = lvec3(0,0,0)
	oldVisual = ""

	changingVob = false
	changingVobGive = false
	changingVobPage = 0
	VobIndexes = []
	typedText = null
	
	UpdatelvPacket = Packet();
	
	function initVisuals(_id)
	{
		id = _id
		draw.resize(25)
		texture.resize(29)
		
		local t = 4000 + 2*paragraph
		draw[0] = Draw(t, paragraph, "LagVob Position:")
		draw[1] = Draw(t, (paragraph + space), "Position X")
		draw[2] = Draw(t, (paragraph + 3*space), "Position Y")
		draw[3] = Draw(t, (paragraph + 5*space), "Position Z")
		
		local x = 8200 - paragraph - draw[0].width
		draw[4] = Draw(x, paragraph, "LagVob Rotation:")
		draw[5] = Draw(x, (paragraph + space), "Rotation X")
		draw[6] = Draw(x, (paragraph + 3*space), "Rotation Y")
		draw[7] = Draw(x, (paragraph + 5*space), "Rotation Z")
		
		for(local i=0; i<3; i++)
		{
			texture[i] = Texture(t, (paragraph + space*(i+1)*2), 200, 300, "LVOBLEFT.TGA")
			texture[i+3] = Texture(t + 300, (paragraph + space*(i+1)*2), 200, 300, "LVOBRIGHT.TGA")
			draw[i+14] = Draw(t + 600, (paragraph + space*(i+1)*2), "")
		}
		for(local i=0; i<3; i++)
		{
			texture[i+6] = Texture(x, (paragraph + space*(i+1)*2), 200, 300, "LVOBLEFT.TGA")
			texture[i+9] = Texture(x + 300, (paragraph + space*(i+1)*2), 200, 300, "LVOBRIGHT.TGA")
			draw[i+17] = Draw(x + 600, (paragraph + space*(i+1)*2), "")
		}
		local pos = lagaVob[id].getPosition()
		local rot = lagaVob[id].getRotation()
		draw[14].text = pos.x.tostring()
		draw[15].text = pos.y.tostring()
		draw[16].text = pos.z.tostring()
		draw[17].text = rot.x.tostring()
		draw[18].text = rot.y.tostring()
		draw[19].text = rot.z.tostring()
		
		
		local end = 8200-paragraph
		//zapisz i wyjdz
		texture[GuiOptions.saveExit] = Texture(end - space, end - paragraph, 300, 500, "LVOBYES.TGA")
		//wyjdz
		texture[GuiOptions.exit] = Texture(end, end - paragraph, 300, 500, "LVOBNO.TGA")
		//usun
		texture[GuiOptions.deleteExit] = Texture(end - 2*space, end - paragraph, 300, 500, "LVOBDEAD.TGA")
		
		//czyInnyVob
		draw[8] = Draw(t, (paragraph + 8*space), "Wybierz innego Voba:")
		texture[GuiOptions.openVobs] = Texture(x, (paragraph + 8*space), 600, 300, "LVOBSHOW.TGA")
		texture[GuiOptions.leftVob] = Texture(t, (paragraph + 9*space), 200, 300, "LVOBLEFT.TGA")
		texture[GuiOptions.rightVob] = Texture(t+300, (paragraph + 9*space), 200, 300, "LVOBRIGHT.TGA")
		draw[12] = Draw(t+600, (paragraph + 9*space), lagaVobName.tostring())
		
		//czyInnyGiveVob
		draw[9] = Draw(t, (paragraph + 10*space), "Jaki item dostajesz:")
		texture[GuiOptions.openVobsGive] = Texture(x, (paragraph + 10*space), 600, 300, "LVOBSHOW.TGA")
		texture[GuiOptions.leftGive] = Texture(t, (paragraph + 11*space), 200, 300, "LVOBLEFT.TGA")
		texture[GuiOptions.rightGive] = Texture(t+300, (paragraph + 11*space), 200, 300, "LVOBRIGHT.TGA")
		draw[13] = Draw(t+600, (paragraph + 11*space), lagaVobGive.tostring())
		
		//backgroundtex
		local tmp = texture[13].getSize()
		backgroundtex.append(Texture(t, paragraph, end+tmp.width-t, end - paragraph, "BLACK.TGA"))
		backgroundtex[0].visible = true
		backgroundtex[0].setAlpha(150)
		
		//lagavoblife
		draw[10] = Draw(t, (paragraph + 12*space), "Ile jeszcze itemow:")
		if(lagavobonelife) draw[11] = Draw(x, (paragraph + 12*space), lagavobonelife.tostring())
		else draw[11] = Draw(x, (paragraph + 12*space), "nieskonczonosc")
		texture[GuiOptions.lifeFastDec] = Texture(t, (paragraph + 13*space), 200, 300, "LVOBLEFT.TGA")
			texture[GuiOptions.lifeFastDec].setColor(255,215,80)
		texture[GuiOptions.lifeDec] = Texture(t+300, (paragraph + 13*space), 200, 300, "LVOBLEFT.TGA")
		texture[GuiOptions.lifeInc] = Texture(t+600, (paragraph + 13*space), 200, 300, "LVOBRIGHT.TGA")
		texture[GuiOptions.lifeFastInc] = Texture(t+900, (paragraph + 13*space), 200, 300, "LVOBRIGHT.TGA")
			texture[GuiOptions.lifeFastInc].setColor(255,215,80)
			
		//respawn
		draw[20] = Draw(t, (paragraph + 14*space), "Czas respawnu (minuty):")
		draw[21] = Draw(x, (paragraph + 14*space), lagavobrespawn.tostring())
		texture[GuiOptions.respawnFastDec] = Texture(t, (paragraph + 15*space), 200, 300, "LVOBLEFT.TGA")
			texture[GuiOptions.respawnFastDec].setColor(255,215,80)
		texture[GuiOptions.respawnDec] = Texture(t+300, (paragraph + 15*space), 200, 300, "LVOBLEFT.TGA")
		texture[GuiOptions.respawnInc] = Texture(t+600, (paragraph + 15*space), 200, 300, "LVOBRIGHT.TGA")
		texture[GuiOptions.respawnFastInc] = Texture(t+900, (paragraph + 15*space), 200, 300, "LVOBRIGHT.TGA")
			texture[GuiOptions.respawnFastInc].setColor(255,215,80)
		
		//typedText
		draw[22] = Draw(t, (paragraph + 7*space), "Szukaj po wyrazie:")
		if(typedText!=null)
			draw[23] = Draw(x, (paragraph + 7*space), typedText.tostring())
		else
			draw[23] = Draw(x, (paragraph + 7*space), "NULL")
			
		// nazwa drawu nad przedmiotem
		draw[24] = Draw(x, (paragraph + 13*space), lagavobdraw + "\n" + " (koszt:" + LvobStaminaCost.tostring() + ")")
		draw[24].setColor(255,80,80)
		
			
		foreach(d in draw)
		{
			d.visible = true
		}
		
		foreach(t in texture)
		{
			t.visible = true
		}
	}
	
	function changeDraw()
	{
		draw[24].text = lagavobdraw + "\n" + " (koszt:" + LvobStaminaCost.tostring() + ")"
	}
	
	function changeGive()
	{
		draw[13].text = lagaVobGive
	}
	
	function changeName()
	{
		draw[12].text = lagaVobName
		lagaVob[id].setVisual(lagaVobName)
	}
	
	function changeStamina()
	{
		draw[24].text = lagavobdraw + "\n" + " (koszt:" + LvobStaminaCost.tostring() + ")"
	}
	
	function changeTypedText(x)
	{
		changingVobPage=0
		VobIndexes.clear()
		typedText = x
		draw[23].text = x
	}
	
	function updateRender()
	{	
		render.clear()
		generateRender()
	}
	
	function exitGui()
	{
		setCursorVisible(false)
		Camera.setTargetPlayer(heroId);
	//	Camera.movementEnabled = true
		disableControls(false)
		lvobEdit = false
		render.clear()
		texture.clear()
		draw.clear()
		backgroundtex.clear()
		changingVob = false;
		changingVobGive = false
	}
	
	function generateRender()
	{
		local run = true
		local numInRow = 6
		local maxX = 4000 + paragraph
		local size = maxX/numInRow
		local numInCol = -1 + (8000-paragraph)/size
		local model
		local i = 0
		local j = 0
		local k = 0;
		if(VobIndexes.len()<1)
			VobIndexes.append(0)
		local ChangingVobIndex = VobIndexes[changingVobPage]
		
		while(run)
		{
			model = Items.name(ChangingVobIndex + render.len() + k)
			if(typedText!=null && model.find(typedText) == null)
			{
				k++
				if(model==null)
					run = false
			}
			else
			{
				if(model == "ITLSTORCHBURNING" || model == "ITLSTORCHFIRESPIT")
				{
					model = "ITLSTORCH";
				}
				if(model!=null)
				{
					local rendTex = ItemRender(i*size, j*size + paragraph, size, size, model)
					rendTex.visible = true
					local rend = [ChangingVobIndex+i+j*numInRow+k, rendTex]
					render.append(rend)
					i++
					if(i>=numInRow)
					{
						i=0
						j++
					}
					if(j>numInCol)
					run = false
				}
				else run = false;
			}
		}
		
		if(changingVobPage > VobIndexes.len()-2)
		VobIndexes.append(render[render.len()-numInRow][0])
		
	}
	
	function checkCol(cx, cy)
	{
		local i=0
		local vec
		local s
		foreach(t in texture)
		{
			vec = t.getPosition()
			s = t.getSize()
			if(vec.x<=cx && vec.x + s.width >= cx)
			{
				if(vec.y<=cy && vec.y + s.height >= cy)
				{
					return i;
				}
			}
			i++
		}
		return null
	}
	
	function checkColRend(cx, cy)
	{
		buttonDown = false;
		local vec
		local s
		foreach(t in render)
		{
			vec = t[1].getPosition()
			s = t[1].getSize()
			if(vec.x<=cx && vec.x + s.width >= cx)
			{
				if(vec.y<=cy && vec.y + s.height >= cy)
				{
					return t[0];
				}
			}
		}
		return null
	}
	
	function buttonPressed(buttonid)
	{
		switch(buttonid)
		{
			case GuiOptions.leftpx:
				local vec = lagaVob[id].getPosition()
				vec.x = vec.x - 1
				lagaVob[id].setPosition(vec.x, vec.y, vec.z)
				draw[14].text = vec.x.tostring()
			break
			
			case GuiOptions.leftpy:
				local vec = lagaVob[id].getPosition()
				vec.y = vec.y - 1
				lagaVob[id].setPosition(vec.x, vec.y, vec.z)
				draw[15].text = vec.y.tostring()
			break
			
			case GuiOptions.leftpz:
				local vec = lagaVob[id].getPosition()
				vec.z = vec.z - 1
				lagaVob[id].setPosition(vec.x, vec.y, vec.z)
				draw[16].text = vec.z.tostring()
			break
			
			case GuiOptions.rightpx:
				local vec = lagaVob[id].getPosition()
				vec.x = vec.x + 1
				lagaVob[id].setPosition(vec.x, vec.y, vec.z)
				draw[14].text = vec.x.tostring()
			break
			
			case GuiOptions.rightpy:
				local vec = lagaVob[id].getPosition()
				vec.y = vec.y + 1
				lagaVob[id].setPosition(vec.x, vec.y, vec.z)
				draw[15].text = vec.y.tostring()
			break
			
			case GuiOptions.rightpz:
				local vec = lagaVob[id].getPosition()
				vec.z = vec.z + 1
				lagaVob[id].setPosition(vec.x, vec.y, vec.z)
				draw[16].text = vec.z.tostring()
			break
			///--------------------------------roation
			case GuiOptions.leftrx:
				local vec = lagaVob[id].getRotation()
				vec.x = vec.x - 0.5
				lagaVob[id].setRotation(vec.x, vec.y, vec.z)
				draw[17].text = vec.x.tostring()
			break
			
			case GuiOptions.leftry:
				local vec = lagaVob[id].getRotation()
				vec.y = vec.y - 0.5
				lagaVob[id].setRotation(vec.x, vec.y, vec.z)
				draw[18].text = vec.y.tostring()
			break
			
			case GuiOptions.leftrz:
				local vec = lagaVob[id].getRotation()
				vec.z = vec.z - 0.5
				lagaVob[id].setRotation(vec.x, vec.y, vec.z)
				draw[19].text = vec.z.tostring()
			break
			
			case GuiOptions.rightrx:
				local vec = lagaVob[id].getRotation()
				vec.x = vec.x + 0.5
				lagaVob[id].setRotation(vec.x, vec.y, vec.z)
				draw[17].text = vec.x.tostring()
			break
			
			case GuiOptions.rightry:
				local vec = lagaVob[id].getRotation()
				vec.y = vec.y + 0.5
				lagaVob[id].setRotation(vec.x, vec.y, vec.z)
				draw[18].text = vec.y.tostring()
			break
			
			case GuiOptions.rightrz:
				local vec = lagaVob[id].getRotation()
				vec.z = vec.z + 0.5
				lagaVob[id].setRotation(vec.x, vec.y, vec.z)
				draw[19].text = vec.z.tostring()
			break
			
			
			case GuiOptions.saveExit:
				local vecpos = lagaVob[id].getPosition()
				local vecrot = lagaVob[id].getRotation()
				
				UpdatelvPacket.reset()
				UpdatelvPacket.writeUInt8(LvobPacketId)
				UpdatelvPacket.writeUInt8(LvobPacket.UpdatelvPacket)
				UpdatelvPacket.writeInt32(id)
				UpdatelvPacket.writeFloat(vecpos.x)
				UpdatelvPacket.writeFloat(vecpos.y)
				UpdatelvPacket.writeFloat(vecpos.z)
				UpdatelvPacket.writeFloat(vecrot.x)
				UpdatelvPacket.writeFloat(vecrot.y)
				UpdatelvPacket.writeFloat(vecrot.z)
				UpdatelvPacket.writeString(lagaVob[id].getVisual())
				UpdatelvPacket.writeString(lagavobdraw)
				UpdatelvPacket.writeString(lagaVobGive)
				UpdatelvPacket.writeUInt32(lagavobonelife)
				UpdatelvPacket.writeUInt32(lagavobrespawn)
				UpdatelvPacket.writeUInt32(LvobStaminaCost)
				UpdatelvPacket.send(RELIABLE);
				
				exitGui()
				buttonDown = false;
			break
			
			case GuiOptions.exit:
				lagaVob[id].setPosition(oldPos.x, oldPos.y, oldPos.z)
				lagaVob[id].setRotation(oldRot.x, oldRot.y, oldRot.z)
				lagaVob[id].setVisual(oldVisual)
				
				exitGui()
				buttonDown = false;
			break
			
			case GuiOptions.deleteExit:
				UpdatelvPacket.reset()
				UpdatelvPacket.writeUInt8(LvobPacketId)
				UpdatelvPacket.writeUInt8(LvobPacket.lvobdelete)
				UpdatelvPacket.writeInt32(id)
				UpdatelvPacket.send(RELIABLE);
				
				exitGui()
				buttonDown = false;
			break
			
			case GuiOptions.openVobs:
				if(!changingVobGive)
				{
					buttonDown = false;
					changingVob = !changingVob
					if(changingVob)
					{
						texture[buttonid].setColor(80, 255, 80)
						backgroundtex.append(Texture(0, paragraph, 4000+paragraph, 8200 - paragraph-paragraph/2, "BLACK.TGA"))
						backgroundtex[1].visible = true
						backgroundtex[1].setAlpha(150)
						generateRender()
					}
					else 
					{
						texture[buttonid].setColor(255, 255, 255)
						backgroundtex.remove(1)
						render.clear()
					}
				}
			break
			
			case GuiOptions.leftVob:
				buttonDown = false;
				if(changingVob)
				{
					changingVobPage-=1
					if(changingVobPage<0)
					changingVobPage=0
					
					updateRender()
				}
			break
			
			case GuiOptions.rightVob:
				buttonDown = false;
				if(changingVob)
				{
					changingVobPage++
					if(changingVobPage<0)
					changingVobPage=0
					
					updateRender()
				}
			break
			
			case GuiOptions.openVobsGive:
				if(!changingVob)
				{
					buttonDown = false;
					changingVobGive = !changingVobGive
					if(changingVobGive)
					{
						texture[buttonid].setColor(80, 255, 80)
						backgroundtex.append(Texture(0, paragraph, 4000+paragraph, 8200 - paragraph-paragraph/2, "BLACK.TGA"))
						backgroundtex[1].visible = true
						backgroundtex[1].setAlpha(150)
						generateRender()
					}
					else 
					{
						texture[buttonid].setColor(255, 255, 255)
						backgroundtex.remove(1)
						render.clear()
					}
				}
			break
			
			case GuiOptions.leftGive:
				buttonDown = false;
				if(changingVobGive)
				{
					changingVobPage-=1
					if(changingVobPage<0)
					changingVobPage=0
					
					updateRender()
				}
			break
			
			case GuiOptions.rightGive:
				buttonDown = false;
				if(changingVobGive)
				{
					changingVobPage++
					if(changingVobPage<0)
					changingVobPage=0
					
					updateRender()
				}
			break
			
			case GuiOptions.lifeFastDec:
				lagavobonelife--
				if(lagavobonelife<1)
				lagavobonelife = 0
				if(lagavobonelife)
				draw[11].text = lagavobonelife.tostring()
				else draw[11].text = "nieskonczonosc"
			break
			
			case GuiOptions.lifeDec:
				buttonDown = false;
				lagavobonelife--
				if(lagavobonelife<1)
				lagavobonelife = 0
				if(lagavobonelife)
				draw[11].text = lagavobonelife.tostring()
				else draw[11].text = "nieskonczonosc"
			break
			
			case GuiOptions.lifeInc:
				buttonDown = false;
				lagavobonelife++
				if(lagavobonelife>9999)
				lagavobonelife = 0
				if(lagavobonelife)
				draw[11].text = lagavobonelife.tostring()
				else draw[11].text = "nieskonczonosc"
			break
			
			case GuiOptions.lifeFastInc:
				lagavobonelife++
				if(lagavobonelife>9999)
				lagavobonelife = 0
				if(lagavobonelife)
				draw[11].text = lagavobonelife.tostring()
				else draw[11].text = "nieskonczonosc"
			break
			
			case GuiOptions.respawnFastInc:
				lagavobrespawn+=5
				if(lagavobrespawn>9999)
				lagavobrespawn = 0
				draw[21].text = lagavobrespawn.tostring()
			break
			
			case GuiOptions.respawnInc:
				buttonDown = false;
				lagavobrespawn+=5
				if(lagavobrespawn>9999)
				lagavobrespawn = 0
				draw[21].text = lagavobrespawn.tostring()
			break
			
			case GuiOptions.respawnDec:
				buttonDown = false;
				lagavobrespawn-=5
				if(lagavobrespawn<1)
				lagavobrespawn=0
				draw[21].text = lagavobrespawn.tostring()
			break
			
			case GuiOptions.respawnFastDec:
				lagavobrespawn-=5
				if(lagavobrespawn<1)
				lagavobrespawn=0
				draw[21].text = lagavobrespawn.tostring()
			break
		}
	}
}