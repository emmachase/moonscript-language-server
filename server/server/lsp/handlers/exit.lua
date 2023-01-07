return function(self, params)
  return os.exit(((function()
    if self.shutdown then
      return 0
    else
      return 1
    end
  end)()))
end
