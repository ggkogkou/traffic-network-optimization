function task_2()
    % Implement Task -- Vehicle Flow Rate = 100 +- 15% (veh/min) = const.
    clc

    % Load Genetic Algorithm paramters
    [f, ~, chromosome_length, initial_population_size, max_generations, elitism_percentage, ...
        roulette_wheel_percentage, mutation_probability, upper_x, lower_x, v_mean, v_deviation, h_const, g] = load_data();

    % Execute the Genetic Algorithm and store the solutions
    solutions = NaN(8, 17);
    for i=1 : 1
        [solutions(i,:), stats] = genetic_algorithm_adaptive(f, chromosome_length, initial_population_size, max_generations, ...
            elitism_percentage, roulette_wheel_percentage, mutation_probability, upper_x, lower_x, v_mean, v_deviation, h_const, g);
    end

    % Display the solutions of all of the algorithm executions
    disp(solutions)

    % Calculate the mean of all of the solutions to give a final answer
    mean_solution = mean(solutions, 1);
    disp(mean_solution);
    
    % Get the data from the generations statistics for the last sample
    % algorithm execution: @param stats is a 4x1 cell array
    best_chroms_fitness_scores = stats{2, 1};
    best_chroms_constraints_violations = stats{3, 1};
    best_chroms_mins = stats{4, 1};

    % Print the Mean Square Error of the violation of the constraints and
    % the minmum of the objective function
    fprintf("The solution has Constraints Violetion MSE = %.6f and the minmum is f(x) = %.6f\n", ...
        best_chroms_constraints_violations(end, 1), best_chroms_mins(end, 1));

    % Plot the fitness scores as the population evolves
    figure(1);
    x_axis = linspace(0, max_generations, max_generations);
    y_axis = transpose(best_chroms_fitness_scores(:,:));
    plot(x_axis, y_axis);

    % Plot the constraints violations as the population evolves
    figure(2);
    y_axis = transpose(best_chroms_constraints_violations(:,:));
    plot(x_axis, y_axis);

    % Plot the minima calculations as the population evolves
    figure(3);
    y_axis = transpose(best_chroms_mins(:,:));
    plot(x_axis, y_axis);

end

