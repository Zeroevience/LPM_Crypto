local crypto = {}

local DEFAULT_CHARSET = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
local HEX = "0123456789abcdef"

local seeded = false

local function seed()
    if seeded then
        return
    end
    seeded = true

    local extra = tostring(os.clock()):gsub("%D", "")
    local t = tostring(tick and tick() or os.clock()):gsub("%D", "")
    local mix = tonumber((t .. extra):sub(1, 12)) or os.time()
    math.randomseed(mix)

    for _ = 1, 5 do
        math.random()
    end
end

local function randIndex(max)
    seed()
    return math.random(1, max)
end

function crypto.randomString(length, charset)
    assert(type(length) == "number" and length > 0, "randomString(length, charset): length must be > 0")
    charset = charset or DEFAULT_CHARSET
    assert(type(charset) == "string" and #charset > 0, "randomString(length, charset): charset must be a non-empty string")

    local out = table.create and table.create(length) or {}

    for i = 1, length do
        local idx = randIndex(#charset)
        out[i] = charset:sub(idx, idx)
    end

    return table.concat(out)
end

function crypto.randomBytes(length)
    assert(type(length) == "number" and length > 0, "randomBytes(length): length must be > 0")

    local out = table.create and table.create(length) or {}

    for i = 1, length do
        out[i] = string.char(math.random(0, 255))
    end

    return table.concat(out)
end

function crypto.randomHex(length)
    assert(type(length) == "number" and length > 0, "randomHex(length): length must be > 0")

    local out = table.create and table.create(length * 2) or {}

    for i = 1, length do
        local b = math.random(0, 255)
        local hi = math.floor(b / 16) + 1
        local lo = (b % 16) + 1
        out[#out + 1] = HEX:sub(hi, hi)
        out[#out + 1] = HEX:sub(lo, lo)
    end

    return table.concat(out)
end

function crypto.randomInt(min, max)
    assert(type(min) == "number" and type(max) == "number", "randomInt(min, max): min/max must be numbers")
    assert(min <= max, "randomInt(min, max): min must be <= max")
    seed()
    return math.random(min, max)
end

function crypto.uuid()
    local template = "xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx"

    return (template:gsub("[xy]", function(c)
        local v = math.random(0, 15)
        if c == "y" then
            v = math.random(8, 11)
        end
        return string.format("%x", v)
    end))
end

function crypto.randomCode(length)
    return crypto.randomString(length, "ABCDEFGHIJKLMNOPQRSTUVWXYZ")
end

function crypto.randomCodeSafe(length)
    return crypto.randomString(length, "ABCDEFGHJKLMNPQRSTUVWXYZ23456789")
end

return crypto
