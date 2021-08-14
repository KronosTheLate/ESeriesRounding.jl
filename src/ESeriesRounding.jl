module ESeriesRounding

export E3, E6, E12, E24, E48, E96, E192
export determine_E

import Base: round, print, show

using NumericIO: formatted
using AbstractCircuitComponentRounding: AbstractPrefNumbSys, geometric_mean, find_under_and_over, norm_to_between_100_and_1000

struct ESeries<:AbstractPrefNumbSys
    name::Symbol
    vals::AbstractVector
end

E3  = ESeries(:E3,   [100, 220, 470])
E6  = ESeries(:E6,   [100, 150, 220, 330, 470, 680])
E12 = ESeries(:E12,  [100, 120, 150, 180, 220, 270, 330, 390, 470, 560, 680, 820])
E24 = ESeries(:E24,  [100, 110, 120, 130, 150, 160, 180, 200, 220, 240, 270, 300, 330, 360, 390, 430, 470, 510, 560, 620, 680, 750, 820, 910])
E48 = ESeries(:E48,  [100, 105, 110, 115, 121, 127, 133, 140, 147, 154, 162, 169, 178, 187, 196, 205, 215, 226, 237, 249, 261, 274, 287, 301, 316, 332, 348, 365, 383, 402, 422, 442, 464, 487, 511, 536, 562, 590, 619, 649, 681, 715, 750, 787, 825, 866, 909, 953])
E96 = ESeries(:E96,  [100, 102, 105, 107, 110, 113, 115, 118, 121, 124, 127, 130, 133, 137, 140, 143, 147, 150, 154, 158, 162, 165, 169, 174, 178, 182, 187, 191, 196, 200, 205, 210, 216, 221, 226, 232, 237, 243, 249, 255, 261, 267, 274, 280, 287, 294, 301, 309, 316, 324, 332, 340, 348, 357, 365, 374, 383, 392, 402, 412, 422, 432, 442, 453, 464, 475, 487, 499, 511, 523, 536, 549, 562, 576, 590, 604, 619, 634, 649, 665, 681, 698, 715, 732, 750, 768, 787, 806, 825, 845, 866, 887, 909, 931, 953, 976])
E192 =ESeries(:E192, [100, 101, 102, 104, 105, 106, 107, 109, 110, 111, 113, 114, 115, 117, 118, 120, 121, 123, 124, 126, 127, 129, 130, 132, 133, 135, 137, 138, 140, 142, 143, 145, 147, 149, 150, 152, 154, 156, 158, 160, 162, 164, 165, 167, 169, 172, 174, 176, 178, 180, 182, 184, 187, 189, 191, 193, 196, 198, 200, 203, 205, 208, 210, 213, 215, 218, 221, 223, 226, 229, 232, 234, 237, 240, 243, 246, 249, 252, 255, 258, 261, 264, 267, 271, 274, 277, 280, 284, 287, 291, 294, 298, 301, 305, 309, 312, 316, 320, 324, 328, 332, 336, 340, 344, 348, 352, 357, 361, 365, 370, 374, 379, 383, 388, 392, 397, 402, 407, 412, 417, 422, 427, 432, 437, 442, 448, 453, 459, 464, 470, 475, 481, 487, 493, 499, 505, 511, 517, 523, 530, 536, 542, 549, 556, 562, 569, 576, 583, 590, 597, 604, 612, 619, 626, 634, 642, 649, 657, 665, 673, 681, 690, 698, 706, 715, 723, 732, 741, 750, 759, 768, 777, 787, 796, 806, 816, 825, 835, 845, 856, 866, 876, 887, 898, 909, 920, 931, 942, 953, 965, 976, 988])

function round(series::ESeries, input::Number, format::Union{Symbol, Bool}=false)
    input_normed, OOM = norm_to_between_100_and_1000(input)
    if input_normed>maximum(series.vals)
        candidate1, candidate2 = maximum(series.vals), 1000
    else
        candidate1, candidate2 = find_under_and_over(input_normed, series.vals)
    end
    geom_mean = geometric_mean(candidate1, candidate2)
    @assert (candidate1 ≤ input_normed ≤ candidate2) "Input value not in the range of rounding candidates. Something has gone wrong"

    result = (input_normed ≥ geom_mean ? candidate2  :  candidate1)
    result = result*10^OOM

    if format == false
        return round(result, sigdigits=3)
    else
        return formatted(result, format; ndigits=3)
    end
end

function round(series::ESeries, inputs::AbstractArray, format::Union{Symbol, Bool}=false)
    outputs = Array{Any}(undef, length(inputs))
    for i in eachindex(outputs)
        outputs[i] = round(series, inputs[i], format)
    end
    return outputs
end

function print(series::ESeries)
    println("Values in $(string(series.name)):")
    for i in 1:3:length(series.vals)
        print(series.vals[i])
        print("   |   ")
        print(series.vals[i+1])
        print("   |   ")
        println(series.vals[i+2])
    end
end

function show(io::IO, series::ESeries)
    println(io, "Values in $(string(series.name)):")
    for i in 1:3:length(series.vals)
        print(io, series.vals[i])
        print(io, "   |   ")
        print(io, series.vals[i+1])
        print(io, "   |   ")
        println(io, series.vals[i+2])
    end
end

"""
    `determine_E(inputs...)`


Determine all E-series that contain each of the given inputs.
The inputs are comma-seperated.
The outputs are a vector of the names of possible series as `Symbol`s.

# Examples

```julia-repl
julia> determine_E(220, 470, 680)
3-element Vector{Symbol}:
 :E6
 :E12
 :E24

julia> determine_E(220, 470, 910)
1-element Vector{Symbol}:
 :E24
```
"""
function determine_E(inputs::Number...)
    inputs = [inputs...]  # Vector → tuple
    inputs = [norm_to_between_100_and_1000(i, return_OOM=false) for i in inputs]

    candidates = [E3, E6, E12, E24, E48, E96, E192]
    myfilt = fill(true, length(candidates))
    for input in inputs, i in eachindex(candidates)
        if input ∉ candidates[i].vals
            myfilt[i] = false
        end
    end
    possible_series = getfield.(candidates[myfilt], :name)
    return possible_series
end

end
