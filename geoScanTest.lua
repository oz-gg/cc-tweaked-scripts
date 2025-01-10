FILTER_TAG = "forge:ores"

function stringInTable(v, t)
	for i, x in ipairs(t) do
		if string.find(x, v, 1, true) then return true end
	end
	return false
end

function analyze(tag)
	term.clear()
	result, err = scanner.analyzeChunk()
	if result ~= nil then
		ores = {}
		for i, v in pairs(result) do
			if stringInTable(tag, v.tags) then
				if not ores[v.name] then ores[v.name] = 1 else
				ores[v.name] = ores[v.name] + 1 end
			end
		end

		for i, v in pairs(ores) do
			print(i..": "..v)
		end
	end
	print("press enter to go back...")
	read()
end

scanner = peripheral.find("geoScanner")

continueOperation = true
while continueOperation do
	term.clear()
	print("[a] analyze chunk")
	print("[x] change target tag")
	print("[q] quit")
	local event, key = os.pullEvent("key")

	if key == "a" then
		analyze()
	elseif key == "x" then
		term.clear()
		print("change target tag "..FILTER_TAG.." to:")
		FILTER_TAG = read()
	elseif key == "q" then
		continueOperation = false
	end
end