scanenr = peripheral.find("geoScanner")
result = scanner.scan(5)

for i, v in ipairs(result) do
  print(v)
end
