function [solution, best_chromosomes_stats] = genetic_algorithm(objective_function, equality_constraints, chromosome_length, ...
    initial_population_size, max_generations, elitism_percentage, roulette_wheel_percentage, mutation_probability, upper_x, lower_x)

% Implement the genetic algorithm
addpath('src/');

% Uncomment to run the algorithm internally, or, comment out to run externally
[objective_function, equality_constraints, chromosome_length, initial_population_size, max_generations, ...
    elitism_percentage, roulette_wheel_percentage, mutation_probability, upper_x, lower_x, ~, ~, ~, ~] = load_data();

f = objective_function;
h = equality_constraints;

% Determine the number of chromosomes to undergo elitism or roulette wheel
elite_chromosomes_num = elitism_percentage * initial_population_size;
roulette_wheel_num = roulette_wheel_percentage * initial_population_size;

% Initialize population
[population, population_fitness_scores] = initialize_population(initial_population_size, chromosome_length, lower_x, upper_x, f, h);

% Matrices to keep track of the best chromosome at each generations
best_chrom = NaN(max_generations, chromosome_length);
best_chrom_fitness_scores = NaN(max_generations, 1);
best_chrom_constraints_violations = NaN(max_generations, 1);
best_chrom_mins_calc = NaN(max_generations, 1);

% Sort population based on the fitness scores
[population, population_fitness_scores] = sort_population(population, population_fitness_scores);

% Select the best chromosome at each generation and store it
generation_num = 1;

best_chrom(generation_num,:) = population(1,:);
best_chrom_fitness_scores(generation_num) = population_fitness_scores(1);
best_chrom_constraints_violations(generation_num) = mse(h(population(1,:)));
best_chrom_mins_calc(generation_num) = f(transpose(best_chrom(generation_num,:)));

fprintf("Generation %d\t|\tFittest Chromosome Fitness Score: %.4f |\tMinimum is %.5f |\t\tMSE of Constraints Violation: %f\n", generation_num, ...
    best_chrom_fitness_scores(generation_num), best_chrom_mins_calc(generation_num), best_chrom_constraints_violations(generation_num));

% Implement Algorithm -- terminate when maximum generations are produced
while generation_num < max_generations
    % Create a new generation
    generation_num = generation_num + 1;

    % Selection process -- Elitism + Roulette Wheel
    [next_generation_population] = selection(population, population_fitness_scores, elite_chromosomes_num, roulette_wheel_num);

    % Crossover the remaining chromosomes
    for i=elite_chromosomes_num+roulette_wheel_num+1 : 2 : initial_population_size
        % Parents should come from the top 60% of the population
        idx1 = floor(unifrnd(1, floor(0.6*size(population, 1))));
        idx2 = floor(unifrnd(1, floor(0.6*size(population, 1))));

        parent1 = population(idx1,:);
        parent2 = population(idx2,:);

        [next_generation_population(i,:), next_generation_population(i+1,:)] = crossover(parent1, parent2);
    end

    % Mutation -- In the next generation mutate the genes of randomly selected chromosomes
    for i=1 : initial_population_size
        % Perform mutation with a certain probability -> mutation_probability
        if unifrnd(0, 1) < mutation_probability
            next_generation_population(i,:) = mutation(population(i,:), upper_x, lower_x);
        end
    end

    % Copy data to population and population_fitness_scores matrices
    clear population;
    population(:,:) = next_generation_population(:,:);

    % Evaluate fitness scores
    for i=1 : initial_population_size
        population_fitness_scores(i) = fitness_function(f, transpose(population(i,:)), h);
    end

    % Sort population based on the fitness scores
    [population, population_fitness_scores] = sort_population(population, population_fitness_scores);

    % Select best chromosome
    best_chrom(generation_num,:) = population(1,:);
    best_chrom_fitness_scores(generation_num) = population_fitness_scores(1);
    best_chrom_constraints_violations(generation_num) = mse(h(population(1,:)));
    best_chrom_mins_calc(generation_num) = f(transpose(best_chrom(generation_num,:)));

    fprintf("Generation %d\t|\tFittest Chromosome Fitness Score: %.4f |\tMinimum is %.5f |\t\tMSE of Constraints Violation: %f\n", generation_num, ...
        best_chrom_fitness_scores(generation_num), best_chrom_mins_calc(generation_num), best_chrom_constraints_violations(generation_num));
end

% Select the best chrosome that is the solution to the problem
solution = best_chrom(end,:);

% Store the data of all of the selected chromosome of each generation
best_chromosomes_stats = {best_chrom(:,:); best_chrom_fitness_scores(:,:); best_chrom_constraints_violations(:,:); best_chrom_mins_calc(:,:)};

end


