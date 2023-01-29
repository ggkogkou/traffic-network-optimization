function [next_generation_population] = selection(population, fitness_scores, elite_chromosomes_num, roulette_wheel_num)
    % Create the next generation with the same size as the initial
    % population
    next_generation_population = NaN(size(population));

    % Elitism -- Pass the strongest chromosomes to the next generation
    % Calculate how many chromosomes will survive due to elitism
    strongest_chromosomes_to_survive_num = elite_chromosomes_num;
    for i=1 : strongest_chromosomes_to_survive_num
        next_generation_population(i,:) = population(i,:);
    end

    % Remove the previous chromosomes from the previous population
    tmp_population = NaN(size(population, 1)-strongest_chromosomes_to_survive_num, size(population, 2));
    tmp_fitness_scores = NaN(size(population, 1)-strongest_chromosomes_to_survive_num, 1);
    for i=1 : size(population, 1)-strongest_chromosomes_to_survive_num
        tmp_population(i,:) = population(i+strongest_chromosomes_to_survive_num, :);
        tmp_fitness_scores(i) = fitness_scores(i+strongest_chromosomes_to_survive_num);
    end

    tmp_population

    % Roulette Wheel Selection -- Pass some randomly selected chromosomes
    % to the next generation
    random_chromosomes_to_survive_num = roulette_wheel_num;

    % Assign the probability of each chromosome regarding its fitness score
    probabilities = NaN(length(tmp_fitness_scores), 1);
    fitness_scores_sum = sum(fitness_scores);
    for i=1 : length(probabilities)
        if i == 1
            probabilities(i) = fitness_scores(i) / fitness_scores_sum;
        else
            probabilities(i) = probabilities(i-1) + fitness_scores(i) / fitness_scores_sum;
        end
    end

    probabilities

    i = strongest_chromosomes_to_survive_num + 1;
    i_max = strongest_chromosomes_to_survive_num + random_chromosomes_to_survive_num;
    while i <= i_max
        % Spin the wheel
        wheel_result = unifrnd(0, 1)

        % Check the case that the wheel shows the last chromosome e.g. 0.989
        if wheel_result >= probabilities(size(tmp_population, 1)) && wheel_result <= 1
            next_generation_population(i,:) = tmp_population(length(probabilities),:);
            continue;
        end

        % Check which is the corresponding chromosome that the wheel showed
        for j=1 : length(probabilities)
            if wheel_result >= probabilities(j)
                continue;                
            else
                next_generation_population(i,:) = tmp_population(j,:);
                break;
            end
        end

        i = i+1;
    end

end

