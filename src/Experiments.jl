"""
 Experiment organization module. Provides standardized interfaces and functionalities to work 
 with large sets of experiment scripts.
"""
module Experiments
# imports
using Graphs, Dates, Configurations

""" push experiment to project """
function Base.push!(project::Project, e::Experiment)
    # add experiment to the dedicated array
    push!(project.experiments, e)
end






include("./_file_funcs.jl")

""" loads the project Representation from disk """
function load_project(proj_dir::AbstractString=".")::Project
    # expand path
    proj_path = realpath(proj_dir)

    # create project object
    project = Project(proj_path)

    # traverse experiment folder and retrieve resources and experiments
    resources, experiments = retrieve_files(project)

    println(experiments)



    return project
end



export load_project, Project

end
