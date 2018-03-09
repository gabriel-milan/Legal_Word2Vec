# Defining the size of the word vectors
println("== Defining word vectors size...")
m = 50

# Important packages
println("== Compiling useful packages...")
using JLD
using JSON

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

# Checks if the count array is symmetric
isSymmetric = Symmetric(count) == count
println("== The count array is symmetric: ", isSymmetric)
if (isSymmetric == false)
	exit
end

# # Normalizing the count array
# println("== Normalizing count array (ETA: 1h30 from start)...")
# count /= norm(count)

# Saving the normalized array
println("== Exporting normalized array...")
save("backup_matrices/normalized.jld", "norm", count)

# Decomposing w/ eigendecomposition
println("== Eigendecomposition (ETA: 50min from start)...")
d, v = eig(count)

# Saving matrices
println("== Exporting eigenvalues and eigenvectors arrays...")
save("backup_matrices/eigenvalues.jld", "values", d)
save("backup_matrices/eigenvectors.jld", "vectors", v)
  
# Sorting eigenvalues by its absolute value (BubbleSort)
println("== BubbleSorting eigenvalues by its absolute values...")
for i = 1:length(d)
    swapped = false
    for j = 1:length(d) - i - 1
        if (abs(d[j]) < abs(d[j + 1]))
            aux = d[j]
            d[j] = d[j+1]
            d[j + 1] = aux
            swapped = true
        end
    end
    if swapped == false
        break
    end
end

# Filling a trunkated matrix (MxN) w/ most significant eigenvalues
println("== Filling the trunkated matrix (MxN)...")
d2 = zeros(m, length(d))
for i = 1:m
    d2[i, i] += sqrt(d[i])
end

# Constructing W matrix with all the word vectors
println("== Constructing W matrix with all the word vectors...")
word_vectors = d2 * v.'

# Exporting word vectors matrix
println("== Exporting word vectors matrix...")
save("backup_matrices/wordvectors.jld", "wordvectors", word_vectors)

# Generating dictionary
println("== Generating dictionary...")
dict = [words[i]=>word_vectors[i,:].' for i = 1:length(words)]

# Exporting dictionary as JSON
println("== Exporting dictionary as JSON...")
json_string = JSON.json(dict)
open("output_json/w2v_dict.json", "w") do f
    write(f, json_string)
end

# Prints successful ending
println("== Congratulations! This was successful!")
