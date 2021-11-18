# ESeriesRounding

<!---[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://KronosTheLate.github.io/ESeriesRounding.jl/stable)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://KronosTheLate.github.io/ESeriesRounding.jl/dev)
[![Build Status](https://github.com/KronosTheLate/ESeriesRounding.jl/workflows/CI/badge.svg)](https://github.com/KronosTheLate/ESeriesRounding.jl/actions)
[![Coverage](https://codecov.io/gh/KronosTheLate/ESeriesRounding.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/KronosTheLate/ESeriesRounding.jl)--->

## Introduction
This package implements functions to round given values to the nearest E-series value. From [wikipedia](https://en.wikipedia.org/wiki/E_series_of_preferred_numbers):  
"The E series is a system of preferred numbers (also called preferred values) derived for use in electronic components. It consists of the E3, E6, E12, E24, E48, E96 and E192 series, where the number after the 'E' designates the quantity of value "steps" in each series. Although it is theoretically possible to produce components of any value, in practice the need for inventory simplification has led the industry to settle on the E series for resistors, capacitors, inductors, and zener diodes."

## The use case
You use theory and math to calculate a set of components to be used in some circuit, e.g. a control system. But producers only manufacture components at certain values, which are unlikely to match your calculations. This creates two problems:
1) Your calculated components are nowhere to be found among your real components. You then need to somehow figure out what is the best alternative.
2) If you simulate the system with your calculated values, it will use different parameters than your physical system, because the calculated values are not physically available.

To remedy the situation, simply round your calculated values to the nearest standardized ones. This is done with the `round` function from Jula base. The returned values can be directly plugged into your simulation, or the output can be formatted to better match common component labels.

## Examples

Lets start with loading the package.
```julia-REPL
Julia> using CircuitComponentRounding
```

And lets round a single value to the `E12` series:
```julia-REPL
julia> round(E12, 266)
270.0
```

The input can be a vector of values:
```julia-REPL
julia> vals = [3, 7e-7, 14e-2, 17e7]

julia> round(E12, vals)
4-element Vector{Any}:
 3.3
 8.2e-7
 0.15
 1.8e8
 ```

When having very large or very small values, some formatting would be nice. This is supplied by the `NumericIO.jl` package. The format is set with the third and final positional argument. Reccomended formats are `:SI` or `:ENG`:
```julia-REPL
julia> round(E12, vals, :SI)
4-element Vector{Any}:
 "3.30"
 "820n"
 "150m"
 "180M"

julia> round(E12, vals, :ENG)
4-element Vector{Any}:
 "3.30×10⁰"
 "820×10⁻⁹"
 "150×10⁻³"
 "180×10⁶"
```

## The E-series variables
This package defines all E-series as variables `E3`, `E6`, and so on, up to `E192`. To see the values in any series, you can:
1) Evaluate the variable, e.g. `E6`, and the values will be shown in your default IO stream, which changes depending of where you are excecuting your code (VSCode, Pluto, the REPL etc).
2) Call `print` on the variable, e.g. `print(E6)`, and the values will be printed in the REPL:
```julia-REPL
julia> print(E6)
Values in E6:
100   |   150   |   220
330   |   470   |   680
```

You can also access the values directly as a vector, by calling the `vals` field of the E-series:
```julia-REPL
julia> E3.vals
3-element Vector{Int64}:        
 100
 220
 470
```

## But what series should I round to?
To determine what series is available to you, you can do two thing:
1) Manually check for matches between the available components and a list of E-series values. To see all values in a given series, see the paragraph above.
2) Use the function `determine_E`.

Here is an example of how to use `determine_E`. Let's say that I can see a few component around, and I will use those to determine which E-series would contain them all:
```julia-REPL
julia> determine_E(220, 470, 680)
3-element Vector{Symbol}:
 :E6
 :E12
 :E24
```

There are 3 series that contain all the values given. Let's add some more information, and see if we can narrow it down to one:
```julia-REPL
julia> determine_E(220, 470, 680, 910)
1-element Vector{Symbol}:
 :E24
```

Great! Now the determined `E24` series can be used for future rounding.




## How the rounding is implemented
The rounded value has the smallest percentage error possible. This is done by finding the [geometric mean](https://en.wikipedia.org/wiki/Geometric_mean) of the 
two numbers in the given E-series ajecent to the given value (one smaller, one larger), and 
returning the E-series value on the same side of the mean value as the input value.

In other words, if the input value is larger than the geometric mean, the returned value was rounded up. 
If the given input is smaller than the geometric mean, the output was rounded down. Rounding in this case means taking the first bigger/smaller value in the E-series.

## Where do the values come from?
The values rounded to are found in the [wikipedia list](https://en.wikipedia.org/wiki/E_series_of_preferred_numbers#Lists) of E-series values. While this list ranges from 1 to 10, the values used are multiplied by 100 and converted to integers. The advantages are that integers are exact, in addition to being (opinion) faster and easier to read than floating point values.
  
## Feedback
As this is the first package of a relativly novice programmer, feedback and input on ways the package could be better are very welcome!
