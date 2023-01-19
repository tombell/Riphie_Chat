local A, L = ...
local cfg = L.cfg

local function ApplyStyle(self)
  if not self then
    return
  end

  local name = self:GetName()

  self:SetClampRectInsets(0, 0, 0, 0)
  self:SetFont(unpack(cfg.chat.font))
  self:SetShadowOffset(unpack(cfg.dropshadow.offset))
  self:SetShadowColor(unpack(cfg.dropshadow.color))
  self:SetFading(false)

  local bf = _G[name .. "ButtonFrame"]
  bf:HookScript("OnShow", bf.Hide)
  bf:Hide()

  local eb = _G[name .. "EditBox"]
  eb:SetAltArrowKeyMode(false)

  _G[name .. "EditBoxLeft"]:Hide()
  _G[name .. "EditBoxMid"]:Hide()
  _G[name .. "EditBoxRight"]:Hide()

  eb:ClearAllPoints()

  if name == "ChatFrame2" then
    eb:SetPoint("BOTTOM", self, "TOP", 0, 22 + 24)
  else
    eb:SetPoint("BOTTOM", self, "TOP", 0, 22)
  end

  eb:SetPoint("LEFT", self, -5, 0)
  eb:SetPoint("RIGHT", self, 10, 0)
end

local function OpenTemporaryWindow()
  for _, name in next, CHAT_FRAMES do
    local frame = _G[name]

    if frame.isTemporary then
      ApplyStyle(frame)
    end
  end
end

local function OnMouseScroll(self, dir)
  if dir > 0 then
    if IsShiftKeyDown() then
      self:ScrollToTop()
    else
      self:ScrollUp()
    end
  else
    if IsShiftKeyDown() then
      self:ScrollToBottom()
    else
      self:ScrollDown()
    end
  end
end

local DefaultSetItemRef = SetItemRef
function SetItemRef(link, ...)
  local type, value = link:match("(%a+):(.+)")

  if IsAltKeyDown() and type == "player" then
    InviteUnit(value:match("([^:]+)"))
  elseif type == "url" then
    local eb = LAST_ACTIVE_CHAT_EDIT_BOX or ChatFrame1EditBox

    if not eb then
      return
    end

    eb:SetText(value)
    eb:SetFocus()
    eb:HighlightText()

    if not eb:IsShown() then
      eb:Show()
    end
  else
    return DefaultSetItemRef(link, ...)
  end
end

local function AddMessage(self, text, ...)
  text = text:gsub("|h%[(%d+)%. .-%]|h", "|h%1.|h")
  text = text:gsub("([wWhH][wWtT][wWtT][%.pP]%S+[^%p%s])", "|cffffffff|Hurl:%1|h[%1]|h|r")

  return self.DefaultAddMessage(self, text, ...)
end

ChatFontNormal:SetFont(unpack(cfg.editbox.font))
ChatFontNormal:SetShadowOffset(unpack(cfg.dropshadow.offset))
ChatFontNormal:SetShadowColor(unpack(cfg.dropshadow.color))

CHAT_FONT_HEIGHTS = { 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20 }

CHAT_TAB_HIDE_DELAY = 1

CHAT_FRAME_TAB_NORMAL_MOUSEOVER_ALPHA = 1
CHAT_FRAME_TAB_NORMAL_NOMOUSE_ALPHA = 0
CHAT_FRAME_TAB_SELECTED_MOUSEOVER_ALPHA = 1
CHAT_FRAME_TAB_SELECTED_NOMOUSE_ALPHA = 0
CHAT_FRAME_TAB_ALERTING_MOUSEOVER_ALPHA = 1
CHAT_FRAME_TAB_ALERTING_NOMOUSE_ALPHA = 1

CHAT_WHISPER_GET = "<< %s "
CHAT_WHISPER_INFORM_GET = ">> %s "
CHAT_BN_WHISPER_GET = "<< %s "
CHAT_BN_WHISPER_INFORM_GET = ">> %s "
CHAT_YELL_GET = "%s "
CHAT_SAY_GET = "%s "
CHAT_BATTLEGROUND_GET = "|Hchannel:Battleground|hBG.|h %s: "
CHAT_BATTLEGROUND_LEADER_GET = "|Hchannel:Battleground|hBGL.|h %s: "
CHAT_GUILD_GET = "|Hchannel:Guild|hG.|h %s: "
CHAT_OFFICER_GET = "|Hchannel:Officer|hGO.|h %s: "
CHAT_PARTY_GET = "|Hchannel:Party|hP.|h %s: "
CHAT_PARTY_LEADER_GET = "|Hchannel:Party|hPL.|h %s: "
CHAT_PARTY_GUIDE_GET = "|Hchannel:Party|hPG.|h %s: "
CHAT_RAID_GET = "|Hchannel:Raid|hR.|h %s: "
CHAT_RAID_LEADER_GET = "|Hchannel:Raid|hRL.|h %s: "
CHAT_RAID_WARNING_GET = "|Hchannel:RaidWarning|hRW.|h %s: "
CHAT_INSTANCE_CHAT_GET = "|Hchannel:Battleground|hI.|h %s: "
CHAT_INSTANCE_CHAT_LEADER_GET = "|Hchannel:Battleground|hIL.|h %s: "
-- CHAT_MONSTER_PARTY_GET = CHAT_PARTY_GET
-- CHAT_MONSTER_SAY_GET = CHAT_SAY_GET
-- CHAT_MONSTER_WHISPER_GET = CHAT_WHISPER_GET
-- CHAT_MONSTER_YELL_GET = CHAT_YELL_GET
CHAT_FLAG_AFK = "<AFK> "
CHAT_FLAG_DND = "<DND> "
CHAT_FLAG_GM = "<[GM]> "

YOU_LOOT_MONEY_GUILD = YOU_LOOT_MONEY
LOOT_MONEY_SPLIT_GUILD = LOOT_MONEY_SPLIT

BNToastFrame:SetClampedToScreen(true)
BNToastFrame:SetClampRectInsets(-15, 15, 15, -15)

ChatFrameMenuButton:HookScript("OnShow", ChatFrameMenuButton.Hide)
ChatFrameMenuButton:Hide()

ChatFrameChannelButton:HookScript("OnShow", ChatFrameChannelButton.Hide)
ChatFrameChannelButton:Hide()

local button = QuickJoinToastButton or FriendsMicroButton
button:HookScript("OnShow", button.Hide)
button:Hide()

for i = 1, NUM_CHAT_WINDOWS do
  local chatframe = _G["ChatFrame" .. i]
  ApplyStyle(chatframe)

  if i ~= 2 then
    chatframe.DefaultAddMessage = chatframe.AddMessage
    chatframe.AddMessage = AddMessage
  end
end

FloatingChatFrame_OnMouseScroll = OnMouseScroll

hooksecurefunc("FCF_OpenTemporaryWindow", OpenTemporaryWindow)
