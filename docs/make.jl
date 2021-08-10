using ESeriesRounding
using Documenter

DocMeta.setdocmeta!(ESeriesRounding, :DocTestSetup, :(using ESeriesRounding); recursive=true)

makedocs(;
    modules=[ESeriesRounding],
    authors="KronosTheLate",
    repo="https://github.com/KronosTheLate/ESeriesRounding.jl/blob/{commit}{path}#{line}",
    sitename="ESeriesRounding.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://KronosTheLate.github.io/ESeriesRounding.jl",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/KronosTheLate/ESeriesRounding.jl",
)
