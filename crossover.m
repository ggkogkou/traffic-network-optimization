function [offspring_1, offspring_2] = crossover(parent_1, parent_2)
    % Crossover process using the Single Point Crossver Method
    chromosomes_length = length(parent_1);

    % Find a random point to split the parent chromosomes
    split_point = floor(unifrnd(1, chromosomes_length));

    % Perform crossover
    offspring_1(1:split_point) = parent_1(1:split_point);
    offspring_1(split_point+1 : chromosomes_length) = parent_2(split_point+1 : chromosomes_length);

    offspring_2(1:split_point) = parent_2(1:split_point);
    offspring_2(split_point+1 : chromosomes_length) = parent_1(split_point+1 : chromosomes_length);

end

