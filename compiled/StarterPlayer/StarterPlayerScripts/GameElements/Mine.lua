local Tile = require(script.Parent:WaitForChild("Tile"))
local Mine
do
  local _class_0
  local _parent_0 = Tile
  local _base_0 = {
    Reveal = function(self)
      self.Label.Text = "X"
      self.Part.BrickColor = BrickColor.new("Bright red")
      return self.Board:EndGame()
    end,
    ToggleFlag = function(self)
      _class_0.__parent.__base.ToggleFlag(self)
      if self.Flagged then
        self.Board.CorrectlyFlaggedMines = self.Board.CorrectlyFlaggedMines + 1
      else
        self.Board.CorrectlyFlaggedMines = self.Board.CorrectlyFlaggedMines - 1
      end
      return self.Board:CheckVictory()
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, ...)
      return _class_0.__parent.__init(self, ...)
    end,
    __base = _base_0,
    __name = "Mine",
    __parent = _parent_0
  }, {
    __index = function(cls, name)
      local val = rawget(_base_0, name)
      if val == nil then
        local parent = rawget(cls, "__parent")
        if parent then
          return parent[name]
        end
      else
        return val
      end
    end,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  if _parent_0.__inherited then
    _parent_0.__inherited(_parent_0, _class_0)
  end
  Mine = _class_0
  return _class_0
end
