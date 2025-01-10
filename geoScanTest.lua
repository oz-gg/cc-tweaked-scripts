scanner = peripheral.find("geoScanner")
result = scanner.scan(5)

for i = 1, #result do
  print(result[i])
end