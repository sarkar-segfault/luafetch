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
    "\27[31m",
    "\27[32m",
    "\27[33m",
    "\27[34m",
    "\27[35m",
    "\27[36m",
    "\27[37m",
}

local text =
  "\\    /\\     " .. machine .. "\n" ..
  " )  ( ')    " .. string.rep("-", #machine) .. "\n" ..
  " (  /  )    " .. system:gsub("\n", "") .. "\n" ..
  "  \\(__)|    " .. date

math.randomseed(os.time())

for i = 1, #text do
  local char = string.sub(text, i, i)
  local color = colors[math.random(#colors)]
  io.write(color .. char)
end

print("\27[0m")
