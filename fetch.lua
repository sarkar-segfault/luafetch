local user = os.getenv("USERNAME") or os.getenv("USER") or "unknown"
local host = os.getenv("HOSTNAME") or os.getenv("COMPUTERNAME") or "unknown"
local machine = user .. "@" .. host

local is_unix = true
if package.config:sub(1, 1) == "\\" then
  is_unix = false
end

local cmd = "powershell -Command \"(Get-CimInstance Win32_OperatingSystem).Caption\""
if is_unix then
  cmd = "uname -o"
end

local pipe, err = io.popen(cmd)
if not pipe then
  print(err)
  os.exit(1)
end

local system = pipe:read("*a")
if not system then
  print(string.format("failed to read pipe from io.popen(\"%s\")", cmd))
  os.exit(1)
end

local date = os.date("%Y/%m/%d %H:%M:%S")

local colors = {
  31,
  32,
  33,
  34,
  35,
  36,
  91,
  92,
  93,
  94,
  95,
  96
}

local text =
  "\\    /\\     " .. machine .. "\n" ..
  " )  ( ')    " .. string.rep("-", #machine) .. "\n" ..
  " (  /  )    " .. system:gsub("\n", "") .. "\n" ..
  "  \\(__)|    " .. date

math.randomseed(os.time())

for i = 1, #text do
  local char = string.sub(text, i, i)
  local color = "\27[" .. tostring(colors[math.random(#colors)]) .. "m"
  io.write(color .. char)
end

print("\27[0m")
