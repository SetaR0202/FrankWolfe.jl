using FrankWolfe
using LinearAlgebra
using Random
import GLPK

function build_reduce_inflate(p::Array{T, 2}) where {T <: Number}
    n = size(p, 1)
    @assert n == size(p, 2)
    dimension = floor(Int, (n+1)^2 / 4)
    sqrt2 = sqrt(T(2))
    return function(A::AbstractArray{T, 2}, lmo)
        vec = Vector{T}(undef, dimension)
        cnt = 0
        @inbounds for i in 1:(n+1)÷2, j in i:n+1-i
            cnt += 1
            if i == j
                if i + j == n+1
                    vec[cnt] = A[i, i]
                else
                    vec[cnt] = (A[i, i] + A[n+1-i, n+1-i]) / sqrt2
                end
            else
                if i + j == n+1
                    vec[cnt] = (A[i, j] + A[j, i]) / sqrt2
                else
                    vec[cnt] = (A[i, j] + A[j, i] + A[n+1-i, n+1-j] + A[n+1-j, n+1-i]) / 2
                end
            end
        end
        return FrankWolfe.SymmetricArray(collect(A), vec)
    end, function(x::FrankWolfe.SymmetricArray, lmo)
        cnt = 0
        @inbounds for i in 1:(n+1)÷2, j in i:n+1-i
            cnt += 1
            if i == j
                if i + j == n+1
                    x.data[i, i] = x.vec[cnt]
                else
                    x.data[i, i] = x.vec[cnt] / sqrt2
                    x.data[n+1-i, n+1-i] = x.data[i, j]
                end
            else
                if i + j == n+1
                    x.data[i, j] = x.vec[cnt] / sqrt2
                    x.data[j, i] = x.data[i, j]
                else
                    x.data[i, j] = x.vec[cnt] / 2
                    x.data[j, i] = x.data[i, j]
                    x.data[n+1-i, n+1-j] = x.data[i, j]
                    x.data[n+1-j, n+1-i] = x.data[i, j]
                end
            end
        end
        return x.data
    end
end

# s = rand(1:100)
s = 98
@info "Seed $s"
Random.seed!(s)

n = Int(2e2)
k = Int(4e4)

# we artificially create a symmetric instance to illustrate the syntax
xpi = rand(n, n)
xpi .+= xpi'
xpi .+= reverse(xpi)
xpi ./= 4
reduce, inflate = build_reduce_inflate(xpi)
const xp = xpi
const normxp2 = dot(xp, xp)

function cf(x, xp, normxp2)
    return (normxp2 - 2dot(x, xp) + dot(x, x)) / n^2
end

function cgrad!(storage, x, xp)
    return @. storage = 2 * (x - xp) / n^2
end

lmo_nat = FrankWolfe.BirkhoffPolytopeLMO()

x0 = FrankWolfe.compute_extreme_point(lmo_nat, randn(n, n))

@time x, v, primal, dual_gap, trajectoryBPCG, _ = FrankWolfe.blended_pairwise_conditional_gradient(
    x -> cf(x, xp, normxp2),
    (str, x) -> cgrad!(str, x, xp),
    lmo_nat,
    FrankWolfe.ActiveSetQuadratic([(1.0, x0)], 2I/n^2, -2xp/n^2);
    max_iteration=k,
    line_search=FrankWolfe.Shortstep(2/n^2),
    lazy=true,
    print_iter=k / 10,
    verbose=true,
)

const rxp = reduce(xpi, nothing)
@assert dot(rxp, rxp) ≈ normxp2

lmo_sym = FrankWolfe.SymmetricLMO(lmo_nat, reduce, inflate)

rx0 = FrankWolfe.compute_extreme_point(lmo_sym, reduce(randn(n, n), nothing))

@time x, v, primal, dual_gap, trajectoryBPCG, _ = FrankWolfe.blended_pairwise_conditional_gradient(
    x -> cf(x, rxp, normxp2),
    (str, x) -> cgrad!(str, x, rxp),
    lmo_sym,
    FrankWolfe.ActiveSetQuadratic([(1.0, rx0)], 2I/n^2, -2rxp/n^2);
    max_iteration=k,
    line_search=FrankWolfe.Shortstep(2/n^2),
    lazy=true,
    print_iter=k / 10,
    verbose=true,
)

println()
