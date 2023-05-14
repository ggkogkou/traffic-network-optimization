
# Traffic Network Optimization

This MATLAB project aims to optimize traffic flow in a road network using a genetic algorithm. The genetic algorithm evolves a population of potential traffic signal timings to find the optimal configuration that minimizes traffic congestion and travel time.

## Features

- Initialization of the population with random traffic signal timings
- Elitism: Preservation of the best individuals in each generation
- Roulette Wheel Selection: Selection of individuals based on their fitness scores
- Single-Point Crossover: Combination of genetic material from two parent configurations
- Mutation: Random alteration of traffic signal timings in selected configurations
- Fitness Evaluation: Calculation of fitness scores based on traffic congestion and travel time
- Termination: Stopping criterion based on the maximum number of generations or convergence criteria

## Installation

1. Clone the repository:

   ```shell
   git clone https://github.com/ggkogkou/traffic-network-optimization.git
   ```

2. Open MATLAB and change the current directory to the project directory:

   ```matlab
   cd traffic-network-optimization
   ```

3. You're ready to use the traffic network optimization program.

## Dependencies

This project requires MATLAB to be installed on your system. There are no additional dependencies.

## Usage

To use the traffic network optimization program, follow these steps:

1. Prepare the road network data, including road segments, intersections, and traffic demand information. Store the data in the appropriate format.

2. Set the parameters for the genetic algorithm, such as the population size, maximum generations, crossover and mutation rates, convergence criteria, etc.

3. Open the `genetic_algorithm.m` script in MATLAB.

4. In the script, specify the road network data, optimization parameters, and any other relevant settings.

5. Run the `genetic_algorithm` script.

6. The script will optimize the traffic network and display the best traffic signal timings found, along with the corresponding fitness score and convergence information.
7. All you need to edit in order to use the application is in the [load_data.m](load_data.m) file.

Example usage:

```matlab
function [f, h, chrom_num, initial_N, max_generations, elit_per, roulette_per, ...
    mut_prob, upper_x, lower_x, v_mean, v_deviation, h_const, g] = load_data()
    
    % Percent of population to pass to the next generation through elitism
    elit_per = 0.1;

    % Percent of population to pass to the next generation by roulette wheel selection
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

    % Function to minimize (veh/min*min)
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

```

## Results

The traffic network optimization program provides the following results:

- `best_timings`: The best traffic signal timings found, representing the optimal configuration for minimizing traffic congestion and travel time.
- `best_fitness`: The fitness score of the best timings, indicating the performance of the optimized configuration.
- `convergence_info`: Information about the convergence of the algorithm, such as the best fitness values at each generation.

## License

This project is licensed under the [GPL-3.0](LICENSE).

## Contributing

Contributions to the project are welcome. If you encounter any issues or have suggestions for improvements, please create an issue or submit a pull request.

## Acknowledgments

This implementation is based on the principles of genetic algorithms and traffic optimization. We would like to acknowledge the contributions and insights of various resources and references.
