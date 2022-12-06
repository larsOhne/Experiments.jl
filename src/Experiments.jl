"""
 Experiment organization module. Provides standardized interfaces and functionalities to work 
 with large sets of experiment scripts.
"""
module Experiments
# imports
using Graphs, Dates, Configurations

# include other module files
include("constants.jl")
include("node.jl")
include("step.jl")

# export types
export  RawNode, DependencyGraph, DependableNode,
        COMPUTE_NODE, EXTERNAL_RESOURCE, ARTIFACT, PARAMETER,
# functions
        is_file, 
        add_node!, add_dependency!,
# constants
        DATE_FORMAT

end
