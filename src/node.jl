using Dates, Graphs

""" Any node that other processes can depend on """
abstract type DependableNode end

@enum NodeTypes begin
    COMPUTE_NODE
    EXTERNAL_RESOURCE
    ARTIFACT
    PARAMETER
end

# building up of the Node ID through concatenating path and timestamp
_nid_from_path_date(path::AbstractString, last_changed::DateTime) = path * "@" * Dates.format(last_changed, DATE_FORMAT)

struct RawNode <:DependableNode
    path::AbstractString
    type::NodeTypes
    last_changed::DateTime
    nid::AbstractString

    # constructors
    RawNode(path::AbstractString, type::NodeTypes, last_changed::DateTime) = new(path, type, last_changed, _nid_from_path_date(path, last_changed))
    RawNode(path::AbstractString, type::NodeTypes) = RawNode(path, type, Dates.now())
        
end

# dispatch 
Base.:(==)(x::RawNode, y::RawNode) = x.nid == y.nid


"""
    is_file(node) -> Bool

Returns whether a node corresponds to a file.
"""
@inline is_file(node::RawNode) = node.type == EXTERNAL_RESOURCE || node.type == ARTIFACT

struct DependencyGraph <:AbstractGraph{Int64}
    nodes::Vector{RawNode}
    graph::DiGraph{Int64}

    # constructors
    DependencyGraph() = new(Vector{RawNode}(), DiGraph{Int64}())
end

# dispatch graph functions
Graphs.edges(g::DependencyGraph) = Graphs.edges(g.graph)
Base.eltype(g::DependencyGraph) = Base.eltype(g.graph)
Graphs.edgetype(g::DependencyGraph) = Graphs.edgetype(g.graph)
Graphs.has_edge(g::DependencyGraph) = Graphs.has_edge(g.graph)
Graphs.has_vertex(g::DependencyGraph) = Graphs.has_vertex(g.graph)
Graphs.inneighbors(g::DependencyGraph) = Graphs.inneighbors(g.graph)
Graphs.ne(g::DependencyGraph) = Graphs.ne(g.graph)
Graphs.nv(g::DependencyGraph) = Graphs.nv(g.graph)
Graphs.outneighbors(g::DependencyGraph) = Graphs.outneighbors(g.graph)
Graphs.vertices(g::DependencyGraph) = Graphs.vertices(g.graph)
Graphs.is_directed(g::DependencyGraph) = true
Graphs.is_directed(g::Type{DependencyGraph}) = true

# custom graph functions
Base.findfirst(nid::AbstractString, g::DependencyGraph) = Base.findfirst([n.nid == nid for n in g.nodes])
Base.findfirst(node::RawNode, g::DependencyGraph) = Base.findfirst(node.nid, g)


"""
    add_node!(::DependencyGraph, ::RawNode) --> Bool

Adds a new node to the graph. Returns true if operation was successful, false otherwise. 

!!! Warning:
    Implementation does not check for duplicated nodes, so it is possible to add two nodes with the same NID.
"""
function add_node!(g::DependencyGraph, node::RawNode)::Bool
    # create a new node in the graph
    worked = add_vertex!(g.graph)
    if worked push!(g.nodes, node) end

    return worked
end

add_dependency!(g::DependencyGraph, id_from::Int, id_to::Int)::Bool = add_edge!(g.graph, id_from, id_to)
add_dependency!(g::DependencyGraph, nid_from::AbstractString, nid_to::AbstractString) = add_dependency!(g, findfirst(nid_from, g), findfirst(nid_to, g))
add_dependency!(g::DependencyGraph, node_from::RawNode, node_to::RawNode) = add_dependency!(g, node_from.nid, node_to.nid)
add_dependency!(g::DependencyGraph, from::Any, to::Any) = false