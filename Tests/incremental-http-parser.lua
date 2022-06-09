local testSuite = TestSuite:Construct("Incremental HTTP Parser")

local listOfScenarioFilesToLoad = {
    "./IncrementalHttpParser/basic-get-request.lua",
    "./IncrementalHttpParser/basic-response.lua"
}

testSuite:AddScenarios(listOfScenarioFilesToLoad)

return testSuite