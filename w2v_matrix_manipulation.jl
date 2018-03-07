# Important packages
println("== Compiling packages...")
using JLD

# Loading the array
println("== Loading data...")
count = load("backup_matrices/counts.jld")["counts"]

# Checks if the count array is symmetric
isSymmetric = Symmetric(count) == count
println("== The count array is symmetric: ", isSymmetric)
if (isSymmetric == false)
	exit
end

# Normalizing the count array
println("== Normalizing count array (ETA: 1h30 from start)...")
count /= norm(count)

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