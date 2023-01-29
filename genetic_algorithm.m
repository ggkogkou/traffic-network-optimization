function genetic_algorithm()

V = 70;

elitism_percentage = 0.1;
roulette_wheel_percentage = 0.5;

mutation_probability = 0.1;

initial_population_size = 20;
max_generations = 40;
elite_chromosomes_num = elitism_percentage * initial_population_size;
roulette_wheel_num = roulette_wheel_percentage * initial_population_size;
crossover_num = initial_population_size - elite_chromosomes_num - roulette_wheel_num;
upper_c = 25;
lower_c = 0;

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

f = @(x) (x^2 + 5);

g = 1;

chromosome_length = 17;
chromosome = NaN(chromosome_length, 1);
population = NaN(initial_population_size, chromosome_length);
population_fitness_scores = NaN(initial_population_size, 1);
best_chromosome = NaN(max_generations, chromosome_length);
best_chromosome_fitness_score = NaN(max_generations, 1);

% Initialize population
generation_num = 1;

for i=1 : initial_population_size
    for j=1 : chromosome_length
        chromosome(j) = unifrnd(lower_c, upper_c);
    end
    population_fitness_scores(i) = fitness_function(f, chromosome, g, h);
    population(i,:) = chromosome;
end

% Sort population based on the fitness scores
[population, population_fitness_scores] = sort_population(population, population_fitness_scores);

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
            next_generation_population(i,:) = mutation(population(i,:), upper_c, lower_c);
        end
    end

    % Copy data to population and population_fitness_scores matrices
    clear population;
    population(:,:) = next_generation_population(:,:);

    % Evaluate fitness scores
    for i=1 : initial_population_size
        population_fitness_scores(i) = fitness_function(f, chromosome, g, h);
    end

    % Sort population based on the fitness scores
    [population, population_fitness_scores] = sort_population(population, population_fitness_scores);

    % Select best chromosome
    best_chromosome(generation_num,:) = population(1,:);
    best_chromosome_fitness_score(generation_num) = population_fitness_scores(1);

    fprintf("Generation %d\t|\tFittest Chromosome Fitness Score: %.4f\n", generation_num, best_chromosome_fitness_score(generation_num));
end

if generation_num > 1
    selected_chromosome = best_chromosome(generation_num-1, :)
else
    selected_chromosome = best_chromosome(generation_num, :)
end

fprintf("Generations demanded: %d\n", generation_num - 1);

end


