local speed = -4.0
local sound_name = "flares_released"
-- local sound_name2 = "flares_empty"
local sound_name2 = "flares_empty"
local sound_dict = "DLC_SM_Countermeasures_Sounds"
local flare_hash = GetHashKey("weapon_flaregun")
local HelpShown = false
local HelpShown2 = false
local HelpShown3 = false


function ShowHelp()
    BeginTextCommandDisplayHelp("FLARE_HELP")
    EndTextCommandDisplayHelp(0, false, true, -1)
end

function ShowHelp2(text)
    BeginTextCommandDisplayHelp("STRING")
    AddTextComponentSubstringPlayerName(text)
    EndTextCommandDisplayHelp(0, false, true, -1)
end

function ShowHelp3(text, text2)
    BeginTextCommandDisplayHelp("TWOSTRINGS")
    AddTextComponentSubstringPlayerName(text)
    AddTextComponentSubstringPlayerName(text2)
    EndTextCommandDisplayHelp(0, false, true, -1)
end

local flare_models = {
    [GetHashKey("mogul")] = true,
    [GetHashKey("rogue")] = true,
    [GetHashKey("starling")] = true,
    [GetHashKey("seabreeze")] = true,
    [GetHashKey("tula")] = true,
    [GetHashKey("bombushka")] = true,
    [GetHashKey("hunter")] = true,
    [GetHashKey("nokota")] = true,
    [GetHashKey("pyro")] = true,
    [GetHashKey("molotok")] = true,
    [GetHashKey("havok")] = true,
    [GetHashKey("alphaz1")] = true,
    [GetHashKey("microlight")] = true,
    [GetHashKey("howard")] = true,
    [GetHashKey("avenger")] = true,
    [GetHashKey("thruster")] = true,
    [GetHashKey("volatol")] = true,
}

function CanShootFlares(vehicle)
    if DoesEntityExist(vehicle) and IsEntityAVehicle(vehicle) and not IsEntityDead(vehicle) then
        local model = GetEntityModel(vehicle)
        if flare_models[model] then
            if GetVehicleMod(vehicle, 1) == 1 then
                return true
            end
        end
    end
    return false
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if IsPedInAnyVehicle(PlayerPedId(), false) then
            local entity = GetVehiclePedIsIn(PlayerPedId(), false)
            if CanShootFlares(entity) then
                
                RequestScriptAudioBank(sound_dict)
                
                RequestModel(flare_hash)
                RequestWeaponAsset(flare_hash, 31, 26)
                
                if not HelpShown then
                    HelpShown = true
                    ShowHelp()
                end
                
                if IsControlJustReleased(0, 355) then
                    local pos = GetEntityCoords(entity)
                    local offset1 = GetOffsetFromEntityInWorldCoords(entity, -6.0, -4.0, -0.2)
                    local offset2 = GetOffsetFromEntityInWorldCoords(entity, -3.0, -4.0, -0.2)
                    local offset3 = GetOffsetFromEntityInWorldCoords(entity, 6.0, -4.0, -0.2)
                    local offset4 = GetOffsetFromEntityInWorldCoords(entity, 3.0, -4.0, -0.2)
                    PlaySoundFromEntity(-1, sound_name, entity, sound_dict, true)
                    ShootSingleBulletBetweenCoordsWithExtraParams(pos, offset1, 0, true, flare_hash, PlayerPedId(), true, true, speed, entity, false, false, false, true, true, false)
                    ShootSingleBulletBetweenCoordsWithExtraParams(pos, offset2, 0, true, flare_hash, PlayerPedId(), true, true, speed, entity, false, false, false, true, true, false)
                    ShootSingleBulletBetweenCoordsWithExtraParams(pos, offset3, 0, true, flare_hash, PlayerPedId(), true, true, speed, entity, false, false, false, true, true, false)
                    ShootSingleBulletBetweenCoordsWithExtraParams(pos, offset4, 0, true, flare_hash, PlayerPedId(), true, true, speed, entity, false, false, false, true, true, false)
                    Citizen.Wait(1)
                    local timer = GetGameTimer()
                    while GetGameTimer() - timer < 2000 do
                        if IsControlJustReleased(0, 355) then
                            if DoesEntityExist(entity) then
                                PlaySoundFromEntity(-1, sound_name2, entity, sound_dict, true)
                            end
                        end
                        Citizen.Wait(0)
                    end
                end
            else
                HelpShown = false
                if HasModelLoaded(flare_hash) then
                    SetModelAsNoLongerNeeded(flare_hash)
                end
            end
        else
            HelpShown = false
            if HasModelLoaded(flare_hash) then
                SetModelAsNoLongerNeeded(flare_hash)
            end
        end
    end

