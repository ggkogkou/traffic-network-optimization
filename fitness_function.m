function [fitness_score] = fitness_function(f, chromosome, g, h)
    % Implement the fitness function evaluation
    r = 1000;

    % Penalty term as a constraint satisfaction metric
    penalty_term = r * sum(h(chromosome).^2);

    % Calculate the fitness score
    fitness_score = r / (f(chromosome) + penalty_term);

end


