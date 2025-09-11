--!strict

-- Used to read and write bytecode
-- magicoal_nerb :D

local Buffer = {}
Buffer.__index = Buffer

export type Buffer = typeof(setmetatable({} :: {
	cursor: number,
	size: number,
	data: buffer,
}, Buffer))

function Buffer.newBuffer()
	return setmetatable({
		-- create an empty 16 byte buffer
		-- incase
		size = 16,
		data = buffer.create(16),
		cursor = 0,
	}, Buffer)
end

function Buffer.fromBuffer(data: buffer)
	return setmetatable({
		-- size doesnt matter because
		-- we'll be reading this
		size = buffer.len(data),
		data = data,
		cursor = 0,
	}, Buffer)
end

function Buffer.getData(self: Buffer): buffer
	-- returns the raw buffer object
	local data = buffer.create(self.cursor + 1)
	buffer.copy(data, 0, self.data, 0, self.cursor + 1)
	return data
end

function Buffer.allocate(self: Buffer, bytes: number)
	if self.cursor + bytes < self.size then
		-- no need to resize in this case
		return
	end

	-- recreate the previous buffer but
	-- with double the size
	local newSize = self.size * 2
	local newData = buffer.create(newSize)
	buffer.copy(newData, 0, self.data)

	self.data = newData
	self.size = newSize
end

function Buffer.writeu8(self: Buffer, num: number)
	-- unsigned char
	self:allocate(1)
	buffer.writeu8(self.data, self.cursor, num)
	self.cursor += 1
end

function Buffer.writeu32(self: Buffer, num: number)
	-- unsigned int
	self:allocate(4)
	buffer.writeu32(self.data, self.cursor, num)
	self.cursor += 4
end

function Buffer.writef64(self: Buffer, num: number)
	-- double
	self:allocate(8)
	buffer.writef64(self.data, self.cursor, num)
	self.cursor += 8
end

function Buffer.writestring(self: Buffer, str: string)
	-- string
	local len = #str
	self:allocate(len + 1)
	buffer.writestring(self.data, self.cursor, str, len)
	buffer.writeu8(self.data, self.cursor + 1 + len, 0)
	self.cursor += len + 2
end

function Buffer.readu8(self: Buffer): number
	-- read unsigned char
	self.cursor += 1
	return buffer.readu8(self.data, self.cursor - 1)
end

function Buffer.readu32(self: Buffer): number
	-- read unsigned int
	self.cursor += 4
	return buffer.readu32(self.data, self.cursor - 4)
end

function Buffer.readf64(self: Buffer): number
	-- read float
	self.cursor += 8
	return buffer.readf64(self.data, self.cursor - 8)
end

function Buffer.readstring(self: Buffer): string
	-- read string
	local start = self.cursor
	local finish = start
	while finish < self.size and buffer.readu8(self.data, finish) ~= 0 do
		finish += 1
	end

	self.cursor = finish + 2
	return buffer.readstring(
		self.data,
		start,
		finish - start
	)
end

return Buffer