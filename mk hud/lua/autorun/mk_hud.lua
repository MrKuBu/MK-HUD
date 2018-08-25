--CODED BY MRKUBU
--CODED BY MRKUBU
--CODED BY MRKUBU

-- Конфиг/Config/Config
-- Перевод худа/Translate this hud/Traduisez ce hud(France language by Google translate :D)!!!
local name 		= "Имя" 		-- RU:Имя/EN:Name/FR:Nom
local job 		= "Работа" 		-- RU:Работа/EN:Job/FR:Travail
local money 	= "Деньги" 		-- RU:Деньги/EN:Money/FR:Argent
local health 	= "Здоровье" 	-- RU:Здоровье/EN:Health/FR:Santé
local armor		= "Броня" 		-- RU:Броня/EN:Armor/FR:Armure
local license 	= "Лицензия" 	-- RU:Лицензия/EN:License/FR:Licence
local wanted 	= "Розыск"		-- RU:Розыск/EN:Wanted/FR:Recherche
local lockdown 	= "Ком.час" 	-- RU:Комендантский час/EN: Short LockDown/FR:Couvre-feu
-- Перевод худа/Translate this hud/Traduisez ce hud!!!
--
-- Цвета худа/Color hud/Couleur hud!!!
local bgline 	= Color( 30, 30, 100, 255 ) -- RU:Линии(цвет синий)/EN:Background color (def blue)
local circlebg 	= Color( 0, 110, 0, 255 )	-- RU:Обводка кружка(цвет зелёный)/EN:Circle color (def green)
local circle 	= Color( 0, 0, 0, 255)		-- RU:Куржок(цвет чёрный)/EN:Circle color (def black)
local gradientbg= Color( 0, 0, 0, 255) 		-- RU:Цвет градиента(цвет чёрный)/EN:Gradient color (def black)
local textcolor	= Color( 255, 255, 255, 255)-- RU:Цвет текста(цвет белый)/EN:Text color color (def White)
-- Цвета худа/Color hud/Couleur hud!!!

-- Модули худа/Modules hud/Modules hud!!!!
local Hungermod = false	-- RU:Полоска голода/EN:Hunger bar/FR:Le régime de la faim
-- Модули худа/Modules hud/Modules hud!!!!
-- Конфиг/Config/Config

DarkRPVars = DarkRPVars or {}

if CLIENT then
surface.CreateFont( "ImpactMKHUD", {
    font = "Impact",
    extended = true,
    size = 20,
    weight = 300,
    blursize = 0,
    scanlines = 0,
    antialias = true,
})
end

local LicenseIcon = Material( "mk_hud/gun.png" )
local WantedIcon = Material( "mk_hud/wanted.png" )
local ErrorIcon = Material("mk_hud/error.png")

local function getClip()
    if LocalPlayer():GetActiveWeapon():IsValid() and LocalPlayer():GetActiveWeapon():Clip1() then
        return LocalPlayer():GetActiveWeapon():Clip1()
    else
        return 0
    end
end
local function getFullAmmo()
    local wep = LocalPlayer():GetActiveWeapon()
    if LocalPlayer():GetActiveWeapon():IsValid() and LocalPlayer():GetAmmoCount( wep:GetPrimaryAmmoType() ) then
        return LocalPlayer():GetAmmoCount( wep:GetPrimaryAmmoType() )
    else
        return 0
    end
end

if CLIENT then
	function draw.Circle( x, y, radius, seg )
		local cir = {}

		table.insert( cir, { x = x, y = y, u = 0.5, v = 0.5 } )
		for i = 0, seg do
			local a = math.rad( ( i / seg ) * -360 )
			table.insert( cir, { x = x + math.sin( a ) * radius, y = y + math.cos( a ) * radius, u = math.sin( a ) / 2 + 0.5, v = math.cos( a ) / 2 + 0.5 } )
		end

		local a = math.rad( 0 )
		table.insert( cir, { x = x + math.sin( a ) * radius, y = y + math.cos( a ) * radius, u = math.sin( a ) / 2 + 0.5, v = math.cos( a ) / 2 + 0.5 } )

		surface.DrawPoly( cir )
	end
