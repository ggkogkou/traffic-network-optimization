function [f, h, chrom_num, initial_N, max_generations, elit_per, roulette_per, ...
    mut_prob, upper_x, lower_x, v_mean, v_deviation, h_const, g] = load_data()
    % Load the data for the problem

    % Percent of population to pass to the next generation through elitism
    elit_per = 0.1;

    % Percent of population to pass to the next generation by roulette
    % wheel selection
    roulette_per = 0.4;
    
    % Probability of a chromosome to undergo the mutation process
    mut_prob = 0.15;
    
    % Size of the initial population
    initial_N = 3000;

    % Number of maximum generations
    max_generations = 600;

    % Vehicle Input Flow Rate
    V = 100;

    % Number of variables that consist a chromosome
    chrom_num = 17;

    % a_i multipliers
    a = [1.25; 1.25; 1.25; 1.25; 1.25; 1.5; 1.5; 1.5; 1.5; 1.5; 1; 1; ...
        1; 1; 1; 1; 1;];

    % c_i upper bound per graph acme
    c = [54.13; 21.56; 34.08; 49.19; 33.03; 21.84; 29.96; 24.87; 47.24; ...
        33.97; 26.89; 32.76; 39.98; 37.12; 53.83; 61.65; 59.73];

    % Function to be minimized (veh/min*min), where x is a 1x17 column vector
    % a, c, x are column vectors so i apply elementwise operators
    f = @(x) sum(a.*x./(1.-x./c));

    % Equality Constraints for V = const.
    h = @(x) [ ...
        x(1) + x(2) + x(3) + x(4) - V;
        x(5) + x(6) - x(1);
        x(7) + x(8) - x(2);
        x(9) + x(10) - x(4);
        x(3) + x(9) + x(8) - x(13) - x(12) - x(11);
        x(6) + x(7) + x(13) - x(14) - x(15);
        x(10) + x(11) - x(17);
        x(5) + x(14) - x(16);
        x(12) + x(15) + x(16) + x(17) - V
    ];

    % Bounds for each gene (x_i)
    upper_x = c;
    lower_x = zeros(17, 1);

    % For changing rate of V consider the following parameters
    v_mean = V;
    v_deviation = 0.15;

    % Equality constraints non-dependent on V
    h_const = @(x) [ ...
        x(1) + x(2) + x(3) + x(4);
        x(5) + x(6) - x(1);
        x(7) + x(8) - x(2);
        x(9) + x(10) - x(4);
        x(3) + x(9) + x(8) - x(13) - x(12) - x(11);
        x(6) + x(7) + x(13) - x(14) - x(15);
        x(10) + x(11) - x(17);
        x(5) + x(14) - x(16);
        x(12) + x(15) + x(16) + x(17)
    ];

    % Vehicle Rate V dependent part of h(x)
    g = @(x, v) [v; 0; 0; 0; 0; 0; 0; 0; v];

end

