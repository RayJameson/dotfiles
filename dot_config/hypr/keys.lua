-- keys.lua
-- Key metatable: overloads + to build "MOD + MOD + KEY" strings for hl.bind
local mt = {}
mt.__add = function(a, b) return setmetatable({ _s = tostring(a) .. " + " .. tostring(b) }, mt) end
mt.__tostring = function(self) return self._s end

-- K.ANYTHING auto-creates a Key on demand (K.SUPER, K.F, K.Return, ...)
local K = setmetatable({}, {
  __index = function(_, name) return setmetatable({ _s = name }, mt) end,
})

-- Wrap hl.bind so Key tables are coerced to strings transparently
-- ponytail: tostring is enough; no type guard needed, plain strings pass through unchanged
local _bind = hl.bind
hl.bind = function(key, ...) return _bind(tostring(key), ...) end

return K
