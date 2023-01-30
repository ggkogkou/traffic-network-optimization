function [random_V] = generate_new_vehicle_flow(mean_V, lower_V_percent, upper_V_percent)
    % A function that returns a new vehicle flow rate when requested
    lowest_V = mean_V * lower_V_percent;
    highest_V = mean_V * upper_V_percent;

    random_V = unifrnd(lowest_V, highest_V);

end