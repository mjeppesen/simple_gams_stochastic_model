* Simple stochastic model
sets
    plants /
        hydro
        thermal /

    scenarios /
        low_demand
        high_demand/;

parameters
    capex(plants) /
        hydro 30
        thermal 20/

    opex(plants) /
        hydro 0
        thermal 15/

    demand(scenarios) /
        low_demand 1
        high_demand 2/

    probabilities(scenarios) /
        low_demand 0.5
        high_demand 0.5/;

variables
    z
    plants_built(plants)
    generation(plants, scenarios);

positive variables
    plants_built(plants)
    generation(plants, scenarios);

equations
    objective
    generation_less_than_plants_built(plants, scenarios)
    meet_demand;

objective..
    z =e=sum(plants, plants_built(plants) * capex(plants)) +
        sum(scenarios, probabilities(scenarios)* sum(plants, opex(plants) *
        generation(plants, scenarios)));

meet_demand(scenarios)..
    sum(plants, generation(plants, scenarios)) =e= demand(scenarios);

generation_less_than_plants_built(plants, scenarios)..
    generation(plants, scenarios) =l= plants_built(plants);

model simple_thermal_model /all/;

solve simple_thermal_model using lp minimizing z;
display plants_built.l, generation.l
