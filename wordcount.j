function wordcount(text)
    words=split(text,(' ','\n','\t'),false)
    counts=HashTable()
    for w = words
        try
            assign(counts,counts[w]+1,w)
        catch ex
            if typeof(ex)==KeyError
                assign(counts,1,w)
            else
                throw(ex)
            end
        end
    end
    return counts
end

function wcreduce(wcs...)
    counts=HashTable()
    for c = wcs
        for k = c.keys
            try
                assign(counts,counts[k]+1,k)
            catch ex
                if typeof(ex)=KeyError
                    assign(counts,1,k)
                else
                    throw(ex)
                end
            end
        end
    end
    return counts
end
