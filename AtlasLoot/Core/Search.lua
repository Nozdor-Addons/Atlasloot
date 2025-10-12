-- Core/Search.lua — anchors, compact layout; panel ABOVE the Filter button; proper lvl/ilvl rows

local RED = "|cffff0000"; local WHITE="|cffFFFFFF"; local GREEN="|cff1eff00"; local ORANGE="|cffFF8400"

local AL = LibStub("AceLocale-3.0"):GetLocale("AtlasLoot")
if not AtlasLoot then AtlasLoot = {} end

-- Safe Babble (no hard error if key missing)
local BI=nil
do
  local ok,lib=pcall(LibStub,"LibBabble-Inventory-3.0")
  if ok and lib then
    local ok2,t=pcall(lib.GetUnstrictLookupTable,lib); if ok2 and type(t)=="table" then BI=t else
      local ok3,t2=pcall(lib.GetLookupTable,lib); if ok3 and type(t2)=="table" then BI=t2 end
    end
  end
end
local function BI_L(k,f) if BI and BI[k] then return BI[k] end return f or k end
local function Ls(k,f) local v=rawget(AL,k); if v~=nil then return v end return f or k end

local modules={"AtlasLoot_BurningCrusade","AtlasLoot_Crafting","AtlasLoot_OriginalWoW","AtlasLoot_WorldEvents","AtlasLoot_WrathoftheLichKing","AtlasLoot_PVP","Atlasloot_Nozdor"}
local currentPage=1

local SLOT_ANCHORS={
  {s=1,label=BI_L("Head","Head")}, {s=2,label=BI_L("Neck","Neck")}, {s=3,label=BI_L("Shoulder","Shoulder")}, {s=4,label=BI_L("Back","Back")},
  {s=5,label=BI_L("Chest","Chest")}, {s=6,label=BI_L("Shirt","Shirt")}, {s=8,label=BI_L("Wrist","Wrist")},
  {s=9,label=BI_L("Hands","Hands")}, {s=10,label=BI_L("Waist","Waist")}, {s=11,label=BI_L("Legs","Legs")},
  {s=12,label=BI_L("Feet","Feet")}, {s=13,label=BI_L("Finger","Finger")}, {s=14,label=BI_L("Trinket","Trinket")},
  {s=16,label=BI_L("Relic","Relic")},
}
local ARMOR_ANCHORS={
  {a=1,label=BI_L("Cloth","Cloth")}, {a=2,label=BI_L("Leather","Leather")},
  {a=3,label=BI_L("Mail","Mail")},   {a=4,label=BI_L("Plate","Plate")},
}
local WEAPON_HAND_ANCHORS={
  {h=1,label=BI_L("One-Hand","One-Hand")}, {h=2,label=BI_L("Two-Hand","Two-Hand")},
  {h=3,label=BI_L("Main Hand","Main Hand")}, {h=4,label=BI_L("Off Hand","Off Hand")},
}
local WEAPON_TYPE_ANCHORS={
  {w=1,label=BI_L("Axe","Axe")}, {w=2,label=BI_L("Bow","Bow")}, {w=3,label=BI_L("Crossbow","Crossbow")},
  {w=4,label=BI_L("Dagger","Dagger")}, {w=5,label=BI_L("Gun","Gun")}, {w=6,label=BI_L("Mace","Mace")},
  {w=7,label=BI_L("Polearm","Polearm")}, {w=8,label=BI_L("Shield","Shield")}, {w=9,label=BI_L("Staff","Staff")},
  {w=10,label=BI_L("Sword","Sword")}, {w=11,label=BI_L("Thrown","Thrown")}, {w=12,label=BI_L("Wand","Wand")},
  {w=13,label=BI_L("Fist Weapon","Fist Weapon")}, {w=14,label=BI_L("Idol","Idol")}, {w=15,label=BI_L("Totem","Totem")},
  {w=16,label=BI_L("Libram","Libram")}, {w=21,label=Ls("Sigil","Sigil")},
}

-- Layout constants
local COLS=2
local COL_WIDTH=130
local ROW_HEIGHT=19
local LEFT=19
local TEXT_W=150
local GAP_BETWEEN_GROUPS=35

-- place panel ABOVE the Filter button
local function anchorPanelAboveButton()
  if AtlasLootDefaultFrameFilter and AtlasLootDefaultFrameSearchButtonFilter then
    local p=AtlasLootDefaultFrameFilter
    p:ClearAllPoints()
    p:SetPoint("BOTTOMLEFT", AtlasLootDefaultFrameSearchButtonFilter, "TOPLEFT", 0, 6)
  end
