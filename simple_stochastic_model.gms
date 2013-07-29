* Simple stochastic model
sets
    plants /
        hydro
        thermal /;

parameters
    capex /
        hydro 30
        thermal 20/

    opex /
        hydro 0
        thermal 15/;

scalar demand /1/;

variables
    z
    plants_built(plants)
    generation(plants);

positive variables
    plants_built(plants)
    generation(plants);

equations
    objective
    max_gen(plants)
    meet_demand;

objective..
    z =e= sum(plants, plants_built(plants) * capex(plants)) +
        sum(plants, opex(plants) * generation(plants));

meet_demand..
    sum(plants, generation(plants)) =e= demand;

max_gen(plants)..
    generation(plants) =l= plants_built(plants);

model simple_thermal_model /all/;

solve simple_thermal_model using lp minimizing z;
display plants_built.l, generation.l
