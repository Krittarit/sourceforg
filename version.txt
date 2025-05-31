-- version.lua - ระบบจัดการเวอร์ชั่น
local VersionManager = {}
VersionManager.currentVersion = "1.0.0"
VersionManager.github = {
    user = "Krittarit",
    repo = "sourceforg", 
    branch = "main"
}

function VersionManager:getLatestVersion()
    local url = string.format(
        "https://raw.githubusercontent.com/%s/%s/%s/version.txt",
        self.github.user,
        self.github.repo, 
        self.github.branch
    )
    
    local success, version = pcall(function()
        return game:HttpGet(url):gsub("%s+", "")
    end)
    
    return success and version or nil
end

function VersionManager:needsUpdate()
    local latest = self:getLatestVersion()
    if not latest then return false end
    
    return latest ~= self.currentVersion
end

function VersionManager:loadScript(filename)
    local url = string.format(
        "https://raw.githubusercontent.com/%s/%s/%s/%s",
        self.github.user,
        self.github.repo,
        self.github.branch,
        filename
    )
    
    local success, result = pcall(function()
        local source = game:HttpGet(url)
        return loadstring(source)()
    end)
    
    if success then
        print("✅ Loaded: " .. filename)
        return result
    else
        warn("❌ Failed to load: " .. filename .. " - " .. tostring(result))
        return nil
    end
end

function VersionManager:autoUpdate()
    if self:needsUpdate() then
        local latest = self:getLatestVersion()
        print("🔄 Updating from v" .. self.currentVersion .. " to v" .. latest)
        
        -- โหลดเวอร์ชั่นใหม่
        return self:loadScript("yield.lua")
    else
        print("✅ Already up to date (v" .. self.currentVersion .. ")")
        return self:loadScript("yield.lua")
    end
end

-- ตัวอย่างการใช้งาน
-- loadstring(game:HttpGet('https://raw.githubusercontent.com/Krittarit/sourceforg/main/loader.lua'))()

return VersionManager