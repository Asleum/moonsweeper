local MouseInputsManager = require(script.Parent.Parent:WaitForChild("MouseInputsManager"))
local TextPart
do
  local _class_0
  local _base_0 = {
    RegisterClick = function(self, leftClickCallback, rightClickCallback)
      return MouseInputsManager.BindPartToClick(self.Part, leftClickCallback, rightClickCallback)
    end,
    UnregisterClick = function(self)
      return MouseInputsManager.UnbindPartFromClick(self.Part)
    end,
    Destroy = function(self)
      self:UnregisterClick()
      return self.Part:Destroy()
    end
  }
  _base_0.__index = _base_0
  _class_0 = setmetatable({
    __init = function(self, size, location)
      local _ = self.Part
      _ = self.Label
      do
        local _with_0 = Instance.new("Part")
        _with_0.Anchored = true
        _with_0.TopSurface = "Smooth"
        _with_0.BottomSurface = "Smooth"
        _with_0.Size = size
        _with_0.CFrame = location
        _with_0.Parent = game.Workspace
        self.Part = _with_0
      end
      do
        local surfaceGui = Instance.new("SurfaceGui")
        surfaceGui.Face = Enum.NormalId.Top
        surfaceGui.CanvasSize = 25 * Vector2.new(size.z, size.x)
        do
          local _with_0 = Instance.new("TextLabel")
          _with_0.Size = UDim2.new(1, 0, 1, 0)
          _with_0.BackgroundTransparency = 1
          _with_0.TextScaled = true
          _with_0.Text = ""
          _with_0.Parent = surfaceGui
          self.Label = _with_0
        end
        surfaceGui.Parent = self.Part
        return surfaceGui
      end
    end,
    __base = _base_0,
    __name = "TextPart"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  TextPart = _class_0
  return _class_0
end
