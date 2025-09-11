--!nocheck
--!nolint

-- PriorityQueue.lua
-- me when the queue is my priority
-- also made with lectures from mit ocw
-- magicoal_nerb/poopbarrel

local PriorityQueue = {}
PriorityQueue.__index = PriorityQueue

function PriorityQueue.new(compare, data)
	local self = setmetatable({
		compare = compare,
		data = {},
		count = 0,
	}, PriorityQueue)
	
	if data then
		self:bulk(data)
	end
	
	return self
end

function PriorityQueue.bulk(self, data)
	-- Import an entire array onto our priority queue in linear
	-- time
	local count = #data
	self.count = count
	self.data = data
	
	for i = count, 1, -1 do
		self:heapifyDown(i)
	end
end

function PriorityQueue.heapifyUp(self, id)
	-- Satisfies the heap property bottom-up
	local compare = self.compare
	local data = self.data
	
	while id > 0 do
		local parent = math.floor(id * 0.5)
		if parent > 0 and compare(data[parent], data[id]) then
			-- Swap because the max-heap property was violated
			data[parent], data[id] = data[id], data[parent]
			id = parent
		else
			break
		end
	end
end

function PriorityQueue.heapifyDown(self, id)
	-- Satisfies the heap property top-down. Assumes that most of the heap
	-- already satisfies the property
	local compare = self.compare
	local count = self.count
	local data = self.data

	while id <= count do
		local right = data[2*id + 1]
		local left = data[2*id]

		if left or right then
			-- We have a branch
			local sibling
			if not left then
				sibling = 2*id + 1
			elseif not right then
				sibling = 2*id
			else
				sibling = compare(left, right)
					and 2*id + 1 or 2*id
			end

			if compare(data[id], data[sibling]) then
				-- Swap because max heap property was violated
				data[sibling], data[id] = data[id], data[sibling]
				id = sibling
			else
				break
			end		
		else
			-- We reached a leaf node
			break
		end
	end
end

function PriorityQueue.empty(self)
	-- Utility function to make usage cleaner
	return self.count <= 0
end

function PriorityQueue.insert(self, value)
	-- Place the element at the end of the array
	table.insert(self.data, value)
	
	-- Then ensure that the heap property
	-- is satisfied
	self.count = self.count + 1
	self:heapifyUp(self.count)
end

function PriorityQueue.delete(self)
	assert(self.count > 0)
	
	-- Swap between the maximum and the last element
	local data = self.data
	data[1], data[self.count] = data[self.count], data[1]
	
	-- Delete last element in array
	local pop = table.remove(data)
	self.count = self.count - 1
	
	self:heapifyDown(1)
	return pop
end

describe("PriorityQueue", function()
	it("should properly be descending", function()
		local pq = PriorityQueue.new(function(a, b)
			return a < b
		end, { 1, 3, 2, 5, 9, 8, 10 })

		local previous
		while not pq:empty() do
			if not previous then
				previous = pq:delete()
			else
				local current = pq:delete()
				expect(previous >= current).to.equal(true)
			end
		end
	end)
end)