end)


local bomb_plane_models = {
    [GetHashKey("cuban800")] = true,
    [GetHashKey("mogul")] = true,
    [GetHashKey("rogue")] = true,
    [GetHashKey("starling")] = true,
    [GetHashKey("seabreeze")] = true,
    [GetHashKey("tula")] = true,
    [GetHashKey("bombushka")] = true,
    [GetHashKey("hunter")] = true,
    [GetHashKey("avenger")] = true,
    [GetHashKey("akula")] = true,
    [GetHashKey("volatol")] = true,
}

local bomb_plane_models_cam_offset = {
    [GetHashKey("cuban800")] = vector3(0.0, 0.2, 1.0),
    [GetHashKey("mogul")] = vector3(0.0, 0.2, 0.97),
    [GetHashKey("rogue")] = vector3(0.0, 0.3, 1.10),
    [GetHashKey("starling")] = vector3(0.0, 0.25, 0.55),
    [GetHashKey("seabreeze")] = vector3(0.0, 0.2, 0.4),
    [GetHashKey("tula")] = vector3(0.0, 0.0, 1.0),
    [GetHashKey("bombushka")] = vector3(0.0, 0.3, 0.8),
    [GetHashKey("hunter")] = vector3(0.0, 0.0, 1.0),
    [GetHashKey("avenger")] = vector3(0.0, 0.0, 0.5),
    [GetHashKey("akula")] = vector3(0.0, 0.0, 0.8),
    [GetHashKey("volatol")] = vector3(0.0, 0.0, 2.0),
}

local unk_offsets = {
    [GetHashKey("cuban800")] = 0.5,
    [GetHashKey("mogul")] = 0.45,
    [GetHashKey("rogue")] = 0.46,
    [GetHashKey("starling")] = 0.55,
    [GetHashKey("seabreeze")] = 0.5,
    [GetHashKey("tula")] = 0.6,
    [GetHashKey("bombushka")] = 0.43,
    [GetHashKey("hunter")] = 0.5,
    [GetHashKey("avenger")] = 0.36,
    [GetHashKey("akula")] = 0.4,
    [GetHashKey("volatol")] = 0.54,
}

function CanDropBombs(vehicle)
    if DoesEntityExist(vehicle) and IsEntityAVehicle(vehicle) and not IsEntityDead(vehicle) then
        local model = GetEntityModel(vehicle)
        if bomb_plane_models[model] then
            if GetVehicleMod(vehicle, 9) > -1 then
                return true
            end
        end
    end
    return false
end

local bomb_models = {
    [1] = 1794615063, -- fire explosion
    [2] = 1430300958, -- gas explosion
    [3] = 220773539, -- cluster explosion
}

function AreBombBayDoorsOpen(veh)
    return Citizen.InvokeNative(0xD0917A423314BBA8, veh) == 1
end


local _cam = 0
function GetBombCamera()
    if not DoesCamExist(cam) then
        -- _cam = CreateCam("DEFAULT_SCRIPTED_CAMERA", false)
        _cam = CreateCameraWithParams(26379945, 0.0, 0.0, 0.0, -90.0, 0.0, GetEntityHeading(PlayerPedId()), 65.0, 1, 2)
    end
    return _cam
end



function func_5789(veh)
    return unk_offsets[GetEntityModel(veh)]
end

function func_5790(vParam0, vParam1, fParam2, fParam3, fParam4)
    return vector3(func_5791(vParam0.x, vParam1.x, fParam2, fParam3, fParam4), func_5791(vParam0.y, vParam1.y, fParam2, fParam3, fParam4), func_5791(vParam0.z, vParam1.z, fParam2, fParam3, fParam4))
end

function func_5791(fParam0, fParam1, fParam2, fParam3, fParam4)
    return ((((fParam1 - fParam0) / (fParam3 - fParam2)) * (fParam4 - fParam2)) + fParam0)
end

