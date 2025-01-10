scanner = peripheral.find("geoScanner")
result = scanner.scan(10)

for i, v in pairs(result) do
	print(v.name.." ")
end