end

local function ensureCheckbox(name, parent, label, x, y)
  local cb = _G[name]
  if not cb then cb = CreateFrame("CheckButton", name, parent, "OptionsCheckButtonTemplate") end
  cb:ClearAllPoints()
  cb:SetPoint("TOPLEFT", parent, "TOPLEFT", x, y)

  local fs = _G[name.."Text"]
  if fs then
    fs:SetText(label or "")
    fs:SetWidth(TEXT_W)
    if fs.SetWordWrap     then fs:SetWordWrap(false) end
    if fs.SetNonSpaceWrap then fs:SetNonSpaceWrap(false) end
    if fs.SetJustifyH     then fs:SetJustifyH("LEFT") end
  end

  cb:Show()
  return cb
end

local function layoutGroup(prefix,anchors,cols,startX,startY,dx,dy)
  local parent=AtlasLootDefaultFrameFilter
  local minY=startY
  for i,it in ipairs(anchors) do
    local col=(i-1)%cols; local row=math.floor((i-1)/cols)
    local name="AtlasLootCB_"..prefix..(it.s or it.a or it.h or it.w)
    ensureCheckbox(name,parent,it.label,startX+col*dx,startY-row*dy)
    local y=startY-row*dy; if y<minY then minY=y end
  end
  return minY - GAP_BETWEEN_GROUPS
end

local function hideDefaultMini()
  for _,n in ipairs({
    "AtlasLootCheckButtonCloth","AtlasLootCheckButtonLeather","AtlasLootCheckButtonMail","AtlasLootCheckButtonPlate",
    "AtlasLootCheckButtonWeapon","AtlasLootCheckButton2Weapon","AtlasLootCheckButtonMainHand","AtlasLootCheckButtonOffHand",
  }) do if _G[n] then _G[n]:Hide() end end
end

-- Ranges layout (two rows under the Filter checkbox)
local EB_WIDTH   = 48
local EB_HEIGHT  = 20
local ROW_GAP    = 6
local COL_GAP    = 20
local CB_OFFSETX = 10
local LABEL_PAD  = 5
local SHIFT_FOR_LABEL = 35

local function layoutRanges()
  local p  = AtlasLootDefaultFrameFilter
  local cb = AtlasLootCheckButtonFilterEnable
  if not p then return -70 end

  -- fields
  local ilFromEB  = AtlasLootDefaultFrameFilterBoxIlvlFrom
  local ilToEB    = AtlasLootDefaultFrameFilterBoxIlvlBefore
  local lvFromEB  = AtlasLootDefaultFrameFilterBoxlvlFrom
  local lvToEB    = AtlasLootDefaultFrameFilterBoxlvlBefore

  -- size fields
  local function sizeEB(eb) if eb then eb:SetWidth(EB_WIDTH); eb:SetHeight(EB_HEIGHT) end end
  sizeEB(ilFromEB); sizeEB(ilToEB); sizeEB(lvFromEB); sizeEB(lvToEB)

  -- place under Filter checkbox
  if cb and ilFromEB then
    ilFromEB:ClearAllPoints(); ilFromEB:SetPoint("TOPLEFT", cb, "BOTTOMLEFT", CB_OFFSETX + SHIFT_FOR_LABEL, -4)
  elseif ilFromEB then
    ilFromEB:ClearAllPoints(); ilFromEB:SetPoint("TOPLEFT", p, "TOPLEFT", 16 + SHIFT_FOR_LABEL, -16)
  end
  if ilToEB then ilToEB:ClearAllPoints(); ilToEB:SetPoint("LEFT", ilFromEB or cb or p, "RIGHT", COL_GAP + SHIFT_FOR_LABEL, 0) end

  if lvFromEB then lvFromEB:ClearAllPoints(); lvFromEB:SetPoint("TOPLEFT", ilFromEB or (cb or p), "BOTTOMLEFT", 0, -ROW_GAP) end
  if lvToEB   then lvToEB  :ClearAllPoints(); lvToEB  :SetPoint("LEFT", lvFromEB or (ilFromEB or cb or p), "RIGHT", COL_GAP + SHIFT_FOR_LABEL, 0) end

  -- our labels pinned to their fields
  local function label(name, text, anchor)
    local fs = _G[name]; if not fs then fs = p:CreateFontString(name, "OVERLAY", "GameFontNormalSmall"); fs:SetJustifyH("RIGHT") end
    fs:SetText(text); fs:ClearAllPoints(); fs:SetPoint("RIGHT", anchor, "LEFT", -LABEL_PAD, 0); fs:Show(); return fs
  end
  if ilFromEB then label("AtlasLoot_FilterLabel_IlvlFrom", "ilvl "..Ls("from","от"), ilFromEB) end
  if ilToEB   then label("AtlasLoot_FilterLabel_IlvlTo",   Ls("to","до"),           ilToEB)   end
  if lvFromEB then label("AtlasLoot_FilterLabel_LvlFrom",  "lvl "..Ls("from","от"), lvFromEB) end
  if lvToEB   then label("AtlasLoot_FilterLabel_LvlTo",    Ls("to","до"),           lvToEB)   end

  -- where checkbox groups start
  local baseY = -70
  if lvFromEB and p.GetTop and lvFromEB.GetBottom and p:GetTop() and lvFromEB:GetBottom() then
    baseY = - math.floor((p:GetTop() - lvFromEB:GetBottom()) + 30)
  end
  return baseY
