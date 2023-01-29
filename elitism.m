function [next_generation_population] = elitism(population, fitness_scores, elite_chromosomes_num)
    % Create the next generation with the same size as the initial
    % population
    next_generation_population = NaN(size(population));

    % Elitism -- Pass the strongest chromosomes to the next generation
    % Calculate how many chromosomes will survive due to elitism
    strongest_chromosomes_to_survive_num = elite_chromosomes_num;
    for i=1 : strongest_chromosomes_to_survive_num
        next_generation_population(i,:) = population(i,:);
    end

end

