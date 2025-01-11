FILTER_TAG = "forge:ores"

function stringInTable(v, t)
	for i, x in ipairs(t) do
		if string.find(x, v, 1, true) then return true end
	end
	return false
end

function analyze(tag)
	term.clear()
	term.setCursorPos(1, 1)
	result, err = scanner.chunkAnalyze()
	if result ~= nil then
		for i, v in pairs(result) do
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
	term.setCursorPos(1, 1)
	print("[a] analyze chunk")
	print("[x] change target tag")
	print("[q] quit")

	local event, key = os.pullEvent("key")

	if key == keys.a then
		analyze()
	elseif key == keys.x then
		term.clear()
		term.setCursorPos(1, 1)
		print("change target tag "..FILTER_TAG.." to:")
		FILTER_TAG = read()
	elseif key == keys.q then
		continueOperation = false
	end
end