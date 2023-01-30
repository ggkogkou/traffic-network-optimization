function [fitness_score] = adaptive_fitness_function(f, chromosome, h, t)
    % Implement the fitness function evaluation

    % (C*t)^2 for the adaptive penalty method
    C = 0.5;

    % If chromosome is a row vector, transpose it
    if size(chromosome, 1) == 1
        chromosome = transpose(chromosome);
    end

    % Penalty term as a constraint satisfaction metric
    penalty_term = (C*t)^2 * sum(h(chromosome).^2);

    % Calculate the fitness score
    fitness_score = t^2 / (f(chromosome) + penalty_term);

end
