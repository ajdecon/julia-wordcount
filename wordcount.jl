# wordcount.j
#   
# Implementation of parallelized "word-count" of a text, inspired by the 
# Hadoop WordCount example. Uses @spawn and fetch() to parallelize 
# tasks.

# "Map" function.
# Takes a string. Returns a HashTable with the number of times each word 
# appears in that string.
function wordcount(text)
    words=split(text,(' ','\n','\t','-','.',',',':','_','"',';','!'))
    counts=Dict()
    for w = words
        counts[w]=get(counts,w,0)+1
    end
    return counts
end

# "Reduce" function.
# Takes a collection of HashTables in the format returned by wordcount()
# Returns a HashTable in which words that appear in multiple inputs
# have their totals added together.
function wcreduce(wcs)
    counts=Dict()
    for c = wcs
        for (k,v)=c
            counts[k] = get(counts,k,0)+v
        end
    end
    return counts
end

# Splits input string into nprocs() equal-sized chunks (last one rounds up), 
# and @spawns wordcount() for each chunk to run in parallel. Then fetch()s
# results and performs wcreduce().
# Limitations: splitting the string and reduction step are single-threaded.
function parallel_wordcount(text)
    lines=split(text,'\n',false)
    np=nprocs()
    unitsize=ceil(length(lines)/np)
    wcounts={}
    rrefs={}
    # spawn procs
    for i=1:np
        first=unitsize*(i-1)+1
        last=unitsize*i
        if last>length(lines)
            last=length(lines)
        end
        subtext=join(lines[int(first):int(last)],"\n")
        push(rrefs, @spawn wordcount( subtext ) )
    end
    # fetch results
    while length(rrefs)>0
        push(wcounts,fetch(pop(rrefs)))
    end
    # reduce
    count=wcreduce(wcounts)
    return count
end

# Takes the name of a result file, and a list of input file names.
# Combines the contents of all files, then performs a parallel_wordcount
# on the resulting string. Writes the results to result_file.
# Limitation: Performs all file IO single-threaded.
function wordcount_files(result_file,input_file_names...)
    text=""
    for f = input_file_names
        fh=open(f)
        text=join( {text,readall(fh)}, "\n" )
        close(fh)
    end
    wc=parallel_wordcount(text)
    fo=open(result_file,"w")
    for (k,v) = wc
        with_output_stream(fo,println,k,"=",v)
    end
end
