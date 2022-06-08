local testSuite = TestSuite:Construct("Low-level C Bindings")

local listOfScenarioFilesToLoad = {
    "./Bindings/export-llhttp-api.lua"
}

testSuite:AddScenarios(listOfScenarioFilesToLoad)

return testSuite