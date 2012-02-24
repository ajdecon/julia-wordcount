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

function parallel_wordcount(text)
    lines=split(text,'\n',false)
    np=nprocs()
    unitsize=ceil(length(lines)/np)
    wcounts=[]
    rrefs=[]
    # spawn procs
    for i=1:np
        first=unitsize*(i-1)+1
        last=unitsize*i
        if last>length(lines)
            last=length(lines)
        end
        rrefs[i] = @spawn wordcount( join( lines[first:last], " " ) )
    end
    # fetch results
    for i=1:np
        wcounts[i]=rrefs[i]
    end
    # reduce
    count=wcreduce(wcounts)
    return count
end

