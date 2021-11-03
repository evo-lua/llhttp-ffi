print("Running all tests...\n")

-- Expose globally because I'm too lazy to import it in every test file
local llhttp = import("../llhttp.lua")
_G.llhttp = llhttp

import("test-api-surface.lua")
import("API/test-create.lua")
import("API/test-execute-basic.lua")
import("API/test-execute-upgrade-multivalue.lua")
import("API/test-execute-websockets-upgrade.lua")

print("\nAll tests completed!")