local lying = false
local currentBed = nil

local BedModels = {
    `v_med_bed1`,
    `v_med_bed2`,
    `v_med_bedtable`,
    `v_med_emptybed`,
    `v_med_bed`
}

-- =========================================================
-- FIND CLOSEST BED
-- =========================================================

local function GetClosestHospitalBed()
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)

    local closestBed = nil
    local closestDistance = 2.0

    for _, model in ipairs(BedModels) do

        local object = GetClosestObjectOfType(
            coords.x,
            coords.y,
            coords.z,
            2.0,
            model,
            false,
            false,
            false
        )

        if object ~= 0 then

            local bedCoords = GetEntityCoords(object)
            local distance = #(coords - bedCoords)

            if distance < closestDistance then
                closestDistance = distance
                closestBed = object
            end

        end
    end

    return closestBed
end


-- =========================================================
-- LIE ON BED
-- =========================================================

local function LieOnBed(bed)

    if lying then
        return
    end

    if not DoesEntityExist(bed) then
        return
    end

    local ped = PlayerPedId()

    local bedCoords = GetEntityCoords(bed)
    local bedHeading = GetEntityHeading(bed)

    currentBed = bed

    -- Move player onto the bed
    SetEntityCoords(
        ped,
        bedCoords.x,
        bedCoords.y,
        bedCoords.z + 0.25,
        false,
        false,
        false,
        true
    )

    -- =====================================================
    -- BED DIRECTION
    -- =====================================================
    -- 180 degrees makes the player face the opposite
    -- direction of the bed model.
    --
    -- If the player is still facing the wrong way,
    -- change this to:
    --
    -- SetEntityHeading(ped, bedHeading)
    -- =====================================================

    SetEntityHeading(
        ped,
        bedHeading + 180.0
    )

    Wait(200)

    -- Load animation
    local animDict = "anim@gangops@morgue@table@"

    RequestAnimDict(animDict)

    while not HasAnimDictLoaded(animDict) do
        Wait(10)
    end

    -- Play lying animation
    TaskPlayAnim(
        ped,
        animDict,
        "body_search",
        8.0,
        -8.0,
        -1,
        1,
        0.0,
        false,
        false,
        false
    )

    lying = true
end


-- =========================================================
-- GET UP FROM SAME BED
-- =========================================================

local function GetUp()

    if not lying then
        return
    end

    local ped = PlayerPedId()

    -- Save current bed before clearing it
    local bed = currentBed

    -- Immediately stop lying animation
    ClearPedTasksImmediately(ped)

    Wait(100)

    if DoesEntityExist(bed) then

        local bedCoords = GetEntityCoords(bed)
        local bedHeading = GetEntityHeading(bed)

        -- =================================================
        -- GET-UP POSITION
        -- =================================================
        -- Move the player to the SIDE of the SAME bed.
        --
        -- We use the bed heading to calculate the side
        -- position instead of another hospital bed.
        -- =================================================

        local rad = math.rad(bedHeading)

        local sideDistance = 1.15

        local offsetX = math.cos(rad) * sideDistance
        local offsetY = math.sin(rad) * sideDistance

        SetEntityCoords(
            ped,
            bedCoords.x + offsetX,
            bedCoords.y + offsetY,
            bedCoords.z + 0.85,
            false,
            false,
            false,
            true
        )

        -- Face away from the bed
        SetEntityHeading(
            ped,
            bedHeading + 180.0
        )

    end

    -- Stop lying state
    lying = false

    currentBed = nil

    -- Small delay so the bed interaction doesn't
    -- immediately trigger again.
    Wait(500)
end


-- =========================================================
-- BED INTERACTION
-- =========================================================

CreateThread(function()

    while true do

        local sleep = 1000

        -- =================================================
        -- PLAYER IS NOT LYING
        -- =================================================

        if not lying then

            local bed = GetClosestHospitalBed()

            if bed then

                sleep = 0

                BeginTextCommandDisplayHelp("STRING")

                AddTextComponentSubstringPlayerName(
                    "Press ~INPUT_CONTEXT~ to lie on the bed"
                )

                EndTextCommandDisplayHelp(
                    0,
                    false,
                    true,
                    -1
                )

                -- E key
                if IsControlJustReleased(0, 38) then

                    LieOnBed(bed)

                end

            end

        -- =================================================
        -- PLAYER IS LYING
        -- =================================================

        else

            sleep = 0

            BeginTextCommandDisplayHelp("STRING")

            AddTextComponentSubstringPlayerName(
                "Press ~INPUT_CONTEXT~ to get up"
            )

            EndTextCommandDisplayHelp(
                0,
                false,
                true,
                -1
            )

            -- E key
            if IsControlJustReleased(0, 38) then

                GetUp()

            end

        end

        Wait(sleep)

    end

end)