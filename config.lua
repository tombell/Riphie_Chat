local _, L = ...

local LibStub = LibStub
local LSM = LibStub "LibSharedMedia-3.0"

local font = LSM:Fetch("font", "Expressway")

L.cfg = {
  dropshadow = {
    offset = { 1, -2 },
    color = { 0, 0, 0, 0 },
  },

  editbox = {
    font = { font, 13, "OUTLINE" },
  },

  chat = {
    font = { font, 13, "OUTLINE" },
  },
}
