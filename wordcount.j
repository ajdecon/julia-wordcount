function wordcount(text)
    words=split(text,(' ','\n','\t'),false)
    counts=HashTable()
    for w = words
        try
            counts[w]=counts[w]+1
        catch ex
            if typeof(ex)==KeyError
                counts[w]=1
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
        for (k,v)=c
            try
                counts[k]=counts[k]+v
            catch ex
                if typeof(ex)==KeyError
                    counts[k]=v
                else
                    throw(ex)
                end
            end
        end
    end
    return counts
end