function GetBombPosition(veh)
    local dimensionPos1, dimensionPos2 = GetModelDimensions(GetEntityModel(veh))
    local vVar0 = GetOffsetFromEntityInWorldCoords(veh, dimensionPos1.x, dimensionPos2.y, dimensionPos1.z)
    local vVar1 = GetOffsetFromEntityInWorldCoords(veh, dimensionPos2.x, dimensionPos2.y, dimensionPos1.z)
    local vVar2 = GetOffsetFromEntityInWorldCoords(veh, dimensionPos1.x, dimensionPos1.y, dimensionPos1.z)
    local vVar3 = GetOffsetFromEntityInWorldCoords(veh, dimensionPos2.x, dimensionPos1.y, dimensionPos1.z)
    
    local vVar4 = func_5790(vVar0, vVar1, 0.0, 1.0, 0.5)
    local vVar5 = func_5790(vVar2, vVar3, 0.0, 1.0, 0.5)
    
    vVar4 = vVar4 + vector3(0.0, 0.0, 0.4)
    vVar5 = vVar5 + vector3(0.0, 0.0, 0.4)
    
    local vVar6 = func_5790(vVar4, vVar5, 0.0, 1.0, func_5789(veh))
    
    vVar4 = vVar4 - vector3(0.0, 0.0, 0.2)
    vVar5 = vVar5 - vector3(0.0, 0.0, 0.2)
    
    local vVar7 = func_5790(vVar4, vVar5, 0.0, 1.0, func_5789(veh) - 0.0001)
    
    local pos = vVar6
    local offset = vVar7
    return pos, offset
end


function DropBomb(pos, offset, veh)
    
    
    
    local bomb_model = 0
    local veh_model = GetEntityModel(veh)
    local mod_bomb_id = GetVehicleMod(veh, 9)
    if mod_bomb_id == 0 then
        if veh_model == GetHashKey("volatol") then
            bomb_model = 1856325840
        else
            bomb_model = -1695500020
        end
    elseif mod_bomb_id > 0 and mod_bomb_id < 4 then
        bomb_model = bomb_models[mod_bomb_id]
    end
    RequestModel(bomb_model)
    RequestWeaponAsset(bomb_model, 31, 26)
    while not HasWeaponAssetLoaded(bomb_model) do
        Citizen.Wait(1)
    end
    
    ShootSingleBulletBetweenCoordsWithExtraParams(pos, offset, 0, true, bomb_model, PlayerPedId(), true, true, -4.0, veh, false, false, false, true, true, false)
    PlaySoundFromEntity(-1, "bomb_deployed", veh, "DLC_SM_Bomb_Bay_Bombs_Sounds", true)
end

function GetHoverModePercentage(vehicle)

    -- local value = Citizen.InvokeNative(0xBBE00FBD9BB33AF0, vehicle)
    local value = Citizen.InvokeNative(0xDA62027C8BDB326E, vehicle)
    if value == false then
        return 0.0
    end
    return 1.0
