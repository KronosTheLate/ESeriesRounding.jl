using ESeries
using Documenter

DocMeta.setdocmeta!(ESeries, :DocTestSetup, :(using ESeries); recursive=true)

makedocs(;
    modules=[ESeries],
    authors="KronosTheLate",
    repo="https://github.com/KronosTheLate/ESeries.jl/blob/{commit}{path}#{line}",
    sitename="ESeries.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://KronosTheLate.github.io/ESeries.jl",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/KronosTheLate/ESeries.jl",
)
