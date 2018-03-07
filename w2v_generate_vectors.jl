# Important packages
using JLD
using Plots
plotly()

# Loading data...
println("== Loading data...")
d = load("backup_matrices/eigenvalues.jld")["values"]
v = load("backup_matrices/eigenvectors.jld")["vectors"]

plot(d, linewidth=2, title="Eigenvalues")