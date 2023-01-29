function [solution] = genetic_algorithm(objective_function, equality_constraints, initial_population_size, max_generations, elitism_percentage, roulette_wheel_percentage, mutation_probability, upper_x, lower_x)
% Implement genetic algorithm
elitism_percentage = 0.1;
roulette_wheel_percentage = 0.4;

mutation_probability = 0.2;

initial_population_size = 500;
max_generations = 5000;
elite_chromosomes_num = elitism_percentage * initial_population_size;
roulette_wheel_num = roulette_wheel_percentage * initial_population_size;

% Vehicle Flow
V = 100;
clc
% a_i multipliers
a = [1.25; 1.25; 1.25; 1.25; 1.25; 1.5; 1.5; 1.5; 1.5; 1.5; 1; 1; ...
    1; 1; 1; 1; 1;];

% c_i upper bound per graph acme
c = [54.13; 21.56; 34.08; 49.19; 33.03; 21.84; 29.96; 24.87; 47.24; ...
    33.97; 26.89; 32.76; 39.98; 37.12; 53.83; 61.65; 59.73];

% Function to be minimized (veh/min*min), where x is a 1x17 column vector
% a, c, x are column vectors so i apply elementwise operators
f = @(x) sum(a.*x./(1.-x./c));

% Equality Constraints
h = @(x) [ ...
    x(1) + x(2) + x(3) + x(4) - V;
    x(5) + x(6) - x(1);
    x(7) + x(8) - x(2);
    x(9) + x(10) - x(4);
    x(3) + x(9) + x(8) - x(13) - x(12) - x(11);
    x(6) + x(7) + x(13) - x(14) - x(15);
    x(5) + x(14) - x(16);
    x(12) + x(15) + x(16) + x(17) - V
];

upper_x = c;
lower_x = zeros(17, 1);

chromosome_length = 17;
chromosome = NaN(chromosome_length, 1);

population = NaN(initial_population_size, chromosome_length);
population_fitness_scores = NaN(initial_population_size, 1);

best_chromosome = NaN(max_generations, chromosome_length);
best_chromosome_fitness_score = NaN(max_generations, 1);

% Initialize population
for i=1 : initial_population_size
    % Initialize random chromosomes
    for j=1 : chromosome_length
        population(i,j) = unifrnd(lower_x(j), upper_x(j));
    end

    % Evaluate the fitness of the chromosome
    population_fitness_scores(i) = fitness_function(f, chromosome, h);
end

% Sort population based on the fitness scores
[population, population_fitness_scores] = sort_population(population, population_fitness_scores);

% Select the best chromosome at each generation and store it
generation_num = 1;

best_chromosome(generation_num,:) = population(1,:);
best_chromosome_fitness_score(generation_num) = population_fitness_scores(1);

fprintf("Generation %d\t|\tFittest Chromosome Fitness Score: %.4f\n", generation_num, best_chromosome_fitness_score(1));

% Implement Algorithm -- terminate when maximum generations are produced
while generation_num < max_generations
    generation_num = generation_num + 1;

    % Create the next generation with the same size as the initial
    % Selection process -- Elitism + Roulette Wheel
    [next_generation_population] = selection(population, population_fitness_scores, elite_chromosomes_num, roulette_wheel_num);

    % Crossover the remaining percentage of next generation
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
    best_chromosome(generation_num,:) = population(1,:);
    best_chromosome_fitness_score(generation_num) = population_fitness_scores(1);
    min_calc = f(transpose(best_chromosome(generation_num,:)));

    if min_calc < 0
        population
        population_fitness_scores
        best_chromosome(generation_num,:)
        pause
    end

    fprintf("Generation %d\t|\tFittest Chromosome Fitness Score: %.4f |\tMinimum is %.5f  \tMSE of Constraints: %f\n", generation_num, best_chromosome_fitness_score(generation_num), ...
        min_calc, mse(h(best_chromosome(generation_num,:))));
end

solution = best_chromosome(length(best_chromosome),:);

fprintf("\nMSE of Constraints: %f \n\n", mse(h(solution)));

end


