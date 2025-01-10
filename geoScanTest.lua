scanner = peripheral.find("geoScanner")
print("enter tag to scan for")
tag = read()
result = scanner.scan(10)

function findInTable(v, table)
	for i, x in ipairs(table) do
		if x == v then return true end
	end
	return false
end

for i, v in pairs(result) do
	if findInTable(tag, v.tags) then
		print(v.name)
	end
end