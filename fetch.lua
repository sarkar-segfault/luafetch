local user = os.getenv("USERNAME") or os.getenv("USER") or "<unknown>"
local host = os.getenv("HOSTNAME") or os.getenv("COMPUTERNAME") or "<unknown>"
local machine = user .. "@" .. host
local sepline = string.rep("-", #machine)

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
local coloring = "all"

for i, v in ipairs(arg) do
  if v == "--all" then
    coloring = "all"
  elseif v == "--none" then
    coloring = "none"
  elseif v == "--normal" then
    coloring = "normal"
  elseif v == "--bright" then
    coloring = "bright"
  elseif v == "--no-machine" then
    machine = ""
  elseif v == "--no-system" then
    system = ""
  elseif v == "--no-date" then
    date = ""
  elseif v == "--no-sepline" then
    sepline = ""
  elseif v == "--help" then
    print("--help prints this")
    print("--all uses all colors")
    print("--none uses no colors")
    print("--normal uses normal colors")
    print("--bright uses bright colors")
    print("--no-machine disables printing user@host")
    print("--no-system disables printing the system info")
    print("--no-date disables printing time and date info")
    print("--no-sepline disables the seperating line between machine and system+date")
    os.exit(0)
  else
    print("encountered invalid argument: ", v)
    os.exit(1)
  end
end

local colors = {}

if coloring == "all" or coloring == "normal" then
  table.insert(colors, "31")
  table.insert(colors, "32")
  table.insert(colors, "33")
  table.insert(colors, "34")
  table.insert(colors, "35")
  table.insert(colors, "36")
elseif coloring == "all" or coloring == "bright" then
  table.insert(colors, "91")  
  table.insert(colors, "92")  
  table.insert(colors, "93")  
  table.insert(colors, "94")  
  table.insert(colors, "95")  
  table.insert(colors, "96")  
end

local text =
  "\\    /\\     " .. machine .. "\n" ..
  " )  ( ')    " .. sepline .. "\n" ..
  " (  /  )    " .. system:gsub("\n", "") .. "\n" ..
  "  \\(__)|    " .. date

if coloring ~= "none" then
  math.randomseed(os.time())
end

for i = 1, #text do
  local char = string.sub(text, i, i)
  local color = ""
  if coloring ~= "none" then
    color = "\27[" .. colors[math.random(#colors)] .. "m"
  end
  io.write(color .. char)
end

if coloring ~= "none" then
  print("\27[0m")
end
