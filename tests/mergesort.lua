--!nocheck
--!nolint

local function sort(arr, temp, left, center, right)
	local j = center
	local i = left

	local read = i
	while i < center and j <= right do
		if arr[i] < arr[j] then
			temp[read] = arr[i]
			i = i + 1
		else
			temp[read] = arr[j]
			j = j + 1
		end

		read = read + 1
	end

	while i < center do
		temp[read] = arr[i]
		i = i + 1
		read = read + 1
	end

	while j <= right do
		temp[read] = arr[j]
		j = j + 1
		read = read + 1
	end

	-- clone
	table.move(temp, left, right, left, arr)
end

local function mergeSort(arr, temp, left, right)
	if left >= right then
		-- cant
		return
	end

	local center = math.floor((left + right) * 0.5)
	mergeSort(arr, temp, left, center)
	mergeSort(arr, temp, center + 1, right)

	sort(arr, temp, left, center + 1, right)
end

local function partition(arr, left, right)
	-- local index = math.random(left + 1, right)
	local index = right
	local pivot = arr[index]
	local i = left

	-- puts stuff less than the pivot on the lhs
	-- puts stuff greater than pivot on the rhs
	for j = left, right do
		if j ~= index and arr[j] <= pivot then
			-- swap
			if i == index then
				i = i + 1
			end

			arr[j], arr[i] = arr[i], arr[j]
			i = i + 1
		end
	end

	-- arr[i] >= pivot
	arr[i], arr[index] = arr[index], arr[i]
	return i
end

local function quicksort(arr, left, right)
	if right <= left or left < 0 then
		return
	end

	local index = partition(arr, left, right)

	-- arr[left:index] < pivot
	-- arr[index:] >= pivot
	quicksort(arr, left, index - 1)
	quicksort(arr, index + 1, right)
end

describe("Sorting", function()
	it("should merge sort", function()
		local arr = { 123, 1337, 32, 1, 2, 0, -1, 5 }
		mergeSort(arr, table.create(#arr), 1, #arr)

		for i = 1, #arr - 1 do
			expect(arr[i + 1] < arr[i]).to.equal(false)
		end
	end)

	it("should quick sort", function()
		local arr = { 123, 1337, 534, 1, 2, 0, -1, 5 }
		quicksort(arr, 1, #arr)
		for i = 1, #arr - 1 do
			expect(arr[i] <= arr[i + 1]).to.equal(true)
		end
	end)
end)