end



Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if IsPedInAnyVehicle(PlayerPedId(), false) then
            local veh = GetVehiclePedIsIn(PlayerPedId(), false)
            if CanDropBombs(veh) then
                local vhash = GetEntityModel(veh)
                if ((vhash == GetHashKey("avenger") or vhash == GetHashKey("tula")) and GetHoverModePercentage(veh) == 0.0) or (vhash ~= GetHashKey("tula") and vhash ~= GetHashKey("avenger")) then
                    RequestScriptAudioBank(sound_dict)
                    
                    if not HelpShown2 and not AreBombBayDoorsOpen(veh) then
                        HelpShown2 = true
                        ShowHelp2("Hold ~INPUT_VEH_FLY_BOMB_BAY~ to open the bomb bay doors.")
                    end
                    
                    if IsControlPressed(0, 355) then
                        local toggle = false
                        local timer = GetGameTimer()
                        while IsControlPressed(0, 355) do
                            if GetGameTimer() - timer > 500 then
                                toggle = true
                                break
                            end
                            Citizen.Wait(0)
                        end
                        if toggle then
                            if AreBombBayDoorsOpen(veh) then
                                CloseBombBayDoors(veh)
                                
                                ClearPedTasks(PlayerPedId())
                                
                                StopAudioScene("DLC_SM_Bomb_Bay_View_Scene")
                                
                                SetCamActive(GetBombCamera(), false)
                                RenderScriptCams(false, false, 0, false, false)
                                DestroyCam(GetBombCamera(), false)
                                DestroyAllCams(true)
                            else
                                OpenBombBayDoors(veh)
                                
                                SetCamActive(GetBombCamera(), true)
                                local p = GetBombPosition(veh)
                                local pOff = GetOffsetFromEntityGivenWorldCoords(veh, p.x, p.y, p.z) + bomb_plane_models_cam_offset[GetEntityModel(veh)]
                                AttachCamToEntity(GetBombCamera(), veh, pOff, true)
                                
                                RenderScriptCams(true, false, 0, false, false)
                                local target_pos = GetOffsetFromEntityInWorldCoords(veh, 0.0, 10000.0, 0.0)
                                if IsThisModelAPlane(GetEntityModel(veh)) then
                                    TaskPlaneMission(PlayerPedId(), veh, 0, 0, target_pos, 4, 30.0, 0.1, GetEntityHeading(veh), 30.0, 20.0)
                                end
                                StartAudioScene("DLC_SM_Bomb_Bay_View_Scene")
                                N_0xad2d28a1afdff131(veh, 0.0) -- SetPlaneTurbulenceMultiplier()
                                -- BRAIN::TASK_PLANE_MISSION(PLAYER::PLAYER_PED_ID(), iParam0, 0, 0, vLocal_12678.x, vLocal_12678.y, vVar1.z, 4, 50f, 0.1f, -1f, 30, 20, 1);
                            end
                        end
                    end
                    while IsControlPressed(0, 355) do
                        Citizen.Wait(0)
                    end
                    
                    
                    if AreBombBayDoorsOpen(veh) then
                        if not HelpShown3 then
                            ShowHelp3("Press ~INPUT_VEH_FLY_ATTACK~ to drop a bomb.", "Hold ~INPUT_VEH_FLY_BOMB_BAY~ to close the bomb bay doors.")
                            HelpShown3 = true
                        end
                        DisableControlAction(0, 114)
                        -- DisableControlAction(0, 70)
                        if IsControlJustReleased(0, 255) then
                            -- local pos = GetOffsetFromEntityInWorldCoords(veh, 0.0, bomb_plane_models_cam_offset_y[GetEntityModel(veh)], bomb_plane_models_cam_offset_z[GetEntityModel(veh)] - 0.5)
                            -- local offset = GetOffsetFromEntityInWorldCoords(veh, 0.0, bomb_plane_models_cam_offset_y[GetEntityModel(veh)] + 0.05, bomb_plane_models_cam_offset_z[GetEntityModel(veh)] - 0.7)
                            -- if GetEntityModel(veh) == GetHashKey("bombushka") then
                                -- pos = GetOffsetFromEntityInWorldCoords(veh, 0.0, -3.8, -1.8)
                                -- offset = GetOffsetFromEntityInWorldCoords(veh, 0.0, -3.7, -2.0)
                            -- end
                            local pos, offset = GetBombPosition(veh)
                            -- SetCamRot(GetBombCamera(), -90.0, GetEntityHeading(veh), 0.0, 1)
                            
                            
                            DropBomb(pos, offset, veh)
                            -- ShootSingleBulletBetweenCoordsWithExtraParams(pos, offset, 0, true, bomb_model, PlayerPedId(), true, true, -4.0, veh, false, false, false, true, true, false)
                            -- PlaySoundFromEntity(-1, "bomb_deployed", veh, "DLC_SM_Bomb_Bay_Bombs_Sounds", true)
                            local tmp_timer = GetGameTimer()
                            while GetGameTimer() - tmp_timer < 1000 do
                                Citizen.Wait(0)
                                DisableControlAction(0, 114)
                                if IsControlJustReleased(0, 255) then
                                    PlaySoundFromEntity(-1, "chaff_cooldown", veh, "DLC_SM_Countermeasures_Sounds", true)
                                end
                            end
                        end
                    else
                        if not IsGameplayCamRendering() then
                            SetCamActive(GetBombCamera(), false)
                            RenderScriptCams(false, false, 0, false, false)
                            DestroyCam(GetBombCamera(), false)
                            DestroyAllCams(true)
                        end
                            
                        HelpShown3 = false
                        HelpShown2 = false
                    end
                end
                
            else
                HelpShown2 = false
                HelpShown3 = false
                if HasModelLoaded(bomb_model) then
                    SetModelAsNoLongerNeeded(bomb_model)
                end
            end
        else
            HelpShown2 = false
            HelpShown3 = false
            if HasModelLoaded(bomb_model) then
                SetModelAsNoLongerNeeded(bomb_model)
            end
        end
    end
end)

