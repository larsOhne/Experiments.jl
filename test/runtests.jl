using Experiments
using Test

@testset "Experiments.jl" begin
    project = load_project("../examples/dummy_project")

    println(project.path)
end
