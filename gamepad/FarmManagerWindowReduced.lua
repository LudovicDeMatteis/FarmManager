local fm = FarmManager
local classes = fm.classes
local window = FarmManagerWindowSmall
local itemList = {}
local totalFarmed = 0

classes.FarmManagerWindowReduced = ZO_Object:Subclass()

local function ToGold(amount)
	return ZO_CurrencyControl_FormatCurrencyAndAppendIcon(amount, false, CURT_MONEY, false)
end

function classes.FarmManagerWindowReduced:New(...)
    local object = ZO_Object.New(self)
    object:Init(...)
    return object
end

function classes.FarmManagerWindowReduced:Init()
    itemList = window:GetNamedChild("DetailPanel"):GetNamedChild("FmItemList")
    ZO_ScrollList_AddDataType(itemList, 1, "FarmManagerMiniGUIItemListItemTemplate", 30, function(control, data) self:UpdateDataRow(control, data) end)
end

function classes.FarmManagerWindowReduced:Show()
    window:SetHidden(false)
end

function classes.FarmManagerWindowReduced:Hide()
    window:SetHidden(true)
end

function classes.FarmManagerWindowReduced:UpdateDataRow(control, data)
  window:GetNamedChild("TotalLabel"):SetText(ToGold(math.floor(fm.farmer.totalValueFarmed or 0)))
	window:GetNamedChild("GoldPerSecondLabel"):SetText(ToGold(math.floor(fm.farmer:GetGoldPerSecond() * 60)).."/min")
end

function classes.FarmManagerWindowReduced:OnItemFarmed(item, actionType)
	local scrollData = ZO_ScrollList_GetDataList(itemList)
	local found = false
	for _, itemData in pairs(scrollData) do
		if itemData.data.itemId == item.itemId then
            itemData.data:Add(item, actionType)
			found = true
			break
		end
	end

	if not found then
		local data = FmDetailEntry:New(item, actionType)
		scrollData[#scrollData + 1] = ZO_ScrollList_CreateDataEntry(1, data)
	end

    ZO_ScrollList_Commit(itemList)
end


function classes.FarmManagerWindowReduced:Reset()
	local scrollData = ZO_ScrollList_GetDataList(itemList)
	ZO_ScrollList_Clear(itemList)
	ZO_ScrollList_Commit(itemList)
	window:GetNamedChild("TotalLabel"):SetText("")
	window:GetNamedChild("GoldPerSecondLabel"):SetText("")
end
