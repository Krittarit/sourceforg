-- loader.lua - ตัวโหลดหลัก
-- ใช้: loadstring(game:HttpGet('https://raw.githubusercontent.com/Krittarit/sourceforg/main/loader.lua'))()

print("🔄 Yield AI Loader Starting...")

-- Configuration
local CONFIG = {
    GITHUB_USER = "Krittarit",
    GITHUB_REPO = "sourceforg",
    BRANCH = "main",
    VERSION = "1.0.0"
}

-- Helper Functions
local function getURL(filename)
    return string.format(
        "https://raw.githubusercontent.com/%s/%s/%s/%s",
        CONFIG.GITHUB_USER,
        CONFIG.GITHUB_REPO,
        CONFIG.BRANCH,
        filename
    )
end

local function loadFromGitHub(filename)
    local success, result = pcall(function()
        local url = getURL(filename)
        local source = game:HttpGet(url)
        
        if source and source ~= "" then
            local func = loadstring(source)
            if func then
                return func()
            else
                error("Failed to compile: " .. filename)
            end
        else
            error("Empty or invalid source: " .. filename)
        end
    end)
    
    if success then
        print("✅ Loaded: " .. filename)
        return result
    else
        warn("❌ Failed to load " .. filename .. ": " .. tostring(result))
        return nil
    end
end

-- Anti-Detection (Optional)
local function randomDelay()
    wait(math.random(100, 500) / 1000) -- 0.1-0.5 วินาที
end

-- Main Loading Process
print("📦 Loading Yield AI v" .. CONFIG.VERSION)
randomDelay()

-- Check if already loaded
if _G.YieldAI_Loaded then
    warn("⚠️ Yield AI already loaded!")
    return
end

-- Check HTTP Service
if not game:GetService("HttpService").HttpEnabled then
    error("❌ HTTP requests are disabled! Enable them in Game Settings.")
end

-- Load main script
print("🚀 Loading main script...")
local YieldAI = loadFromGitHub("yield.lua")

if YieldAI then
    -- Mark as loaded
    _G.YieldAI_Loaded = true
    _G.YieldAI = YieldAI
    
    print("🎉 Yield AI loaded successfully!")
    print("📋 Version: " .. CONFIG.VERSION)
    print("🌐 Repository: https://github.com/" .. CONFIG.GITHUB_USER .. "/" .. CONFIG.GITHUB_REPO)
else
    error("❌ Failed to load Yield AI main script")
end