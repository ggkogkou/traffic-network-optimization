function [fitness_score] = fitness_function(f, chromosome, h)
    % Implement the fitness function evaluation

    % rk for the static penalty method
    rk = 1000;

    % Scale the fitness evaluation result to be for readable
    scale = 1000;

    % If chromosome is a row vector, transpose it
    if size(chromosome, 1) == 1
        chromosome = transpose(chromosome);
    end

    % Penalty term as a constraint satisfaction metric
    penalty_term = rk * sum(h(chromosome).^2);

    % Calculate the fitness score
    fitness_score = scale / (f(chromosome) + penalty_term);

end


