-- normalize case of words in 'str' to Title Case
function titlecase(str)
    local buf = {}
    for word in string.gfind(str, "%S+") do          
        local first, rest = string.sub(word, 1, 1), string.sub(word, 2)
        table.insert(buf, string.upper(first) .. string.lower(rest))
    end    
    return table.concat(buf, " ")
end