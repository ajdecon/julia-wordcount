@everywhere load("wordcount.j")
fh=open("1661.txt")
text=readall(fh)
close(fh)
result=parallel_wordcount(text)
println("done!")

fh2=open("result.txt","w")
for (k,v) = result
    with_output_stream(fh2,println,k,"=",v)
end
close(fh2)
println("output written!")
