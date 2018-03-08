# Important packages
using JLD

# Loading data...
println("== Loading data...")
d = load("backup_matrices/eigenvalues.jld")["values"]
v = load("backup_matrices/eigenvectors.jld")["vectors"]

# Defining the size of the word vectors
println("== Defining word vectors size...")
m = 50
  
# Sorting eigenvalues by its absolute value (BubbleSort)
println("== BubbleSorting eigenvalues by its absolute values...")
for i = 1:length(d)
    swapped = false
    for j = 1:length(d) - i - 1
        if (abs(d[j]) < abs(d[j + 1]))
            aux = d[j]
            d[j] = arr[j+1]
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

# Reconstructing matrix
println("== Constructing W matrix with all the word vectors...")
word_vectors = d2 * v.'

# Saving reconstructed matrix
println("== Exporting word vectors matrix...")
save("backup_matrices/wordvectors.jld", "wordvectors", word_vectors)