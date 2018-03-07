# Important packages
using JLD

# Loading data...
println("== Loading data...")
d = load("backup_matrices/eigenvalues.jld")["values"]
v = load("backup_matrices/eigenvectors.jld")["vectors"]

# Generating auxiliar matrix
println("== Generating auxiliar matrix...")
aux = zeros(length(d))

# Filling the auxiliar matrix
println("== Filling auxiliar matrix...")
max_value = maximum(d)
threshold = 0.01
for i = 1:length(d)
    if (d[i] >= threshold * max_value)
        aux[i] += d[i]
    end
end

# Reconstructing matrix
println("== Reconstructing matrix...")
recons = v * aux * v.'

# Saving reconstructed matrix
println("== Exporting reconstructed matrix...")
save("backup_matrices/reconstructed.jld", "reconstructed", recons)