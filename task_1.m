function task_1()
    % Implement Task -- Vehicle Flow Rate = 100 (veh/min) = const.
    clc
    addpath("src/");

    % Load Genetic Algorithm paramters
    [f, h, chromosome_length, initial_population_size, max_generations, ...
    elitism_percentage, roulette_wheel_percentage, mutation_probability, upper_x, lower_x] = load_data();

    % Execute the Genetic Algorithm and store the solutions
    executions_num = 7;
    solutions = NaN(executions_num, chromosome_length);
    solutions_stats = NaN(executions_num, 3);

    for i=1 : executions_num
        [solutions(i,:), stats] = genetic_algorithm(f, h, chromosome_length, initial_population_size, max_generations, ...
            elitism_percentage, roulette_wheel_percentage, mutation_probability, upper_x, lower_x);
        tmp = stats{2, 1};
        solutions_stats(i, 1) = tmp(end);

        % Plot the fitness scores as the population evolves
        figure(1);
        title('Fitness Scores as Generations Evolve');
        x_axis = linspace(0, max_generations, max_generations);
        y_axis = transpose(tmp(:,:));
        plot(x_axis, y_axis);
        legend_str{i} = sprintf('Execution %d', i);
        legend(legend_str);
        hold all;
        drawnow;

        tmp = stats{3, 1};
        solutions_stats(i, 2) = tmp(end);
    
        % Plot the constraints violations as the population evolves
        figure(2);
        title('Constraints Violations as Generations Evolve');
        y_axis = transpose(tmp(:,:));
        plot(x_axis, y_axis);
        legend_str{i} = sprintf('Execution %d', i);
        legend(legend_str);
        hold all;
        drawnow;

        tmp = stats{4, 1};
        solutions_stats(i, 3) = tmp(end);
    
        % Plot the minima calculations as the population evolves
        figure(3);
        title('Minima of Objective Function as Generations Evolve');
        y_axis = transpose(tmp(:,:));
        plot(x_axis, y_axis);
        legend_str{i} = sprintf('Execution %d', i);
        legend(legend_str);
        hold all;
        drawnow;
    end

    % Save the plots
    current_project = pwd;

    file_dest = strcat(current_project, '/plots/v_const_fitness_scores', '.png');
    saveas(figure(1), file_dest);

    file_dest = strcat(current_project, '/plots/v_const_constraints_violations', '.png');
    saveas(figure(2), file_dest);

    file_dest = strcat(current_project, '/plots/v_const_minima', '.png');
    saveas(figure(3), file_dest);

    % Display the solutions of all of the algorithm executions
    fprintf("Solutions:\n");
    disp(solutions);

    for i=1 : executions_num
        fprintf("Solution %d|\tFitness Score: %.6f\tMSE of Constraints Violation: %.6f\tMinimum: %.6f\n", i, solutions_stats(i, 1), solutions_stats(i, 2), solutions_stats(i, 3));
    end

    % Calculate the mean of all of the solutions to give a final answer
    mean_solution = mean(solutions, 1);
    fprintf("A mean value solution:\n");
    disp(mean_solution);

end



