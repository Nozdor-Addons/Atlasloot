AtlasLootVersionsList = {}

AtlasLootVersionsList[1] = "01.09.25"
AtlasLootVersionsList[2] = "09.09.25"
AtlasLootVersionsList[3] = "13.10.25"
AtlasLootVersionsList[4] = "18.10.25"
AtlasLootVersionsList[5] = "03.11.25"
AtlasLootVersionsList[6] = "29.11.25"
AtlasLootVersionsList[7] = "9.01.26"
AtlasLootVersionsList[8] = "23.01.26"

local GREY = "|cff999999";
local RED = "|cffff0000";
local WHITE = "|cffFFFFFF";
local GREEN = "|cff1eff00";
local PURPLE = "|cff9F3FFF";
local BLUE = "|cff0070dd";
local ORANGE = "|cffFF8400";
local BLACK = "|cff000000";

function AtlasLoot_DisplayChangelog()
local ALframewidth = InterfaceOptionsFramePanelContainer:GetWidth()
local ALframeheight = InterfaceOptionsFramePanelContainer:GetHeight()
	if not getglobal("AtlasLoot_ChangelogFrame") then
	local panel3 = CreateFrame("ScrollFrame", "AtlasLootChangelog_ScrollFrame", AtlasLootChangelogFrame, "UIPanelScrollFrameTemplate")
	local scc = CreateFrame("Frame", "AtlasLoot_ChangelogFrame", panel3)
			panel3:SetScrollChild(scc)
			panel3:SetPoint("TOPLEFT", AtlasLootChangelogFrame, "TOPLEFT", 10, -35)
			panel3:SetWidth(ALframewidth-45)
			panel3:SetHeight(ALframeheight-45)
			panel3:SetHorizontalScroll(-50)
			panel3:SetVerticalScroll(50)
			panel3:SetBackdrop({bgFile="Interface\\DialogFrame\\UI-DialogBox-Background", edgeFile="", tile = false, tileSize = 0, edgeSize = 0, insets = { left = 0, right = 0, top = 0, bottom = 0 }})
			panel3:SetScript("OnVerticalScroll", function()  end)
			panel3:EnableMouse(true)
			panel3:SetVerticalScroll(0)
			panel3:SetHorizontalScroll(0)
			scc:SetPoint("TOPLEFT", panel3, "TOPLEFT", 0, 0)
			scc:SetWidth(ALframewidth-45)
			scc:SetHeight(ALframeheight-45)

local text = scc:CreateFontString("AtlasLootChangelog_Text", "OVERLAY", "GameFontNormal")
text:SetFont("Fonts\\FRIZQT__.TTF", 12)
text:SetPoint("TOPLEFT", scc, "TOPLEFT", 10, -50)
text:SetWidth(scc:GetWidth()-10)
text:SetJustifyH("LEFT")
text:SetJustifyV("TOP")

function AtlasLootChangelogText(x)

if x == 1 then
text:SetText(WHITE..
"- Адаптация под Nozdor.com".."\n\n"
)
elseif x == 2 then
text:SetText(WHITE..
"- Вневременной остров".."\n\n"
)
elseif x == 3 then
text:SetText(WHITE..
"- Изменение фильтра".."\n\n"
)
elseif x == 4 then
text:SetText(WHITE..
"- Лут с Всадника без головы (Мировой босс)".."\n\n"
)
elseif x == 5 then
text:SetText(WHITE..
"- Ап Вневпеменного острова".."\n\n"
)
elseif x == 6 then
text:SetText(WHITE..
"- Предметы с ААО".."\n\n"
)
end
end

AtlasLootChangelogText(#AtlasLootVersionsList)

local chooseversion = AtlasLootVersionsList[#AtlasLootVersionsList]

local dropDown = CreateFrame("FRAME", "ChangelogDropDown", AtlasLoot_ChangelogFrame, "UIDropDownMenuTemplate")
dropDown:SetPoint("TOP", 100, -10)
UIDropDownMenu_SetWidth(dropDown, 80)
UIDropDownMenu_SetText(dropDown, chooseversion)


function dropDown:SetValue(newValue)
 chooseversion = AtlasLootVersionsList[newValue]
 UIDropDownMenu_SetText(dropDown, chooseversion)
 AtlasLootChangelogText(newValue)
 CloseDropDownMenus()
end

UIDropDownMenu_Initialize(dropDown, function(self, level, menuList)
 local info = UIDropDownMenu_CreateInfo()
  info.tooltipTitle = "Выберите версию"
  info.func = self.SetValue
  for i=1, table.getn(AtlasLootVersionsList) do
   info.text, info.arg1, info.checked = AtlasLootVersionsList[i], i, AtlasLootVersionsList[i] == chooseversion
   UIDropDownMenu_AddButton(info, level)
  end
end)

else
getglobal("AtlasLootChangelog_ScrollFrame"):SetWidth(ALframewidth-45) --panel3 width
getglobal("AtlasLootChangelog_ScrollFrame"):SetHeight(ALframeheight-45) --panel3 height
getglobal("AtlasLoot_ChangelogFrame"):SetWidth(ALframewidth-45) --scc width
getglobal("AtlasLoot_ChangelogFrame"):SetHeight(ALframeheight-45) --scc height
getglobal("AtlasLootChangelog_Text"):SetWidth(getglobal("AtlasLoot_ChangelogFrame"):GetWidth()-10) --text width
end

if getglobal("BetterBlizzOptionsResizeGrip") ~= nil then
getglobal("BetterBlizzOptionsResizeGrip"):SetScript("OnMouseUp", function(self)
self:GetParent():StopMovingOrSizing()
ALframewidth = InterfaceOptionsFramePanelContainer:GetWidth()
ALframeheight = InterfaceOptionsFramePanelContainer:GetHeight()

getglobal("AtlasLootChangelog_ScrollFrame"):SetWidth(ALframewidth-45) --panel3 width
getglobal("AtlasLootChangelog_ScrollFrame"):SetHeight(ALframeheight-45) --panel3 height
getglobal("AtlasLoot_ChangelogFrame"):SetWidth(ALframewidth-45) --scc width
getglobal("AtlasLoot_ChangelogFrame"):SetHeight(ALframeheight-45) --scc height
getglobal("AtlasLootChangelog_Text"):SetWidth(getglobal("AtlasLoot_ChangelogFrame"):GetWidth()-10) --text width
end)
end

end