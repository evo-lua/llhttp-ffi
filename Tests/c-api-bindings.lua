-- Whatever name or description you set here will be displayed in the final report
local testSuite = TestSuite:Construct("Low-level C API Bindings")

local listOfScenarioFilesToLoad = {
    "./Bindings/export-llhttp-api.lua"
}

testSuite:AddScenarios(listOfScenarioFilesToLoad)

-- Return test suite instance as a Lua module
return testSuite