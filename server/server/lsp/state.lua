local decode, encode
do
  local _obj_0 = require("util.jsonrpc")
  decode, encode = _obj_0.decode, _obj_0.encode
end
local ServerState
do
  local _class_0
  local _base_0 = {
    notify = function(self, notification)
      return table.insert(self.pendingNotifications, notification)
    end,
    symbolIterator = function(self)
      local queue = { }
      local _list_0 = self.symbols
      for _index_0 = 1, #_list_0 do
        local symbol = _list_0[_index_0]
        table.insert(queue, symbol)
      end
      return function()
        if #queue == 0 then
          return nil
        end
        local item = table.remove(queue, 1)
        if item.children then
          local _list_1 = item.children
          for _index_0 = 1, #_list_1 do
            local child = _list_1[_index_0]
            table.insert(queue, child)
          end
        end
        return item
      end
    end
  }
  _base_0.__index = _base_0
  _class_0 = setmetatable({
    __init = function(self)
      self.initialized = false
      self.pendingNotifications = { }
      self.symbols = { }
      self.symbolDeclarationMap = { }
      self.symbolNodeMap = { }
      self.symbolPositionMap = { }
    end,
    __base = _base_0,
    __name = "ServerState"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  ServerState = _class_0
  return _class_0
end
