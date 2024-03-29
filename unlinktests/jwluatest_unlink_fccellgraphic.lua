
function FCCellGraphic_Test_Unlinkable(meas, staff, partnumber)
    if AssureNonNil(finale.FCCellGraphics, "finale.FCCellGraphics") then
        local coll = finale.FCCellGraphics()
        coll:LoadAllInCell(finale.FCCell(meas, staff)) -- return count loaded
        for graphic in eachbackwards(coll) do -- going backwards accounts for inci shuffling caused by Relink functions
            UnlinkableNumberPropertyTest(graphic, "FCCellGraphic", "HorizontalPos", "Reload", nil, -12, partnumber, skip_finale_version)
            UnlinkableNumberPropertyTest(graphic, "FCCellGraphic", "VerticalPos", "Reload", nil, 12, partnumber, skip_finale_version)
            UnlinkableNumberPropertyTest(graphic, "FCCellGraphic", "Visible", "Reload", nil, -12, partnumber, skip_finale_version)
            --
            --Currently not unlinkable even manually:
            --UnlinkableNumberPropertyTest(graphic, "FCCellGraphic", "Height", "Reload", nil, -12, partnumber, skip_finale_version)
            --UnlinkableNumberPropertyTest(graphic, "FCCellGraphic", "Width", "Reload", nil, -12, partnumber, skip_finale_version)
        end
    end
end

-- Call:
FCCellGraphic_Test_Unlinkable(11, 2, 2)
