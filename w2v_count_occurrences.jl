# Important packages
println("== Compiling useful packages...")
using JLD

# Importing the words file
println("== Importing dictionary...")
f = open("preprocessed_data/words.txt")
raw_words = readlines(f)
close(f)

# Preprocessing words
println("== Preprocessing dictionary...")
words = Array(AbstractString, 0)
for raw_word in raw_words
	push!(words,strip(raw_word, ['\n']))
end

# Importing the sents file
println("== Importing sentences...")
f = open("preprocessed_data/sents.txt")
sents = readlines(f)
close(f)

# Checking array sizes
println("- Dictionary size: ", length(words))
println("- Number of sentences: ", length(sents))

# Initializing the count array
println("== Initializing the count array...")
count = zeros(Int32, length(words), length(words))

# Counting word matches (symmetric)
println("== Counting...")
w = 0
for sent in sents
	for i = 1:length(words)
		if (contains(sent, words[i]))
			for j = i:length(words)
				if (contains(sent, words[j]))
					count[i,j] += 1
					count[j,i] += 1
				end
			end
		end
	end
	w+=1
	println(w, "/", length(sents), " sents processed")
end

# Saving the array
println("== Exporting count array...")
save("backup_matrices/counts.jld", "counts", count)