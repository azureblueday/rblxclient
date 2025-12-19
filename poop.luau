local garbage_list = getgc(true)

for i, obj in next, garbage_list do
    if type(obj) == "function" and islclosure(obj) and not isexecutorclosure(obj) then
        local protos = getprotos(obj)
        if protos and #protos == 1 then
            local consts = getconstants(protos[1])
            if table.find(consts, 5100020) then
                hookfunction(obj, function() end)
            end
        end
    end
end

for i, v in garbage_list do
    if type(v) == "table" then
        local mt = getrawmetatable(v)
        if mt and mt.__call and islclosure(mt.__call) and not isexecutorclosure(mt.__call) then

            local old_call
            old_call = hookfunction(
                mt.__call,
                newcclosure(function(self, a, b, c, d, e, f, ...)
                    if a and b and c and d and e and f then
                        if a > 1000 and b > 1000 then
                            return { 20.01 }
                        end
                    end
                    return old_call(self, a, b, c, d, e, f, ...)
                end)
            )
            rawset(mt, "__tostring", nil)
        end
    end
end


for i, obj in getconnections(game:GetService("ScriptContext").Error) do
    if obj and obj.Function then
        hookfunction(
            obj.Function,
            newcclosure(function()
                return
            end)
        )
    end
end
