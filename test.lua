print("Running all tests...\n")

-- Expose globally because I'm too lazy to import it in every test file
local llhttp = import("llhttp.lua")
_G.llhttp = llhttp

import("Tests/test-api-surface.lua")
import("Tests/API/test-create.lua")
import("Tests/API/test-execute-basic.lua")
import("Tests/API/test-execute-upgrade-multivalue.lua")
import("Tests/API/test-execute-websockets-upgrade.lua")

print("\nAll tests completed!")