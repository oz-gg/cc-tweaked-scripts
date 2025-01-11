FILTER_TAG = "forge:ores"
SCAN_RADIUS = 8

function stringInTable(v, t)
	for i, x in ipairs(t) do
		if string.find(x, v, 1, true) then return true end
	end
	return false
end

function scrollData(data, pageSize, page)
    term.clear()
    term.setCursorPos(1, 1)

    page = page or 1

    local pageCount = math.ceil(#data / pageSize)

    local startIndex = (page - 1) * pageSize + 1
    local endIndex = math.min(startIndex + pageSize - 1, #data)

    print("Page: " .. page .. " of " .. pageCount)
    print("[a] < | [s] exit | [d] >\n")

    for i = startIndex, endIndex do
        print(data[i])
    end

    local badKey = true
    while badKey do
        local event, key = os.pullEvent("key")

        if key == keys.a then
            badKey = false
            if page > 1 then
                scrollData(data, pageSize, page - 1)
            end
        elseif key == keys.d then
            badKey = false
            if page < pageCount then
                scrollData(data, pageSize, page + 1)
            end
        elseif key == keys.s then
            badKey = false
            return
        end
    end
end

function analyze()
	term.clear()
	term.setCursorPos(1, 1)
	result, err = scanner.chunkAnalyze()
	if result ~= nil then
		ores = {}
		for i, v in ipairs(result) do
			table.insert(ores, i..": "..v)
		end
		scrollData(ores, 7)
	end
end

function radar()
	local w, h = term.getSize()
	local sx, sy = math.floor(w / 2), math.floor(h / 2)

	continueRadar = true
	elevationStep = false
	while continueRadar do
		--reset color
		paintutils.drawPixel(1, 1, colors.black)
		term.clear()

		--print north
		term.setCursorPos(sx, 2)
		print("N")

		--print south
		term.setCursorPos(sx, h)
		print("S")

		--print west
		term.setCursorPos(1, sy)
		print("W")

		--print east
		term.setCursorPos(w, sy)
		print("E")

		--center
		paintutils.drawPixel(sx, sy, colors.gray)

		local scanResult, err = scanner.scan(SCAN_RADIUS)

		if not scanResult then
			paintutils.drawPixel(3, 3, colors.red)
			term.setCursorPos(3, 3)
			print("Scan Error: "..err.."\n")
		else
			local noOreFound = true
			for i, data in ipairs(scanResult) do
				if data.name and data.x and data.x and data.z and data.tags then
					if stringInTable(FILTER_TAG, data.tags) then
						local oreX = sx + data.x
						local oreY = sy + data.z

						local outOfRange = (oreX < 1) or (oreX > w) or (oreY < 1) or (oreY > h)

						if not outOfRange then
							local pixelColor = colors.cyan
							if data.y > 0 then
								pixelColor = colors.lime
							elseif data.y < 0 then
								pixelColor = colors.orange
							end

							paintutils.drawPixel(oreX, oreY, pixelColor)

							term.setCursorPos(oreX, oreY)
							if elevationStep then
								print(math.abs(data.y))
							else
								if data.y > 0 then
									print("+")
								elseif data.y < 0 then
									print("-")
								else
									print("=")
								end
							end
						end
					end
				end
			end
		end
		elevationStep = not elevationStep
		os.sleep(2)
	end
end

scanner = peripheral.find("geoScanner")

continueOperation = true
while continueOperation do
	term.clear()
	term.setCursorPos(1, 1)
	print("currently looking for:\n"..FILTER_TAG.."\n")
	print("[a] analyze chunk")
	print("[r] radar")
	print("[s] change scan radius")
	print("[x] change target tag")
	print("[q] quit")

	local event, key = os.pullEvent("key")

	if key == keys.a then
		analyze()
	elseif key == keys.r then
		radar()
	elseif key == keys.s then
		term.clear()
		term.setCursorPos(1, 1)
		print("change scan radius ("..SCAN_RADIUS..") to (1-9) :")
		SCAN_RADIUS = math.min(math.max(tonumber(read()), 1), 9) or 8
	elseif key == keys.x then
		term.clear()
		term.setCursorPos(1, 1)
		print("change target tag "..FILTER_TAG.." to:")
		FILTER_TAG = read()
	elseif key == keys.q then
		continueOperation = false
	end
end