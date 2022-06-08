-- Expose globally because I'm too lazy to import it in every test file
local llhttp = import("llhttp.lua")
_G.llhttp = llhttp

local testSuites = {
	"Tests/c-api-bindings.lua",
	"Tests/incremental-http-parser.lua"
}

for _, filePath in pairs(testSuites) do
	local testSuite = import(filePath)
	-- For CI pipelines and scripts, ensure the return code indicates EXIT_FAILURE if at least one assertion has failed
	assert(testSuite:Run(), "Assertion failure in test suite " .. filePath)
end

import("Tests/API/test-create.lua")
import("Tests/API/test-execute-basic.lua")
import("Tests/API/test-execute-upgrade-multivalue.lua")
import("Tests/API/test-execute-websockets-upgrade.lua")

print("\nAll tests completed!")