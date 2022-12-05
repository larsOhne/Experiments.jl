using Experiments

# 0. Wrap everything in its own environment to encapsulate step names etc.
module Experiment1
    
# 1. Parametrize experiment
@params struct 
    param_1::Float64
    param_2::Vector{String}
end

# 2. Define Run functions for every step
@step function step_1(param_1::Float64)
    
end

@step function step_2(param_1::Float64, param_2::Vector{String}, step_1::Step)
    
end

end # END Module