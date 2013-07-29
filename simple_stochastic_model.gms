* Simple stochastic model
sets
    plants /
        hydro
        thermal /

    scenarios /
        low_demand
        high_demand/;

parameters
    capital_cost(plants) "$ / MW" /
        hydro 30
        thermal 20/

    variable_cost(plants) "$ / MWh" /
        hydro 0
        thermal 15/

    demand(scenarios) "MWh / year" /
        low_demand 1
        high_demand 2/

    probabilities(scenarios) /
        low_demand 0.5
        high_demand 0.5/;

scalar value_of_lost_load "$ / MWh" /10000/;

variables
    z;

positive variables
    plants_built(plants)
    generation(plants, scenarios)
    lost_load(scenarios)
    capex
    opex(scenarios);

equations
    objective
    generation_less_than_plants_built(plants, scenarios)
    capex_spend
    opex_spend(scenarios)
    meet_demand;

objective..
    z =e= capex +
        sum(scenarios, probabilities(scenarios) * (opex(scenarios) +
        value_of_lost_load * lost_load(scenarios)));

capex_spend..
    capex =e= sum(plants, capital_cost(plants) * plants_built(plants));

opex_spend(scenarios)..
    opex(scenarios) =e= sum(plants, variable_cost(plants) * generation(plants, scenarios));

meet_demand(scenarios)..
    sum(plants, generation(plants, scenarios)) + lost_load(scenarios) =e= demand(scenarios);

generation_less_than_plants_built(plants, scenarios)..
    generation(plants, scenarios) =l= plants_built(plants);

model simple_thermal_model /all/;

solve simple_thermal_model using lp minimizing z;
display plants_built.l, generation.l, lost_load.l;