end

local MKHealth = 0
local MKArmor = 0
local MKEnergy = 0

function MKHUD()
	local ply = LocalPlayer()
	local wep = ply:GetActiveWeapon()
	local trace = ply:GetEyeTrace()	
	local sin = math.sin(CurTime()*1)
	local FT = FrameTime()
	MKHealth = Lerp(10 * FrameTime(), MKHealth, ply:Health())
	MKArmor = Lerp(10 * FrameTime(), MKArmor, ply:Armor())
	MKEnergy = Lerp(10 * FrameTime(), MKEnergy, ply:getDarkRPVar("Energy"))
	
	if ply:Alive() then
		surface.SetDrawColor(gradientbg)
		surface.SetTexture(surface.GetTextureID("gui/gradient"))
		surface.DrawTexturedRect(57, ScrH() - 124, 400, 119)
		
		surface.DrawTexturedRect(57, ScrH() - 124, 350, 119)
		
		surface.SetDrawColor(circlebg)
		draw.NoTexture()
		draw.Circle( 64, ScrH() - 64, 60,  70 )

		surface.SetDrawColor(circle)
		draw.NoTexture()
		draw.Circle( 64, ScrH() - 64, 55,  70 )
		
		
		if portrait == nil then
			portrait = vgui.Create( "DModelPanel" )
		else
			portrait:SetPos( 28, ScrH()-105 )
			portrait:SetSize( 75, 75 )
			portrait:SetModel( LocalPlayer():GetModel() )
			portrait.Think = function()
				if not LocalPlayer():Alive() then
					portrait:SetSize( 0, 0 )
				else
					portrait:SetSize( 85, 85 )
				end
				portrait:SetModel( LocalPlayer():GetModel() )
			end
			portrait.LayoutEntity = function()
				return false
			end
			portrait:SetFOV( 40 )
			portrait:SetCamPos( Vector( 25, 0, 62 ) )
			portrait:SetLookAt( Vector( 0, 0, 62 ) )
			portrait.Entity:SetEyeTarget( Vector( 50, 50, 40 ) )
		end
		
		draw.RoundedBox( 10, 120, ScrH() - 120, 300, 20, bgline )
		draw.RoundedBox( 10, 133, ScrH() - 90, 300, 20, bgline )
		
		draw.SimpleText( name..": "..LocalPlayer():Nick()..", ".. job..": " ..LocalPlayer():getDarkRPVar('job'), "ImpactMKHUD", 128, ScrH() - 120, textcolor )
		draw.SimpleText( money..": "..LocalPlayer():getDarkRPVar('money').." (+"..LocalPlayer():getDarkRPVar('salary')..")", "ImpactMKHUD", 143, ScrH() - 91, textcolor )
		
		if ply:IsSpeaking() then
			draw.SimpleText( "☄", "ImpactMKHUD", 80, ScrH() - 90, textcolor )
		end
		
		if ply:IsTyping() then
			draw.SimpleText( "✍", "ImpactMKHUD", 30, ScrH() - 86, textcolor )
		end
		
		if ply:FlashlightIsOn() then
			draw.SimpleText( "☀", "ImpactMKHUD", 56, ScrH() - 30, textcolor )
		end
		
		local health_mul = math.Clamp( ply:Health() / ply:GetMaxHealth(), 0, 1 )
		local red_mod = 255*health_mul
		
		if ply:Health() != 0 then
			if ply:Health() <= 100 then
				draw.RoundedBox( 9.4, 133, ScrH() - 60, 300 * (MKHealth / 100), 19, Color(255-red_mod, 255*health_mul, 0, 255) ) 
				draw.RoundedBox( 9.4, 133, ScrH() - 60, 300, 19, Color(255-red_mod, 255*health_mul, 0, 130) )
				draw.SimpleText( health, "ImpactMKHUD", 240, ScrH() - 62, textcolor)
			else
				draw.RoundedBox( 9.4, 133, ScrH() - 60, 300, 19, Color(255-red_mod, 255*health_mul, 0, 255) ) 
				draw.RoundedBox( 9.4, 133, ScrH() - 60, 300, 19, Color(255-red_mod, 255*health_mul, 0, 130) )
				draw.SimpleText( health, "ImpactMKHUD", 240, ScrH() - 62, textcolor)
			end
		end

		if ply:Armor() != 0 then
			if ply:Armor() <= 100 then
				draw.RoundedBox( 10, 120, ScrH() - 30, 300 * (MKArmor / 100), 20, Color(0, 170, 255, 255) )
				draw.RoundedBox( 10, 120, ScrH() - 30, 300, 20, Color(0, 170, 255, 100) ) 
				draw.SimpleText( armor, "ImpactMKHUD", 240, ScrH() - 32, textcolor)
			else
				draw.RoundedBox( 10, 120, ScrH() - 30, 300, 20, Color(0, 170, 255, 255) )
				draw.RoundedBox( 10, 120, ScrH() - 30, 300, 20, Color(0, 170, 255, 100) )
				draw.SimpleText( armor, "ImpactMKHUD", 240, ScrH() - 32, textcolor)
			end
		end
		
		if Hungermod then
			local energy = math.ceil(LocalPlayer():getDarkRPVar("Energy") or 0)
			if energy <= 100 then
				draw.RoundedBox( 0, 76,ScrH() - 6, 355* (MKEnergy / 100), 1, Color(255, 255, 0, 255) )
			else
				draw.RoundedBox( 0, 76,ScrH() - 6, 355, 1, Color(255, 255, 0, 255) )
			end
		end
		
		if LocalPlayer():getDarkRPVar("HasGunlicense") then
			draw.RoundedBox( 10, 500, ScrH() - 50, 120, 40, bgline )
			surface.SetDrawColor( Color(255,255,255,255) )
			surface.SetMaterial( LicenseIcon )	
			surface.DrawTexturedRectRotated( 520, ScrH() - 30,  40 , 40 , 0 )
			draw.SimpleText( license, "ImpactMKHUD", 545, ScrH() - 30, textcolor,  TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
		end
		
		if LocalPlayer():isWanted() then
			draw.RoundedBox( 10, 650, ScrH() - 50, 110, 40, bgline )
			surface.SetDrawColor( Color(255,255,255,255) )
			surface.SetMaterial( WantedIcon )	
			surface.DrawTexturedRectRotated( 670, ScrH() - 30,  40 , 40 , 0 )
			draw.SimpleText( wanted, "ImpactMKHUD", 695, ScrH() - 30, textcolor,  TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
		end
		
		local agendaText
		local function DrawAgenda()
		local agenda = LocalPlayer():getAgendaTable()
			if not agenda then return end
			agendaText = agendaText or DarkRP.textWrap( ( LocalPlayer():getDarkRPVar( "agenda" ) or "" ):gsub( "//", "\n" ):gsub( "\\n", "\n" ), "ImpactMKHUD", 440 )
			draw.RoundedBox( 1, 10, 10, 400, 30, bgline )
			draw.RoundedBox( 1, 10, 38, 400, 2, Color( 0, 0, 0, 255 ) )
			draw.RoundedBox( 1, 10, 38, 400, 112, Color( 30, 30, 100, 150 ) )
			draw.SimpleText( agenda.Title, "ImpactMKHUD", 10+20/2, 12, textcolor)
			draw.SimpleText( agendaText, "ImpactMKHUD", 20, 49, textcolor )
		end
		hook.Add( "HUDPaint", "DrawAgenda", DrawAgenda ) 

		if GetGlobalBool("DarkRP_LockDown") then
			draw.RoundedBox( 10, 30, ScrH() - 180, 120, 40, bgline )
			surface.SetDrawColor( Color(255,255,255,255) )
			surface.SetMaterial( ErrorIcon )	
			surface.DrawTexturedRect( 30, ScrH() - 180,  40 , 40 , 0 )
			draw.SimpleText( lockdown, "ImpactMKHUD", 75, ScrH() - 160, textcolor,  TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
		end
		
		if ply:GetNWInt("MKHUDTIME") > CurTime() then
			ply:SetNWInt("MKHUDMUL", Lerp(FT*10, ply:GetNWInt("MKHUDMUL"), 1 ) )
		else
			ply:SetNWInt("MKHUDMUL", Lerp(FT*10, ply:GetNWInt("MKHUDMUL"), 0 ) )
		end
		if ply:KeyDown(IN_RELOAD) and ply:Alive() then -- Кнопка для лерпа
			ply:SetNWInt("MKHUDTIME", CurTime() + 5)
		end
		if ply:Alive() and wep != nil and wep:IsValid() then
			if getClip() < wep:GetMaxClip1()*0.4 then
				ply:SetNWInt("MKHUDTIME", CurTime() + 1)
			end
		end
		
		if getClip() >= 0 then
			draw.RoundedBox( 6, ScrW() - 120, ScrH() - 65, 100, 50, Color(30,30,100,255*ply:GetNWInt("MKHUDMUL")))
			draw.SimpleText( getFullAmmo().."/"..getClip(), "ImpactMKHUD", ScrW() - 70, ScrH() - 40, Color(255,255,255,255*ply:GetNWInt("MKHUDMUL")), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		end	
		
	end
end

hook.Add("HUDPaint", "MKHUD", MKHUD)
 
hook.Add("HUDShouldDraw", "hideshithuddd", HUDShouldDraw)
 
hook.Add( "InitPostEntity", "MK_Avatar", function()
end )
 
local hide = {}

hide[ "CHudAmmo" ] = true
hide[ "CHudSecondaryAmmo" ] = true
hide[ "CHudHealth" ] = true
hide[ "CHudBattery" ] = true
hide[ "DarkRP_Hungermod" ] = true

hook.Add( "HUDShouldDraw", "HideHUD", function( name )
    if hide[ name ] then
        return false
    end
end )
 
local hideHUDElements = {
    ["DarkRP_LocalPlayerHUD"] = true,
}

hook.Add("HUDShouldDraw", "MKHUD_HideDefaultDarkRPHud", function(name)
    if hideHUDElements[name] then return false end
end)

local toHide = {
	CHudHealth = true,
	CHudBattery = true,
	CHudAmmo = true,
	CHudSecondaryAmmo = true,
	DarkRP_LocalPlayerHUD = true,
	DarkRP_Hungermod = true,
	DarkRP_Agenda = true,
	DarkRP_LockdownHUD = true,
	DarkRP_HasGunlicense = true,
}

hook.Add("HUDShouldDraw", "MKHUD", function(name)
	if toHide[name] then return false end
end)


-- Старый говно войс чат иконка (это хайд её если вам нужно будет)

timer.Simple(2, function()
	Material("voice/icntlk_pl"):SetFloat("$alpha", 0)
end)
hook.Add("ShutDown", "voice/icntlk_pl", function()
	Material("voice/icntlk_pl"):SetFloat("$alpha", 1)
end)

print("\n")
MsgC(Color(0,255,0), "---->\n")
MsgC(Color(255, 0, 0), " > ") MsgC(Color(255,255,255), "MrKuBu HUD ...\n")
MsgC(Color(255, 0, 0), " > ") MsgC(Color(255,255,255), "Version: 1.1\n")
MsgC(Color(255, 0, 0), " > ") MsgC(Color(255,255,255), "By MrKuBu \n")
MsgC(Color(255, 0, 0), " > ") MsgC(Color(255,255,255), "My Site: https://mrkubu.github.io \n")
MsgC(Color(255, 0, 0), " > ") MsgC(Color(255,255,255), "My VK: https://vk.com/mrkubu \n")
MsgC(Color(255, 0, 0), " > ") MsgC(Color(255,255,255), "My steam: https://steamcommunity.com/id/mrkubu \n")
MsgC(Color(255, 0, 0), " > ") MsgC(Color(255,255,255), "All copyright MrKuBu\n")
MsgC(Color(255, 0, 0), " > ") MsgC(Color(255,255,255), "Licence: Apache License 2.0 \n")
MsgC(Color(0,255,0), "---->\n")
print("\n")
--CODED BY MRKUBU
--CODED BY MRKUBU
--CODED BY MRKUBU