end

local function EnsureAllEquipFilters()
  if not AtlasLootDefaultFrameFilter then return end

  anchorPanelAboveButton()
  hideDefaultMini()

  if not AtlasLoot_ExtendedFilterInit then
    local p=AtlasLootDefaultFrameFilter
    p:SetWidth(LEFT + COL_WIDTH*COLS + 16)
    p:SetHeight(130)

    local y=layoutRanges()

    local x0,dx,dy=LEFT,COL_WIDTH,ROW_HEIGHT; local cols=COLS
    y=layoutGroup("A",ARMOR_ANCHORS,cols,x0,y,dx,dy)
    y=layoutGroup("H",WEAPON_HAND_ANCHORS,cols,x0,y,dx,dy)
    y=layoutGroup("W",WEAPON_TYPE_ANCHORS,cols,x0,y,dx,dy)
    y=layoutGroup("S",SLOT_ANCHORS,cols,x0,y,dx,dy)

    local wantH=math.abs(y)+20; if p:GetHeight()<wantH then p:SetHeight(wantH) end
    AtlasLoot_ExtendedFilterInit=true
  end
end

-- Toggle button
function AtlasLoot:ShowSearchFilter()
  if AtlasLootDefaultFrameFilter then
    EnsureAllEquipFilters()
    if AtlasLootDefaultFrameFilter:IsShown() then
      AtlasLootDefaultFrameFilter:Hide()
    else
      AtlasLootDefaultFrameFilter:Show()
    end
  end
end
function AtlasLoot_ShowSearchFilter() if AtlasLoot and AtlasLoot.ShowSearchFilter then AtlasLoot:ShowSearchFilter() end end

-- Pagination (compat)
if type(AtlasLoot.GetSearchResultPage)~="function" then
  function AtlasLoot:GetSearchResultPage(wlPage)
    local n=30; local res=AtlasLootCharDB and AtlasLootCharDB["SearchResult"] or {}; local total=#res
    local maxP=math.max(1, math.ceil(total/n)); local page=tonumber(wlPage) or 1; page=math.min(math.max(page,1),maxP)
    local t={}, (nil)
    local s=(page-1)*n+1; local e=math.min(total,s+n-1); local out=1
    for i=s,e do local row={unpack(res[i])}; row[1]=out; t[out]=row; out=out+1 end
    return t,maxP
  end
end

function AtlasLoot:ShowSearchResult()
  AtlasLoot_ShowItemsFrame("SearchResult","SearchResultPage"..currentPage, Ls("Search Result: %s","Search Result: %s"):format(AtlasLootCharDB.LastSearchedText or ""), pFrame)
end

-- Filtering by anchors
local function BuildAnchorState()
  local S,A,H,W={},{},{},{}
  local function on(n) local cb=_G[n]; return cb and cb:GetChecked() end
  for _,it in ipairs(SLOT_ANCHORS)        do if on("AtlasLootCB_S"..it.s) then S[it.s]=true end end
  for _,it in ipairs(ARMOR_ANCHORS)       do if on("AtlasLootCB_A"..it.a) then A[it.a]=true end end
  for _,it in ipairs(WEAPON_HAND_ANCHORS) do if on("AtlasLootCB_H"..it.h) then H[it.h]=true end end
  for _,it in ipairs(WEAPON_TYPE_ANCHORS) do if on("AtlasLootCB_W"..it.w) then W[it.w]=true end end
  return S,A,H,W
