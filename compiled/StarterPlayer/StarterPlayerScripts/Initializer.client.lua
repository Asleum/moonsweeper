print("Initializing...")
local gameElements = script.Parent:WaitForChild("GameElements")
local Board = require(gameElements:WaitForChild("Board"))
local MouseInputsManager = require(script.Parent:WaitForChild("MouseInputsManager"))
MouseInputsManager.Initialize()
Board(12, 8, 16, Vector3.new(0, 0, -50))
Board(8, 6, 8, Vector3.new(70, 0, -45))
Board(20, 16, 60, Vector3.new(-110, 0, -70))
return print("Ready!")