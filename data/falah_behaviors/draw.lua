-- Copyright © 2017 Bohemia Interactive Simulations - support@BISimulations.com

-- @name draw
-- @author Martin Sochor
-- @description Functions for drawing primitives using DebugLine

return {
	["draw"] = {
		-- @description Draw a colored line
		-- @argument from [Vec3] start point of the line
		-- @argument to [Vec3] end point of the line
		-- @argument r [number] red component from 0 to 1
		-- @argument g [number] green component from 0 to 1
		-- @argument b [number] blue component from 0 to 1
		-- @argument a [number] alpha component from 0 to 1
		["Line"] = function(from, to, r, g, b, a)
			DebugLine(from, to, r, g, b, a)
		end,

		-- @description Draw a flat colored circle
		-- @argument center [Vec3] center of the circle
		-- @argument radius [number] non-negative radius of the circle
		-- @argument r [number] red component from 0 to 1
		-- @argument g [number] green component from 0 to 1
		-- @argument b [number] blue component from 0 to 1
		-- @argument a [number] alpha component from 0 to 1
		["Circle"] = function(center, radius, r, g, b, a)
			-- Subdivide the circle so that each segment is no more than 2 meters long
			local circleSegmentLength = 2
			local n = math.max(36, 2 * math.pi * radius / circleSegmentLength)
			local alpha = 360 / n
			for i = 1, n do
				draw.Line(center + radius * MathExt.HeadingToVec3((i - 1) * alpha), center + radius * MathExt.HeadingToVec3(i * alpha), r, g, b, a)
			end
		end,

		-- @description Draw a cubic Bezier curve
		-- @argument p0 [Vec3] first control point (start point)
		-- @argument p1 [Vec3] second control point (the curve will start out heading towards p1)
		-- @argument p2 [Vec3] third control point (the curve will end heading from p2)
		-- @argument p3 [Vec3] fourth control point (end point)
		-- @argument n [number] number of line segment to subdivide the curve to
		-- @argument r [number] red component from 0 to 1
		-- @argument g [number] green component from 0 to 1
		-- @argument b [number] blue component from 0 to 1
		-- @argument a [number] alpha component from 0 to 1
		["Bezier"] = function(p0, p1, p2, p3, n, r, g, b, a)
			local p = p0
			for i = 1, n do
				local t = i / n
				local pNext = ((1 - t)^3) * p0 + 3 * t * ((1 - t)^2) * p1 + 3 * (t^2) * (1 - t) * p2 + (t^3) * p3
				draw.Line(p, pNext, r, g, b, a)
				p = pNext
			end
		end,

        -- @description Draw a polyline based on path
		-- @argument path [path] array of polygon vertices
		-- @argument r [number] red component from 0 to 1
		-- @argument g [number] green component from 0 to 1
		-- @argument b [number] blue component from 0 to 1
		-- @argument a [number] alpha component from 0 to 1
        -- @argument offset [Vec3|optional] relative offset vector for each vertice
	    ["Path"] = function(path, r, g, b, a, offset)
            if offset == nil then offset = Vec3(0,0,0) end
            local segmentCount = path:GetSegmentCount()
			local points = {}
			for i = 0, segmentCount-1 do
				points[i+1] = path:GetSegmentStart(i)
			end
            points[#points+1] = path:GetSegmentEnd(segmentCount-1)
            draw.PolylineOnSurface(points,r, g, b, a, offset)
		end,

		-- @description Draw a closed polygon
		-- @argument points [array] array of polygon vertices or real polygon data type
		-- @argument r [number] red component from 0 to 1
		-- @argument g [number] green component from 0 to 1
		-- @argument b [number] blue component from 0 to 1
		-- @argument a [number] alpha component from 0 to 1
		["Polygon"] = function(points, r, g, b, a)
            if points.Count ~= nil then -- its Polygon data type
                for i = 1, points:Count() - 1 do
                    draw.Line(points:Vertex(i), points:Vertex(i + 1), 1, 1, 1)
                end
            else
			    local p = points[#points]
			    for i = 1, #points do
				    local pNext = points[i]
				    draw.Line(p, pNext, r, g, b, a)
				    p = pNext
			    end
            end
		end,

        -- @description Draw a closed polygon with vertices on nearest surface
		-- @argument points [array] array of polygon vertices
        -- @argument r [number] red component from 0 to 1
		-- @argument g [number] green component from 0 to 1
		-- @argument b [number] blue component from 0 to 1
		-- @argument a [number] alpha component from 0 to 1
        -- @argument offset [Vec3|optional] relative offset vector for each vertice
		["PolygonOnSurface"] = function(points, r, g, b, a, offset)
            if offset == nil then offset = Vec3(0,0,0) end
            local newPoints = {}
			if points.Count ~= nil then -- its Polygon data type
                for i = 1, points:Count() do
                    newPoints[i] = GetSurfacePosition(points:Vertex(i)) + offset
                end
            else
                for i = 1, #points do
				    newPoints[i] = GetSurfacePosition(points[i]) + offset
			    end
            end
            draw.Polygon(newPoints, r, g, b, a)
		end,

        -- @description Draw a polyline with vertices on nearest surface
		-- @argument points [array] array of polyline vertices
        -- @argument r [number] red component from 0 to 1
		-- @argument g [number] green component from 0 to 1
		-- @argument b [number] blue component from 0 to 1
		-- @argument a [number] alpha component from 0 to 1
        -- @argument offset [Vec3|optional] relative offset vector for each vertice
		["PolylineOnSurface"] = function(points, r, g, b, a, offset)
            if offset == nil then offset = Vec3(0,0,0) end
			for i = 1, #points do
				points[i] = GetSurfacePosition(points[i]) + offset
			end
            for i = 1, #points-1 do
				draw.Line(points[i], points[i+1], r, g, b, a)
			end            
		end,

        -- @description Draw a polyline with vertices on nearest surface
		-- @argument center [Vec3] array of polyline vertices
        -- @argument r [number] red component from 0 to 1
		-- @argument g [number] green component from 0 to 1
		-- @argument b [number] blue component from 0 to 1
        -- @argument offset [Vec3|optional] relative offset vector for each vertice
		["SpotMarkerOnSurface"] = function(center, r, g, b, offset, intensity, radius)
            if offset == nil then offset = Vec3(0,0,0) end
            if intensity == nil then intensity = 8 end
            if radius == nil then radius = intensity + 2 end
            local centerSurface = GetSurfacePosition(center)
            for i=1, intensity do
                draw.Circle(centerSurface + offset, radius+i, r, g, b, 1-i/radius)
            end          
		end,

        -- @description Draw a number digit by digit
        -- @argument number [number] array of polyline vertices
        -- @argument position [Vec3] array of polyline vertices
        -- @argument r [number] red component from 0 to 1
        -- @argument g [number] green component from 0 to 1
		-- @argument b [number] blue component from 0 to 1
		-- @argument a [number] alpha component from 0 to 1
        -- @argument scale [number] multiplier of unit vectors used for drawing
		["Number"] = function(number, position, r, g, b, a, scale)
            if scale == nil then scale = 1 end
            local numberInString = tostring(number)
            for i = 1, #numberInString do
                local c = numberInString:sub(i,i)
                draw.Digit(c, position + Vec3((i-1)*1.5*scale,0,0), r, g, b, a, scale)
            end
		end,

        -- @description Draw one digit using draw lines
        -- @argument number [number] array of polyline vertices
        -- @argument position [Vec3] array of polyline vertices
        -- @argument r [number] red component from 0 to 1
        -- @argument g [number] green component from 0 to 1
		-- @argument b [number] blue component from 0 to 1
		-- @argument a [number] alpha component from 0 to 1
        -- @argument scale [number] multiplier of unit vectors used for drawing
        ["Digit"] = function(number, position, r, g, b, a, scale)
            if scale == nil then scale = 1 end
            local digits = {
                ["0"] = function(position, r, g, b, a, scale)
                    draw.Line(position + Vec3(0,0,2*scale), position + Vec3(scale,0,2*scale), r, g, b, a) -- top
                    draw.Line(position + Vec3(0,0,scale), position + Vec3(0,0,2*scale), r, g, b, a) -- topLeft
                    draw.Line(position + Vec3(scale,0,scale), position + Vec3(scale,0,2*scale), r, g, b, a) -- topRight
                    draw.Line(position, position + Vec3(0,0,scale), r, g, b, a) -- bottomLeft
                    draw.Line(position + Vec3(scale,0,0), position + Vec3(scale,0,scale), r, g, b, a) -- bottomRight
                    draw.Line(position, position + Vec3(scale,0,0), r, g, b, a) -- bottom
                end,
                ["1"] = function(position, r, g, b, a, scale)
                    draw.Line(position + Vec3(scale,0,scale), position + Vec3(scale,0,2*scale), r, g, b, a) -- topRight
                    draw.Line(position + Vec3(scale,0,0), position + Vec3(scale,0,scale), r, g, b, a) -- bottomRight
                end,
                ["2"] = function(position, r, g, b, a, scale)
                    draw.Line(position + Vec3(0,0,2*scale), position + Vec3(scale,0,2*scale), r, g, b, a) -- top
                    draw.Line(position + Vec3(scale,0,scale), position + Vec3(scale,0,2*scale), r, g, b, a) -- topRight
                    draw.Line(position + Vec3(0,0,scale), position + Vec3(scale,0,scale), r, g, b, a) -- middle
                    draw.Line(position, position + Vec3(0,0,scale), r, g, b, a) -- bottomLeft
                    draw.Line(position, position + Vec3(scale,0,0), r, g, b, a) -- bottom
                end,
                ["3"] = function(position, r, g, b, a, scale)
                    draw.Line(position + Vec3(0,0,2*scale), position + Vec3(scale,0,2*scale), r, g, b, a) -- top
                    draw.Line(position + Vec3(scale,0,scale), position + Vec3(scale,0,2*scale), r, g, b, a) -- topRight
                    draw.Line(position + Vec3(0,0,scale), position + Vec3(scale,0,scale), r, g, b, a) -- middle
                    draw.Line(position + Vec3(scale,0,0), position + Vec3(scale,0,scale), r, g, b, a) -- bottomRight
                    draw.Line(position, position + Vec3(scale,0,0), r, g, b, a) -- bottom
                end,
                ["4"] = function(position, r, g, b, a, scale)
                    draw.Line(position + Vec3(0,0,scale), position + Vec3(0,0,2*scale), r, g, b, a) -- topLeft
                    draw.Line(position + Vec3(scale,0,scale), position + Vec3(scale,0,2*scale), r, g, b, a) -- topRight
                    draw.Line(position + Vec3(0,0,scale), position + Vec3(scale,0,scale), r, g, b, a) -- middle
                    draw.Line(position + Vec3(scale,0,0), position + Vec3(scale,0,scale), r, g, b, a) -- bottomRight
                end,
                ["5"] = function(position, r, g, b, a, scale)
                    draw.Line(position + Vec3(0,0,2*scale), position + Vec3(scale,0,2*scale), r, g, b, a) -- top
                    draw.Line(position + Vec3(0,0,scale), position + Vec3(0,0,2*scale), r, g, b, a) -- topLeft
                    draw.Line(position + Vec3(0,0,scale), position + Vec3(scale,0,scale), r, g, b, a) -- middle
                    draw.Line(position + Vec3(scale,0,0), position + Vec3(scale,0,scale), r, g, b, a) -- bottomRight
                    draw.Line(position, position + Vec3(scale,0,0), r, g, b, a) -- bottom
                end,
                ["6"] = function(position, r, g, b, a, scale)
                    draw.Line(position + Vec3(0,0,2*scale), position + Vec3(scale,0,2*scale), r, g, b, a) -- top
                    draw.Line(position + Vec3(0,0,scale), position + Vec3(0,0,2*scale), r, g, b, a) -- topLeft
                    draw.Line(position + Vec3(0,0,scale), position + Vec3(scale,0,scale), r, g, b, a) -- middle
                    draw.Line(position, position + Vec3(0,0,scale), r, g, b, a) -- bottomLeft
                    draw.Line(position + Vec3(scale,0,0), position + Vec3(scale,0,scale), r, g, b, a) -- bottomRight
                    draw.Line(position, position + Vec3(scale,0,0), r, g, b, a) -- bottom
                end,
                ["7"] = function(position, r, g, b, a, scale)
                    draw.Line(position + Vec3(0,0,2*scale), position + Vec3(scale,0,2*scale), r, g, b, a) -- top
                    draw.Line(position + Vec3(scale,0,scale), position + Vec3(scale,0,2*scale), r, g, b, a) -- topRight
                    draw.Line(position + Vec3(scale,0,0), position + Vec3(scale,0,scale), r, g, b, a) -- bottomRight
                end,
                ["8"] = function(position, r, g, b, a, scale)
                    draw.Line(position + Vec3(0,0,2*scale), position + Vec3(scale,0,2*scale), r, g, b, a) -- top
                    draw.Line(position + Vec3(0,0,scale), position + Vec3(0,0,2*scale), r, g, b, a) -- topLeft
                    draw.Line(position + Vec3(scale,0,scale), position + Vec3(scale,0,2*scale), r, g, b, a) -- topRight
                    draw.Line(position + Vec3(0,0,scale), position + Vec3(scale,0,scale), r, g, b, a) -- middle
                    draw.Line(position, position + Vec3(0,0,scale), r, g, b, a) -- bottomLeft
                    draw.Line(position + Vec3(scale,0,0), position + Vec3(scale,0,scale), r, g, b, a) -- bottomRight
                    draw.Line(position, position + Vec3(scale,0,0), r, g, b, a) -- bottom
                end,
                ["9"] = function(position, r, g, b, a, scale)
                    draw.Line(position + Vec3(0,0,2*scale), position + Vec3(scale,0,2*scale), r, g, b, a) -- top
                    draw.Line(position + Vec3(0,0,scale), position + Vec3(0,0,2*scale), r, g, b, a) -- topLeft
                    draw.Line(position + Vec3(scale,0,scale), position + Vec3(scale,0,2*scale), r, g, b, a) -- topRight
                    draw.Line(position + Vec3(0,0,scale), position + Vec3(scale,0,scale), r, g, b, a) -- middle
                    draw.Line(position + Vec3(scale,0,0), position + Vec3(scale,0,scale), r, g, b, a) -- bottomRight
                    draw.Line(position, position + Vec3(scale,0,0), r, g, b, a) -- bottom
                end,
                ["P"] = function(position, r, g, b, a, scale)
                    draw.Line(position + Vec3(0,0,2*scale), position + Vec3(scale,0,2*scale), r, g, b, a) -- top
                    draw.Line(position + Vec3(0,0,scale), position + Vec3(0,0,2*scale), r, g, b, a) -- topLeft
                    draw.Line(position + Vec3(scale,0,scale), position + Vec3(scale,0,2*scale), r, g, b, a) -- topRight
                    draw.Line(position + Vec3(0,0,scale), position + Vec3(scale,0,scale), r, g, b, a) -- middle
                    draw.Line(position, position + Vec3(0,0,scale), r, g, b, a) -- bottomLeft
                end,
                ["L"] = function(position, r, g, b, a, scale)
                    draw.Line(position + Vec3(0,0,scale), position + Vec3(0,0,2*scale), r, g, b, a) -- topLeft
                    draw.Line(position, position + Vec3(0,0,scale), r, g, b, a) -- bottomLeft
                    draw.Line(position, position + Vec3(scale,0,0), r, g, b, a) -- bottom
                end,
                ["A"] = function(position, r, g, b, a, scale)
                    draw.Line(position + Vec3(0,0,2*scale), position + Vec3(scale,0,2*scale), r, g, b, a) -- top
                    draw.Line(position + Vec3(0,0,scale), position + Vec3(0,0,2*scale), r, g, b, a) -- topLeft
                    draw.Line(position + Vec3(scale,0,scale), position + Vec3(scale,0,2*scale), r, g, b, a) -- topRight
                    draw.Line(position + Vec3(0,0,scale), position + Vec3(scale,0,scale), r, g, b, a) -- middle
                    draw.Line(position, position + Vec3(0,0,scale), r, g, b, a) -- bottomLeft
                    draw.Line(position + Vec3(scale,0,0), position + Vec3(scale,0,scale), r, g, b, a) -- bottomRight
                end,
                ["N"] = function(position, r, g, b, a, scale)
                    draw.Line(position + Vec3(0,0,scale), position + Vec3(0,0,2*scale), r, g, b, a) -- topLeft
                    draw.Line(position + Vec3(scale,0,scale), position + Vec3(scale,0,2*scale), r, g, b, a) -- topRight
                    draw.Line(position + Vec3(0,0,2*scale), position + Vec3(scale,0,0), r, g, b, a) -- topLeft=>bottomRight
                    draw.Line(position, position + Vec3(0,0,scale), r, g, b, a) -- bottomLeft
                    draw.Line(position + Vec3(scale,0,0), position + Vec3(scale,0,scale), r, g, b, a) -- bottomRight
                end,
                ["I"] = function(position, r, g, b, a, scale)
                    draw.Line(position + Vec3(0,0,scale), position + Vec3(0,0,2*scale), r, g, b, a) -- topLeft
                    draw.Line(position, position + Vec3(0,0,scale), r, g, b, a) -- bottomLeft
                end,
                ["G"] = function(position, r, g, b, a, scale)
                    draw.Line(position + Vec3(0,0,2*scale), position + Vec3(scale,0,2*scale), r, g, b, a) -- top
                    draw.Line(position + Vec3(0,0,scale), position + Vec3(0,0,2*scale), r, g, b, a) -- topLeft
                    draw.Line(position + Vec3(scale/2,0,scale), position + Vec3(scale,0,scale), r, g, b, a) -- middle
                    draw.Line(position, position + Vec3(0,0,scale), r, g, b, a) -- bottomLeft
                    draw.Line(position + Vec3(scale,0,0), position + Vec3(scale,0,scale), r, g, b, a) -- bottomRight
                    draw.Line(position, position + Vec3(scale,0,0), r, g, b, a) -- bottom
                end,
            }

            local drawFunciton = digits[tostring(number)]
            if (drawFunciton) then
                drawFunciton(position, r, g, b, a, scale)
            end
		end,
	},
}