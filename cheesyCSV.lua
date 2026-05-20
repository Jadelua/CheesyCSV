local cheesyCSV = {}

local csvTable = {
  Headers = {},
  Data = {}
}

function cheesyCSV.parseValue(value)
  value = value:gsub("^%s+", ""):gsub("%s+$", "")
  
  if value == "true" then
    return true
  elseif value == "false" then
    return false
  end
  
  if value == "nil" then
    return nil
  end
  
  local num = tonumber(value)
  if num then
    return num
  end
  
  if value:sub(1, 1) == "{" and value:sub(-1) == "}" then
    local tbl = {}
    
    local content = value:sub(2, -2)
    
    for item in content:gmatch("[^,]+") do
      item = item:gsub("^%s+", ""):gsub("%s+$", "")
      table.insert(tbl, cheesyCSV.parseValue(item))
    end
    
    return tbl
  end
  
  return value
end

function cheesyCSV.cleanTable()
  csvTable = {
    Headers = {},
    Data = {}
  }
end

function cheesyCSV.parse(csvString)
  if csvString:sub(-1) ~= "\n" then
    csvString = csvString .. "\n"
  end
  
  if next(csvTable.Headers) ~= nil or next(csvTable.Data) ~= nil then
    cheesyCSV.cleanTable()
  end
  
  local lineString = ""
  local newLineCount = 0
  
  for c in csvString:gmatch(".") do
    if c == "\n" then
      lineString = lineString .. c
      newLineCount = newLineCount + 1
      
      if newLineCount <= 1 then
        local currentHeader = ""
        
        for l in lineString:gmatch(".") do
          if l ~= "," then
            if l == "\n" then
              table.insert(csvTable.Headers, currentHeader)
              csvTable[currentHeader] = {}
              currentHeader = ""
              break
            end
            currentHeader = currentHeader .. l
          else
            table.insert(csvTable.Headers, currentHeader)
            csvTable[currentHeader] = {}
            currentHeader = ""
          end
        end
      else
        local currentValue = ""
        table.insert(csvTable.Data, {})
        local currentTable = csvTable.Data[newLineCount - 1]
              
        for l in lineString:gmatch(".") do
          if l ~= "\n" and l ~= "," then
            currentValue = currentValue .. l
          else
            table.insert(currentTable, cheesyCSV.parseValue(currentValue))
            currentValue = ""
          end
        end
      end
      lineString = ""
    else
      lineString = lineString .. c
    end
  end
  
  newLineCount = 0
end

function cheesyCSV.getTable()
  return csvTable
end

return cheesyCSV
