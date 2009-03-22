-- Spawns cmd if no client can be found matching properties
-- If such a client can be found, pop to first tag where it is visible, and give it focus
-- (stolen from awesome wiki: http://awesome.naquadah.org/wiki/index.php?title=Run_or_raise)
--
-- @param cmd the command to execute
-- @param properties a table of properties to match against clients.
--                   Possible entries: any properties of the client object
function run_or_raise(cmd, properties)
   local clients = client.get()
   for i, c in pairs(clients) do
      if match_all(properties, c) then
         local ctags = c:tags()
         if table.getn(ctags) == 0 then
            -- ctags is empty, show client on current tag
            local curtag = awful.tag.selected()
            awful.client.movetotag(curtag, c)
         elseif not match_any_value(ctags, awful.tag.selectedlist()) then
            -- Client is not on any of the selected tags.
            -- Pop to the first one it is visible on.
            awful.tag.viewonly(ctags[1])
         end
         -- And then focus the client
         client.focus = c
         c:raise()
         return
      end
   end
   awful.util.spawn(cmd)
end

-- Returns true if all pairs in table1 are present in table2
function match_all(table1, table2)
   for k, v in pairs(table1) do
      if table2[k] ~= v then
         return false
      end
   end
   return true
end

-- Returns true if at least one value in table1 is also in table2
function match_any_value(table1, table2)
  for k1, v1 in pairs(table1) do
    for k2, v2 in pairs(table2) do
      if v1 == v2 then 
        return true
      end
    end
  end

  return false
end

