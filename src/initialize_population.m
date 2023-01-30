function [population, population_fitness_scores] = initialize_population(initial_population_size, chromosome_length, lower_bound, upper_bound, f, h)
    % Initialize population with respect to the provided bounds
    population = NaN(initial_population_size, chromosome_length);
    population_fitness_scores = NaN(initial_population_size, 1);

    for i=1 : initial_population_size
        % Initialize with random chromosomes
        for j=1 : chromosome_length
            population(i,j) = unifrnd(lower_bound(j), upper_bound(j));
        end
    
        % Evaluate the fitness of the chromosome
        population_fitness_scores(i) = fitness_function(f, population(i,:), h);
    end

end

