local Tile = require(script.Parent:WaitForChild("Tile"))
local Mine = require(script.Parent:WaitForChild("Mine"))
local TextPart = require(script.Parent:WaitForChild("TextPart"))
local Board
do
  local _class_0
  local _base_0 = {
    PrepareBoard = function(self)
      local generator = Random.new()
      local minesPositions = { }
      for i = 1, self.Mines do
        while true do
          local minePos = tostring(generator:NextInteger(1, self.Width)) .. ";" .. tostring(generator:NextInteger(1, self.Height))
          if not minesPositions[minePos] then
            minesPositions[minePos] = true
            break
          end
        end
      end
      for y = 1, self.Height do
        local row = { }
        for x = 1, self.Width do
          if minesPositions[tostring(x) .. ";" .. tostring(y)] then
            row[x] = Mine(self, x, y, self.Position)
          else
            row[x] = Tile(self, x, y, self.Position)
          end
        end
        self.Tiles[y] = row
      end
      return self:UpdateMinesCounter()
    end,
    ResetGame = function(self)
      for y = 1, self.Height do
        local _list_0 = self.Tiles[y]
        for _index_0 = 1, #_list_0 do
          local tile = _list_0[_index_0]
          tile:Destroy()
        end
      end
      self.Tiles = { }
      self.GameEnded = false
      self.FlagsCount = 0
      self.CorrectlyFlaggedMines = 0
      return self:PrepareBoard()
    end,
    EndGame = function(self, revealMines)
      if revealMines == nil then
        revealMines = true
      end
      if self.GameEnded then
        return 
      end
      self.GameEnded = true
      local _list_0 = self.Tiles
      for _index_0 = 1, #_list_0 do
        local row = _list_0[_index_0]
        for _index_1 = 1, #row do
          local tile = row[_index_1]
          if tile.__class.__name ~= "Mine" or revealMines then
            tile:Activate()
          end
        end
      end
    end,
    TileNeighborsIterator = function(self, tile)
      local startX = tile.XPosition - 1
      local startY = tile.YPosition - 1
      local i = 0
      local iterator
      iterator = function()
        if i < 9 then
          local x, y = startX + i % 3, startY + math.floor(i / 3)
          i = i + 1
          local isMiddle = x == tile.XPosition and y == tile.YPosition
          local xValid = x >= 1 and x <= self.Width
          local yValid = y >= 1 and y <= self.Height
          if xValid and yValid and not isMiddle then
            return self.Tiles[y][x]
          else
            return iterator()
          end
        end
      end
      return iterator
    end,
    UpdateMinesCounter = function(self)
      self.MinesCounter.Label.Text = "Mines left: " .. tostring(self.Mines - self.FlagsCount)
    end,
    CheckVictory = function(self)
      if self.CorrectlyFlaggedMines == self.Mines then
        self:EndGame(false)
        self.MinesCounter.Label.Text = "You won!"
      end
    end
  }
  _base_0.__index = _base_0
  _class_0 = setmetatable({
    __init = function(self, width, height, mines, position)
      self.Width = width
      self.Height = height
      self.Mines = mines
      self.Position = position
      self.GameEnded = false
      self.CorrectlyFlaggedMines = 0
      self.FlagsCount = 0
      local _ = self.MinesCounter
      _ = self.Resetter
      self.Tiles = { }
      local resetterSize = Vector3.new(5, 3, 10)
      local resetterLocation = (CFrame.new(position + Vector3.new(8, .75, -3)))
      local resetterAngle = CFrame.Angles(0, -math.pi / 2, -math.pi / 4)
      self.Resetter = TextPart(resetterSize, resetterLocation * resetterAngle)
      self.Resetter.Label.Text = "Click here to reset game"
      self.Resetter:RegisterClick(function()
        return self:ResetGame()
      end)
      self.MinesCounter = TextPart(resetterSize, (resetterLocation + Vector3.new(12, 0, 0)) * resetterAngle)
      self.MinesCounter.Label.Text = "Mines left: 0"
      return self:PrepareBoard()
    end,
    __base = _base_0,
    __name = "Board"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  Board = _class_0
  return _class_0
end
