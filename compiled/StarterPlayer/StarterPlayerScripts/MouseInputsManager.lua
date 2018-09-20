local MouseInputsManager
do
  local _class_0
  local _base_0 = { }
  _base_0.__index = _base_0
  _class_0 = setmetatable({
    __init = function() end,
    __base = _base_0,
    __name = "MouseInputsManager"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  local self = _class_0
  self.Initialize = function()
    self.LeftClickHandlers = { }
    self.RightClickHandlers = { }
    self.Mouse = game.Players.LocalPlayer:GetMouse()
    local _ = self.SelectionBox
    do
      local _with_0 = Instance.new("SelectionBox")
      _with_0.Color3 = Color3.new()
      _with_0.Parent = game.Players.LocalPlayer.PlayerGui
      self.SelectionBox = _with_0
    end
    self.Mouse.Button1Down:Connect(function()
      do
        local handler = self.LeftClickHandlers[self.Mouse.Target]
        if handler then
          return handler()
        end
      end
    end)
    self.Mouse.Button2Down:Connect(function()
      do
        local handler = self.RightClickHandlers[self.Mouse.Target]
        if handler then
          return handler()
        end
      end
    end)
    self.Mouse.Move:Connect(self.UpdateSelectionBox)
    return print("Now registering mouse inputs")
  end
  self.BindPartToClick = function(part, leftClickCallback, rightClickCallback)
    self.LeftClickHandlers[part] = leftClickCallback
    self.RightClickHandlers[part] = rightClickCallback
    return self.UpdateSelectionBox()
  end
  self.UnbindPartFromClick = function(part)
    self.LeftClickHandlers[part] = nil
    self.RightClickHandlers[part] = nil
    return self.UpdateSelectionBox()
  end
  self.UpdateSelectionBox = function()
    if self.LeftClickHandlers[self.Mouse.Target] or self.RightClickHandlers[self.Mouse.Target] then
      self.SelectionBox.Adornee = self.Mouse.Target
    else
      self.SelectionBox.Adornee = nil
    end
  end
  MouseInputsManager = _class_0
  return _class_0
end
