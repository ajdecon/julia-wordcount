function wordcount(text)
    words=split(text,(' ','\n','\t'),false)
    counts=HashTable()
    for w = words
        counts[w]=get(counts,w,0)+1
    end
    return counts
end

function wcreduce(wcs...)
    counts=HashTable()
    for c = wcs
        for (k,v)=c
            counts[k] = get(counts,k,0)+v
        end
    end
    return counts
end

function parallel_wordcount(text)
    lines=split(text,'\n',false)
    np=nprocs()
    unitsize=ceil(length(lines)/np)
    wcounts=[]
    rrefs={}
    # spawn procs
    for i=1:np
        first=unitsize*(i-1)+1
        last=unitsize*i
        if last>length(lines)
            last=length(lines)
        end
        push(rrefs, @spawn wordcount( join( lines[first:last], " " ) ) )
    end
    # fetch results
    for i=1:length(rrefs)
        wcounts[i]=fetch(rrefs[i])
    end
    # reduce
    count=wcreduce(wcounts)
    return count
end

