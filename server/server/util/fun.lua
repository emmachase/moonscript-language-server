local zip
zip = function(a, b)
  return (function()
    local _accum_0 = { }
    local _len_0 = 1
    for i = 1, #a do
      _accum_0[_len_0] = {
        a[i],
        b[i]
      }
      _len_0 = _len_0 + 1
    end
    return _accum_0
  end)()
end
return {
  zip = zip
}
