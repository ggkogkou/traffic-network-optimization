function [next_generation_population] = selection(population, fitness_scores, elite_chromosomes_num, roulette_wheel_num)
    % Create the next generation with the same size as the initial
    % population
    next_generation_population = NaN(size(population));

    elite_chromosomes_num = floor(elite_chromosomes_num);
    roulette_wheel_num = floor(roulette_wheel_num);

    % Elitism -- Pass the strongest chromosomes to the next generation
    % Calculate how many chromosomes will survive due to elitism
    for i=1 : elite_chromosomes_num
        next_generation_population(i,:) = population(i,:);
    end

    % Remove the previous chromosomes from the previous population
    for i=1 : elite_chromosomes_num
        population = remove_row_from_matrix(population, 1);
        fitness_scores = remove_row_from_matrix(fitness_scores, 1);
    end

    % Roulette Wheel Selection -- Pass some randomly selected chromosomes
    % to the next generation based on their fintess score

    i = elite_chromosomes_num + 1;
    i_max = elite_chromosomes_num + roulette_wheel_num;
    while i <= i_max
        % Matrix to store the probability of each chromosome to be selected
        probabilities = NaN(size(population, 1), 1);
        fitness_scores_sum = sum(fitness_scores);

        % Assign probability to each chromosome based on its fitness score
        for k=1 : length(probabilities)
            if k == 1
                probabilities(k) = fitness_scores(k) / fitness_scores_sum;
            else
                probabilities(k) = probabilities(k-1) + fitness_scores(k) / fitness_scores_sum;
            end
        end

        % Spin the wheel
        wheel_result = unifrnd(0, 1);

        % Check the case that the wheel shows the last chromosome e.g. 0.989
        if wheel_result >= probabilities(length(probabilities)) && wheel_result <= 1
            % Copy chromosome to the new population
            next_generation_population(i,:) = population(length(probabilities),:);
            % Remove the chromosome from the population
            population = remove_row_from_matrix(population, length(probabilities));
            fitness_scores = remove_row_from_matrix(fitness_scores, length(probabilities));
            continue;
        end

        % Check which is the corresponding chromosome that the wheel showed
        for j=1 : length(probabilities)
            if wheel_result >= probabilities(j)
                continue;                
            else
                % Copy chromosome to the new population
                next_generation_population(i,:) = population(j,:);
                % Remove the chromosome from the population
                population = remove_row_from_matrix(population, j);
                fitness_scores = remove_row_from_matrix(fitness_scores, j);
                break;
            end
        end

        % Increase i by 1
        i = i+1;
    end

end

