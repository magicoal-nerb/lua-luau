local ez = {}

function ez.describe(label, fn)
	local succ, err = pcall(fn)
	if not succ then
		print(string.format("test failed: %s", err))
	else
		print(string.format("test passed: %s", label))
	end
end

function ez.it(label, fn)
	local succ, err = pcall(fn)
	if not succ then
		error(string.format("%s: %s", label, err))
	end
end

function ez.expect(expr)
	return {
		to = {
			equal = function(what)
				if expr ~= what then
					error(string.format("expected: %s, got %s", what, expr))
				end
			end,
		}
	}
end

return function(env)
	env.it = ez.it
	env.expect = ez.expect
	env.describe = ez.describe
end