using SymPy
using JuMP
using HiGHS

println("HOMEWORK 2:\n")

###Question 1###
println("\nQUESTION 1:\n")
println("a.\n")

println("Tom = x₁ \nPeter = x₂ \nNina = x₃ \nSamir = x₄ \nGary = x₅ \nLinda = x₆ \n Bob = x₇\n")

# Model
mod = Model(HiGHS.Optimizer)

# Variables
@variables(mod, begin
    x_1 >= 0 # Tom
    x_2 >= 0 # Peter
    x_3 >= 0 # Nina
    x_4 >= 0 # Samir
    x_5 >= 0 # Gary
    x_6 >= 0 # Linda
    x_7 >= 0 # Bob
end)

#Constraints
@constraints(mod, begin
    x_1 >= 30000
    x_2 >= x_1 + 8000
    x_3 >= x_1 + 8000
    x_4 >= x_1 + 8000
    x_5 >= x_1 + x_2
    x_6 == x_5 + 500
    x_3 + x_5 >= 2 * (x_1 + x_2)
    x_7 >= x_2
    x_7 >= x_4
    x_7 + x_2 >= 75000
    x_6 <= x_7 + x_1
end)

# Objective
@objective(mod, Min, x_1 + x_2 + x_3 + x_4 + x_5 + x_6 + x_7)

println(mod)
println("\nb.\n")

# New variable for the highest salary
@variable(mod, x_highest >= 0)

# New constraints to ensure x_highest is the highest salary
@constraints(mod, begin
    x_highest >= x_1
    x_highest >= x_2
    x_highest >= x_3
    x_highest >= x_4
    x_highest >= x_5
    x_highest >= x_6
    x_highest >= x_7
end)

# New objective to minimize the highest salary
@objective(mod, Min, x_highest)

println(mod)
println("c.\n")

optimize!(mod)

###QUESTION 2###
println("\nQUESTION 2:\n")
println("b.\n")

mod2 = Model(HiGHS.Optimizer)

types = [:Columbian, :Brazilian, :Sumatran]
blends = [:Robust, :Light]

@variables(mod2, begin
    x[types, blends] >= 0
end)

costs = Dict(:Columbian => 1.00, :Brazilian => 0.85, :Sumatran => 1.55)
avail = Dict(:Columbian => 550, :Brazilian => 450, :Sumatran => 650)
prices = Dict(:Robust => 4.25, :Light => 3.95)

@constraints(mod2, begin
    # Robust Joe blend constraints
    sum(x[:Sumatran, :Robust]) >= 0.60 * sum(x[types, :Robust])
    sum(x[:Sumatran, :Robust]) <= 0.75 * sum(x[types, :Robust])
    sum(x[:Columbian, :Robust]) >= 0.10 * sum(x[types, :Robust])
    
    # Light Joe blend constraints
    sum(x[:Brazilian, :Light]) >= 0.50 * sum(x[types, :Light])
    sum(x[:Brazilian, :Light]) <= 0.60 * sum(x[types, :Light])
    sum(x[:Sumatran, :Light]) <= 0.20 * sum(x[types, :Light])
    
    # Availability constraints
    sum(x[:Columbian, :]) <= avail[:Columbian]
    sum(x[:Brazilian, :]) <= avail[:Brazilian]
    sum(x[:Sumatran, :]) <= avail[:Sumatran]
end)

revenue = sum(prices[b] * sum(x[types, b]) for b in blends)
cost = sum(costs[t] * sum(x[t, blends]) for t in types)
@objective(mod2, Max, revenue - cost)

optimize!(mod2)

println("The optimal solution is:")
for t in types
    for b in blends
        println("Amount of ", t, " in ", b, " blend: ", value(x[t, b]))
    end
end
println("Total profit: ", objective_value(mod2))


###QUESTION 3###
println("\nQUESTION 3\n")

