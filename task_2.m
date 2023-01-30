function task_2()
    % Implement Task -- Vehicle Flow Rate = 100 +- 15% (veh/min) = const.
    clc

    % Vehicle Flow Rate
    v_mean = 100;
    v_deviation = 0.15;

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

    % Vehicle Rate V depended part of h(x)
    g = @(x, v) [v; 0; 0; 0; 0; 0; 0; v];

    % Bounds for each gene (x_i)
    upper_bounds = c;
    lower_bounds = zeros(17, 1);

    % Genetic Algorithm paramters
    initial_population_size = 500;
    max_generations = 5000;
    elitism_percentage = 0.1;
    roulette_wheel_percentage = 0.4;
    mutation_probability = 0.25;

    % Execute the Genetic Algorithm and store the solutions
    solutions = NaN(8, 17);
    solutions_mse = NaN(17, 1);
    for i=1 : 8
        [solutions(i,:), solutions_mse] = genetic_algorithm_2(f, h, initial_population_size, max_generations, elitism_percentage, ...
            roulette_wheel_percentage, mutation_probability, upper_bounds, lower_bounds, v_mean, v_deviation, g);
    end

    solutions = [ ...
        32.6806   19.6207   29.3673   17.6569   26.4730    6.9064   15.3757    5.4538    3.1116   14.1954   11.5826   13.2324   13.1741    7.3544   28.1495   32.0030   24.9180;
        25.9507   19.7808   16.4586   36.0532    8.6879   17.2027    0.5530   19.5565   20.4106   15.4286    3.4073   19.4574   33.5436   33.7333   17.0433   42.8982   19.6202;
        36.9530    5.5536   31.1809   25.2718   18.6876   19.3591    2.9318    5.1505   13.9748   11.0621   15.2105   25.4096    9.6412    8.2516   23.1306   26.5598   26.0875;
        31.2046   17.7071   16.1786   36.6924   16.6320   14.8971    2.3698   14.8719   31.6351    5.7694   13.3403   19.6772   29.7150   21.5451   24.3608   38.1587   19.9045;
        27.3568   11.4822   26.5734   36.4265    5.9859   21.1151    6.9431    4.3581   24.5429   11.5836   16.3515   17.6229   20.9467   15.7260   33.8877   21.6499   28.0431;
        24.3268    9.5358   32.5245   35.4564   16.1168    6.4453    5.0970    4.8817   20.0931   15.5340   13.3968   17.7537   26.4719    7.2952   30.4970   23.8054   28.8825;
        33.7200   14.1827   25.8674   25.3627   15.6189   18.6307    1.0895   14.2952    4.5422   21.1610   11.1397   28.1266    5.4215    5.9892   15.9040   21.1313   31.7449;
        29.6014   16.7107   17.0376   38.1119   22.2306    7.1156    3.3987   13.1366   22.4833   13.7308   24.3517   16.0926   11.5924    9.0002   13.2186   32.0420   42.6300
        ];

    solutions_mse

    mean_solutions = mean(solutions, 1)

end

