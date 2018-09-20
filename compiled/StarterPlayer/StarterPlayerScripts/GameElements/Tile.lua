local TextPart = require(script.Parent:WaitForChild("TextPart"))
local Tile
do
  local _class_0
  local _parent_0 = TextPart
  local _base_0 = {
    Activate = function(self)
      if self.Activated then
        return 
      end
      self.Activated = true
      self:UnregisterClick()
      return self:Reveal()
    end,
    Reveal = function(self)
      self.Part.BrickColor = BrickColor.new("Light stone grey")
      local neighboringMines = 0
      for tile in self.Board:TileNeighborsIterator(self) do
        if tile.__class.__name == "Mine" then
          neighboringMines = neighboringMines + 1
        end
      end
      if neighboringMines == 0 then
        for tile in self.Board:TileNeighborsIterator(self) do
          tile:Activate()
        end
      else
        self.Label.Text = neighboringMines
        self.Label.TextColor3 = Color3.fromHSV(neighboringMines / 8, 1, .75)
      end
    end,
    ToggleFlag = function(self)
      self.Flagged = not self.Flagged
      if self.Flagged then
        self.Label.Text = "*Flag*"
        self.Board.FlagsCount = self.Board.FlagsCount + 1
      else
        self.Label.Text = ""
        self.Board.FlagsCount = self.Board.FlagsCount - 1
      end
      return self.Board:UpdateMinesCounter()
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, board, x, y)
      self.Activated = false
      self.Board = board
      self.XPosition = x
      self.YPosition = y
      local size = Vector3.new(4.5, 2, 4.5)
      local location = (CFrame.new(board.Position + Vector3.new(x * 5, 0, y * 5))) * CFrame.Angles(0, -math.pi / 2, 0)
      _class_0.__parent.__init(self, size, location)
      return self:RegisterClick((function()
        return self:Activate()
      end), (function()
        return self:ToggleFlag()
      end))
    end,
    __base = _base_0,
    __name = "Tile",
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
  Tile = _class_0
  return _class_0
end