end
local function text_has_anchor(text,prefix,map)
  local any=false; for _ in pairs(map) do any=true break end
  if not any then return true end
  if not text then return false end
  for k,_ in pairs(map) do if string.find(text,"#"..prefix..k.."#") then return true end end
  return false
end
local function pass_ranges(itemLevel, reqLevel)
  local ilFrom=(AtlasLootDefaultFrameFilterBoxIlvlFrom and AtlasLootDefaultFrameFilterBoxIlvlFrom:GetNumLetters()>0) and AtlasLootDefaultFrameFilterBoxIlvlFrom:GetNumber() or 0
  local ilTo  =(AtlasLootDefaultFrameFilterBoxIlvlBefore and AtlasLootDefaultFrameFilterBoxIlvlBefore:GetNumLetters()>0) and AtlasLootDefaultFrameFilterBoxIlvlBefore:GetNumber() or 3000
  local lFrom =(AtlasLootDefaultFrameFilterBoxlvlFrom and AtlasLootDefaultFrameFilterBoxlvlFrom:GetNumLetters()>0) and AtlasLootDefaultFrameFilterBoxlvlFrom:GetNumber() or 0
  local lTo   =(AtlasLootDefaultFrameFilterBoxlvlBefore and AtlasLootDefaultFrameFilterBoxlvlBefore:GetNumLetters()>0) and AtlasLootDefaultFrameFilterBoxlvlBefore:GetNumber() or 80
  if itemLevel and not (ilFrom<=itemLevel and itemLevel<=ilTo) then return false end
  if reqLevel  and not (lFrom<=reqLevel  and reqLevel  <=lTo)  then return false end
  return true
end

local function RunSearch(applyFilters, queryText)
  AtlasLootCharDB["QuickLooks"][Ls("Search Result","Search Result")]={"SearchResult","SearchResultPage1"}
  AtlasLootCharDB["SearchResult"]={}

  local q=""; if queryText and queryText~="" then q=string.lower(strtrim(queryText)) end

  local self=AtlasLoot; local off=not self.db.profile.SearchOn.All
  if off then for _,m in ipairs(modules) do if self.db.profile.SearchOn[m]==true then off=false break end end end
  if off then DEFAULT_CHAT_FRAME:AddMessage(RED..AL["AtlasLoot"]..": "..WHITE..AL["You don't have any module selected to search on."]); return end
  if self.db.profile.SearchOn.All then AtlasLoot_LoadAllModules() else
    for k,v in pairs(self.db.profile.SearchOn) do
      if k~="All" and v==true and not IsAddOnLoaded(k) and LoadAddOn(k) and self.db.profile.LoDNotify then
        DEFAULT_CHAT_FRAME:AddMessage(GREEN..AL["AtlasLoot"]..": "..ORANGE..k..WHITE.." "..AL["sucessfully loaded."])
      end
    end
  end

  local S,A,H,W=BuildAnchorState()

  for dataID,data in pairs(AtlasLoot_Data) do
    for _,v in ipairs(data) do
      if type(v[2])=="number" and v[2]>0 then
        local name,_,_,itemLevel,reqLevel=GetItemInfo(v[2]); if not name then name=gsub(v[4],"=q%d=","") end
        local match=(q=="" ) or (string.find(string.lower(name or ""), q)~=nil)
        local pass=true
        if applyFilters then
          local ds=v[5]
          pass = pass_ranges(itemLevel,reqLevel)
              and text_has_anchor(ds,"s",S)
              and text_has_anchor(ds,"a",A)
              and text_has_anchor(ds,"h",H)
              and text_has_anchor(ds,"w",W)
        end
        if match and pass then
          local _,_,qnum=string.find(v[4],"=q(%d)="); local disp=name; if qnum then disp="=q"..qnum.."="..name end
          local lootpage=AtlasLoot_TableNames[dataID] and AtlasLoot_TableNames[dataID][1] or "Argh!"
          table.insert(AtlasLootCharDB["SearchResult"],{0,v[2],v[3],disp,lootpage,v[5] or "", "", dataID.."|".."\"\""})
        end
      end
    end
  end
  AtlasLootCharDB.LastSearchedText=queryText or ""
end

function AtlasLoot:Search(Text)
  EnsureAllEquipFilters()
  local apply = AtlasLootCheckButtonFilterEnable and AtlasLootCheckButtonFilterEnable:GetChecked()
  RunSearch(apply, Text); self:ShowSearchResult()
end
function AtlasLoot:SearchCastom(Text)
  EnsureAllEquipFilters(); RunSearch(true, Text); self:ShowSearchResult()
end
