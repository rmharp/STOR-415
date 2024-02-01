using SymPy
using JuMP
using HiGHS

println("HOMEWORK 1:\n")
###Question 1###
println("\nQUESTION 1:\n")

display([4 2 3; 2 3 4] * [1 0; 0 1; 2 -3])

###Question 2###
println("\nQUESTION 2:\n")
println("a.\n")

# Define the symbols
@syms a b z u g c f v k l w t s
A = [2 b a; z 4 u; g c f]
B = [3 v k; k l w; v t s]
C = A*B
C_12 = C[1,2]
C_23 = C[2,3]
C_32 = C[3,2]
display(C)
println()
println(C_12)
println(C_23)
println(C_32)

println("\nb.\n")

C = transpose(A)*B
C_12 = C[1,2]
C_23 = C[2,3]
C_32 = C[3,2]
display(C)
println(C_12)
println(C_23)
println(C_32)

println("\nc.\n")

C = transpose(A)*transpose(B)
C_12 = C[1,2]
C_23 = C[2,3]
C_32 = C[3,2]
display(C)
println()
println(C_12)
println(C_23)
println(C_32)

###Question 3##
println("\nQUESTION 3:\n")

# Model
mod = Model(HiGHS.Optimizer)

# Variables
@variable(mod, x_2 >= 450) # Amount invested in bonds, at least $450
@variable(mod, x_1 >= 0) # Amount invested in stocks, cannot be negative

# Constraints
@constraint(mod, x_1 + x_2 <= 1000) # Total investment does not exceed $1000
@constraint(mod, x_1 <= 0.25 * (x_1 + x_2)) # Stocks are at most 25% of total investment

# Objective
@objective(mod, Max, 0.15 * x_1 + 0.05 * x_2)

println(mod)

###Question 4###
println("\nQUESTION 4:\n")
println("a.\n")

# Model
mod1 = Model(HiGHS.Optimizer)

# Variables
@variables(mod1, begin 
    x_1 >= 0 # Amount of milk chocolate bars, cannot be negative
    x_2 >= 0 # Amount of dark chocolate bars, cannot be negative
end) 

# Constraints
@constraints(mod1, begin
    2 * x_1 + 5 * x_2 <= 50000 # Cocoa butter
    x_1 + x_2 <= 25000 # Almonds
end)

# Objective
@objective(mod1, Max, 1.5 * x_1 + 2 * x_2)

println(mod1)
println("b.\n")

# Model
mod2 = Model(HiGHS.Optimizer)

# Variables
@variables(mod2, begin 
    x_1 >= 0 # Amount of milk chocolate bars, cannot be negative
    x_2 >= 0 # Amount of dark chocolate bars, cannot be negative
    s_1 >= 0 # Slack, cannot be negative
    s_2 >= 0 # Slack, cannot be negative
end) 

# Constraints
@constraints(mod2, begin
    2 * x_1 + 5 * x_2 + s_1 == 50000 # Cocoa butter
    x_1 + x_2 + s_2 == 25000 # Almonds
end)

# Objective
@objective(mod2, Min, -1.5 * x_1 - 2 * x_2)

println(mod2)

###Question 5###
println("\nQUESTION 5:\n")

#Model
mod3 = Model(HiGHS.Optimizer)

# Variables
@variables(mod3, begin
    x_1 >= 0 # Raw Carrots
    x_2 >= 0 # Baked Potatoes
    x_3 >= 0 # Wheat Bread
    x_4 >= 0 # Cheddar Cheese
    x_5 >= 0 # Peanut Butter
end)

#Constraints (per serving)
@constraints(mod3, begin
    23 * x_1 + 171 * x_2 + 65 * x_3 + 112 * x_4 + 188 * x_5 >= 2000 # Calories
    0.1 * x_1 + 0.2 * x_2 + 9.3 * x_4 + 16 * x_5 >= 50 # Fat
    0.6 * x_1 + 3.7 * x_2 + 2.2 * x_3 + 7 * x_4 + 7.7 * x_5 >= 100 # Protein
    6 * x_1 + 30 * x_2 + 13 * x_3 + 2 * x_5 >= 250 # Carbohydrates
end)

# Objective
@objective(mod3, Min, 0.14 * x_1 + 0.12 * x_2 + 0.2 * x_3 + 0.75 * x_4 + 0.15 * x_5)

println(mod3)