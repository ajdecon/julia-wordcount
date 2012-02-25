# Load the contents of Sherlock Holmes into variable text, split into two chunks, and
# do wordcount on two separate procs. Then reduce and display.

@everywhere load("wordcount.j")
fh=open("1661.txt")
text=readall(fh)
close(fh)

lines=split(text,'\n',false)
half=int(floor(length(lines)/2))
chunk1=join(lines[1:half], "\n")
chunk2=join(lines[half+1:length(lines)], "\n")

println("Spawning process 1...")
ref1 = @spawn wordcount(chunk1)
println("Spawning process 2...")
ref2 = @spawn wordcount(chunk2)

println("Fetching process 1...")
wc1 = fetch(ref1)
println("Fetching process 2...")
wc2 = fetch(ref2)
println("Done fetching.")
wc = wcreduce(wc1,wc2)
show(wc)
