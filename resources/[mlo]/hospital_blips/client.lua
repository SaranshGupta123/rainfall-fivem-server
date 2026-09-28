CreateThread(function()

    -- Paleto Bay Hospital
    local paleto = AddBlipForCoord(
        -247.35,
        6331.24,
        32.43
    )

    SetBlipSprite(paleto, 61)
    SetBlipDisplay(paleto, 4)
    SetBlipScale(paleto, 0.8)
    SetBlipColour(paleto, 2)
    SetBlipAsShortRange(paleto, true)

    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Paleto Bay Hospital")
    EndTextCommandSetBlipName(paleto)


    -- Sandy Shores Hospital
    local sandy = AddBlipForCoord(
        1839.6,
        3672.93,
        34.28
    )

    SetBlipSprite(sandy, 61)
    SetBlipDisplay(sandy, 4)
    SetBlipScale(sandy, 0.8)
    SetBlipColour(sandy, 2)
    SetBlipAsShortRange(sandy, true)

    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Sandy Shores Hospital")
    EndTextCommandSetBlipName(sandy)


    -- Pillbox Hospital
    local pillbox = AddBlipForCoord(
        307.5,
        -595.2,
        43.28
    )

    SetBlipSprite(pillbox, 61)
    SetBlipDisplay(pillbox, 4)
    SetBlipScale(pillbox, 0.8)
    SetBlipColour(pillbox, 2)
    SetBlipAsShortRange(pillbox, true)

    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Pillbox Hospital")
    EndTextCommandSetBlipName(pillbox)

end)