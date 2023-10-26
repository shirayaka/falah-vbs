-- Copyright © 2018 Bohemia Interactive Simulations - support@BISimulations.com

-- @name table
-- @description Functions for table operations

return {
    ["tableExt"] = {
        -- @description Convert content of given table to string
		-- @argument someTable [table] table of entries
        -- @argument maxDepth [number|optional] depth of the debugging
        ["Dump"] = function(someTable, maxDepth)
		    maxDepth = maxDepth or 1
		    if type(someTable) == 'table' then
			    if (maxDepth == 0) then 
				    return "..." 
			    end
			    local s = '{ '
			    for k,v in (someTable.pairs or pairs)(someTable) do
				     s = s .. '[' .. tableExt.Dump(k, 0) .. '] = ' .. tableExt.Dump(v, maxDepth-1) .. ',\n'
			    end
			    return s .. '} '
		    elseif type(someTable) == 'string' then
			    return string.format("%q", someTable):gsub("\\\n", "\\n")
            else
                return tostring(someTable)
		    end
	    end,
        
		-- @description Return length of the given table
		-- @argument someTable [table] table of entries
		-- @return count [number] number of indexed and non-indexed entries in table
		["GetLength"] = function(someTable)
			local count = 0
			for _,_ in pairs(someTable) do count = count + 1 end
			return count
		end,

		-- @description Check if the given table is empty
		-- @argument someTable [table] table of entries
		-- @return result [boolean] false if the table contains at least one entry, otherwise true
		["IsEmpty"] = function(someTable)
			for _, _ in pairs(someTable) do
				return false
			end
			return true
		end,

		-- @description Return a new table that contains the same entries as someTable (ie. a shallow copy)
		-- @argument someTable [table] table of entries
		-- @return result [table]
		["ShallowCopy"] = function(someTable)
			local result = {}
			if type(someTable) == "InternalTable" then
				result = InternalTable()
			end

			for key, value in pairs(someTable) do
				result[key] = value
			end

			return result
		end,

        -- @description Merge n tables
		-- @argument target [table] source table which should be merged
		-- @argument ... [tables] tables we want to merge together into target
		-- @return target [table] does not make new table, returns first argument, unless first argument is nil
		["Extend"] = function(target, ...)
            if target == nil then target = {} end
			for _, source in pairs({...}) do
				for k, v in pairs(source) do
					target[k] = v
				end
			end
			return target
		end,

		-- @description subset of someTable satisfying given predicate
		-- @argument someTable [table] table of entries
		-- @argument selector [function(key,value)] predicate function that filter items
		-- @return result [table]
		["Filter"] = function(someTable, selector)
			local result = {}
			if type(someTable) == "InternalTable" then
				result = InternalTable()
			end

			for key, value in pairs(someTable) do
				if selector(key, value) == true then
					result[key] = value
				end
			end

			return result
		end,

		-- @description elements of someTable transformed by function
		-- @argument someTable [table] table of entries
		-- @argument transformFunction [function(key, value)] function that transforms items
		-- @return result [table] table of transformed elements
		["Transform"] = function(someTable, transformFunction)
			local result = {}
			if type(someTable) == "InternalTable" then
				result = InternalTable()
			end

			for key, value in pairs(someTable) do
				result[key] = transformFunction(key, value)
			end

			return result
		end,

		-- @description Check if all entries in a table satisfy a predicate
		-- @argument someTable [table] table of entries
		-- @argument predicate [function(key, value)] predicate function to check against
		-- @return result [boolean] false if any entry fails to satisfy the predicate, true otherwise
		["All"] = function(someTable, predicate)
			for key, value in pairs(someTable) do
				if not predicate(key, value) then
					return false
				end
			end
			return true
		end,

		-- @description Check if any entry in a table satisfies a predicate
		-- @argument someTable [table] table of entries
		-- @argument predicate [function(key, value)] predicate function to check against
		-- @return result [boolean] true if any entry satisfies the predicate, false otherwise
		["Any"] = function(someTable, predicate)
			for key, value in pairs(someTable) do
				if predicate(key, value) then
					return true
				end
			end
			return false
		end,

		-- @description Check if any entry in a table is equal to some value
		-- @argument someTable [table] table of entries
		-- @argument searchedValue [anything] value to search for
		-- @return result [boolean] true if any entry is equal to the value, false otherwise
		["Contains"] = function(someTable, searchedValue)
			return tableExt.Any(someTable, function(_, value) return value == searchedValue end)
		end,

		-- @description Find an entry that satisfies a predicate
		-- @argument someTable [table] table of entries
		-- @argument predicate [function(key, value)] predicate function to check against
		-- @return result [anything] a value that satisfies the predicate, or nil if no such value was found
		["Find"] = function(someTable, predicate)
			for key, value in pairs(someTable) do
				if predicate(key, value) then
					return value
				end
			end
			return nil
		end,
	},

	["array"] = {
        -- @description Check if all entries in an array satisfy a predicate
		-- @argument someArray [array] array of entries
		-- @argument predicate [function(value)] predicate function to check against
		-- @return result [boolean] false if any entry fails to satisfy the predicate, true otherwise
		["All"] = function(someArray, predicate)
			return tableExt.All(someArray,
				function (_, value)
					return predicate(value)
				end
			)
		end,
        
        -- @description Return the relative (set) complement of arrayTwo in arrayOne
		-- @argument arrayOne [array] table of entries to take elements from
		-- @argument arrayTwo [array] table of entries to take complement of
		-- @argument (optional) diffArray [array] array to append result into (new array is created if argument not present)
		-- @return diffArray [table] complement of arrayTwo in arrayOne (elements that are in arrayOne and not in arrayTwo) appended onto diffArray
		["RelativeComplement"] = function(arrayOne, arrayTwo, diffArray)
			diffArray = diffArray or {}

			for a=1, #arrayOne do
				local item = arrayOne[a]
				local unique = true
				-- future optimization : for types that are usable as keys, the linear search can be replaced with a table lookup
				for b=1, #arrayTwo do
					if (item == arrayTwo[b]) then
						unique = false
						break
					end
				end

				if (unique) then
					diffArray[#diffArray + 1] = item
				end
			end

			return diffArray
		end,

		-- @description Return the symmetric difference of two arrays
		-- @argument arrayOne [array] table of entries
		-- @argument arrayTwo [array] table of entries
		-- @return diffArray [table]
		["Diff"] = function(arrayOne, arrayTwo)
			local diffArray = {}

			diffArray = vbsCon.array.RelativeComplement(arrayOne, arrayTwo, diffArray)
			diffArray = vbsCon.array.RelativeComplement(arrayTwo, arrayOne, diffArray)

			return diffArray
		end,

		-- @description Return the intersection of two arrays
		-- @argument arrayOne [array] table of entries
		-- @argument arrayTwo [array] table of entries
		-- @return intersection [table] table of entries from arrayOne that are also contained in arrayTwo
		["Intersection"] = function(arrayOne, arrayTwo)
			local intersection = {}

			for a=1, #arrayOne do
				local item = arrayOne[a]
				for b=1, #arrayTwo do
					if (item == arrayTwo[b]) then
						intersection[#intersection + 1] = item
					end
				end
			end

			return intersection
		end,

		-- @description Remove all instances of given item from array
		-- @argument someArray [array] table of entries
		-- @return item [anything] item of any type which should be removed
		["Remove"] = function(someArray, item)
			local newArray = {}
			local newArrayCount = 0

			for i=1, #someArray do
				if (someArray[i] ~= item) then
					newArrayCount = newArrayCount + 1
					newArray[newArrayCount] = someArray[i]
				end
			end

			return newArray
		end,

		-- @description subset of someArray satisfying given predicate
		-- @argument someArray [array] table of entries
		-- @argument selector predicate function that filter items
		-- @return result [array]
		["Filter"] = function(someArray, selector)
			local result = {}

			for _, item in ipairs(someArray) do
				if selector(item) == true then
					result[#result + 1] = item
				end
			end

			return result
		end,

		-- @description Find an entry that satisfies a predicate
		-- @argument someArray [array] array of entries
		-- @argument predicate [function(value)] predicate function to check against
		-- @return result [anything] the first value that satisfies the predicate, or nil if no such value was found
		["Find"] = function(someArray, predicate)
			for _, item in ipairs(someArray) do
				if predicate(item) then
					return item
				end
			end
			return nil
		end,

		-- @description Combine an initial value sequentially with all values in an array and return result
		-- @argument someArray [array] arry of entries
		-- @argument initValue [anything] initial value to fold
		-- @argument foldFunction [function(prevValue, item)] folding function
		["Fold"] = function(someArray, initValue, foldFunction)
			for _, item in ipairs(someArray) do
				initValue = foldFunction(initValue, item)
			end

			return initValue
		end,

        -- @description Shift array indexes so the returned array starts at different index. Skipped elements are put in the same order at the end of shifted array.
		-- @argument someArray [array] arry of entries
		-- @argument shift [number] 0 <= shift < #someArray
        -- @return newArray [array] shifted array
		["Shift"] = function(someArray, shiftIndex)
            local shiftedArray = {}
            for i=shiftIndex, shiftIndex + #someArray -1 do
                local index = (i % #someArray) + 1
				shiftedArray[#shiftedArray + 1] = someArray[index]
			end

			return shiftedArray
		end,
    },
}