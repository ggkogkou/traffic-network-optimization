function [solution, solution_mse] = genetic_algorithm_2(objective_function, equality_constraints, initial_population_size, max_generations, ...
    elitism_percentage, roulette_wheel_percentage, mutation_probability, upper_x, lower_x, v_mean, v_deviation, g)

% Implement the genetic algorithm
elitism_percentage = 0.06;
roulette_wheel_percentage = 0.4;

mutation_probability = 0.25;

initial_population_size = 500;
max_generations = 5000;
v_deviation = 0.15;
elite_chromosomes_num = elitism_percentage * initial_population_size;
roulette_wheel_num = roulette_wheel_percentage * initial_population_size;

% Vehicle Flow Rate
v_mean = 100;
lowest_v = 1 - v_deviation;
highest_v = 1 + v_deviation;
V = generate_new_vehicle_flow(v_mean, lowest_v, highest_v);

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
    x(1) + x(2) + x(3) + x(4);
    x(5) + x(6) - x(1);
    x(7) + x(8) - x(2);
    x(9) + x(10) - x(4);
    x(3) + x(9) + x(8) - x(13) - x(12) - x(11);
    x(6) + x(7) + x(13) - x(14) - x(15);
    x(5) + x(14) - x(16);
    x(12) + x(15) + x(16) + x(17)
];

g = @(x, v) [v; 0; 0; 0; 0; 0; 0; v];

heq = @(x) h(x) - g(x,V);

upper_x = c;
lower_x = zeros(17, 1);

chromosome_length = 17;

% Initialize population
[population, population_fitness_scores] = initialize_population(initial_population_size, chromosome_length, lower_x, upper_x, f, heq);

% Sort population based on the fitness scores
[population, population_fitness_scores] = sort_population(population, population_fitness_scores);

% Select the best chromosome at each generation and print it
generation_num = 1;
min_calc = f(transpose(population(1,:)));

fprintf("Generation %d\t|\tFittest Chromosome Fitness Score: %.4f |\tMinimum is %.5f |\t\tMSE of Constraints: %f\n", generation_num, ...
        population_fitness_scores(1), min_calc, mse(heq(population(1,:))));

% Implement Algorithm -- terminate when maximum generations are produced
while generation_num < max_generations
    generation_num = generation_num + 1;

    % Update the equality constraints function heq with the new V
    V = generate_new_vehicle_flow(v_mean, lowest_v, highest_v);
    heq = @(x) h(x) - g(x,V);

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
        population_fitness_scores(i) = adaptive_fitness_function(f, transpose(population(i,:)), heq, generation_num);
    end

    % Sort population based on the fitness scores
    [population, population_fitness_scores] = sort_population(population, population_fitness_scores);

    % Select best chromosome and print it
    min_calc = f(transpose(population(1,:)));

    fprintf("Generation %d\t|\tFittest Chromosome Fitness Score: %.4f |\tMinimum is %.5f |\t\tMSE of Constraints: %f\n", generation_num, ...
        population_fitness_scores(1), min_calc, mse(heq(population(1,:))));
end

solution = population(1,:);
solution_mse = mse(heq(solution));

fprintf("\nMSE of Constraints: %f \n\n", solution_mse);

heq(solution)

end


