local user = os.getenv("USERNAME") or os.getenv("USER") or "unknown"
local host = os.getenv("COMPUTERNAME") or os.getenv("HOSTNAME") or "unknown"
local machine = user .. "@" .. host

local sep = package.config:sub(1, 1)
local is_unix = true

if sep == "\\" then
  is_unix = false
end

local os_ = ""
local kernel = ""

if is_unix then
  os_ = io.popen("uname -o"):read("*a")
  kernel = io.popen("uname -s"):read("*a")
else
  os_ = io.popen("ver"):read("*a")
  kernel = os.getenv("OS") or os_
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
  " )  ( ')    " .. os_:gsub("\n", "") .. "\n" ..
  " (  /  )    " .. kernel:gsub("\n", "") .. "\n" ..
  "  \\(__)|    " .. date

math.randomseed(os.time())

for i = 1, #text do
  local char = string.sub(text, i, i)
  local color = colors[math.random(#colors)]
  io.write(color .. char)
end

print("\27[0m")
