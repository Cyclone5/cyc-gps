Config = {
    UpdateTick = 500, --msec (Blip update süresi) / (Blip Update Interval)
    ShowYourself = true, -- (Kişinin haritada kendini görüp göremeyeceğini seçin) / (You can see your own blip if true)
    VehicleBlips = true, -- (Araçtayken blip işaretinin değişmesi ayarı) / (Blip sprite changes in vehicle if true)
    Jobs = {
        ["ambulance"] = {
            sprite = 1,
            color = 1,
        },
        ["police"] = {
            sprite = 1,
            color = 84,
        },
        ["sheriff"] = {
            sprite = 1,
            color = 64,
        },
        -- ["fbi"] = { 
        --     sprite = 1, -- (Blip tipi) / (Blip Type)
        --     color = 64, -- Blip Rengi / (Blip Color)
        -- }, -- (Yeni meslekleri bu şekilde ekleyebilirsiniz) / (You can add new jobs as example)
    },
    Locales = {
        ["unknown"] = "Bilinmiyor",
        ["gps_closed"] = "GPS kapandı!",
        ["gps_opened"] = "Gps açıldı!"
    }
}
