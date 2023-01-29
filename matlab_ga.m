function matlab_ga()

    V = 100;

    a = [1.25 1.25 1.25 1.25 1.25 1.5 1.5 1.5 1.5 1.5 1 1 ...
        1 1 1 1 1];

    % c_i upper bound per graph acme
    c = [54.13 21.56 34.08 49.19 33.03 21.84 29.96 24.87 47.24 ...
        33.97 26.89 32.76 39.98 37.12 53.83 61.65 59.73];

    % Function to be minimized (veh/min*min), where x is a 1x17 column vector
    % a, c, x are column vectors so i apply elementwise operators
    f = @(x) sum(a.*x./(1.-x./c));

    % Equality Constraints
    h = @(x) [ ...
        x(1) + x(2) + x(3) + x(4) - V;
        x(5) + x(6) - x(1);
        x(7) + x(8) - x(2);
        x(9) + x(10) - x(4);
        x(3) + x(9) + x(8) - x(13) - x(12) - x(11);
        x(6) + x(7) + x(13) - x(14) - x(15);
        x(5) + x(14) - x(16);
        x(12) + x(15) + x(16) + x(17) - V
    ];

    % Equality constraints Aeq*x=beq
    Aeq = [ ...
        1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0;
       -1 0 0 0 1 1 0 0 0 0 0 0 0 0 0 0 0;
       0 -1 0 0 0 0 1 1 0 0 0 0 0 0 0 0 0;
       0 0 0 -1 0 0 0 0 1 1 0 0 0 0 0 0 0;
        0 0 1 0 0 0 0 1 1 0 -1 -1 -1 0 0 0 0;
        0 0 0 0 0 1 1 0 0 0 0 0 1 -1 -1 0 0;
        0 0 0 0 1 0 0 0 0 0 0 0 0 1 0 -1 0;
        0 0 0 0 0 0 0 0 0 0 0 1 0 0 1 1 1;
    ];

    beq = [ ...
        V;
        0;0;0;0;0;0;
        V;
    ];

    % Inequality constraints
    A = [ ];
    b = [ ];

    % Bounds
    lb = zeros(1, 17);
    ub = [54.13 21.56 34.08 49.19 33.03 21.84 29.96 24.87 47.24 ...
        33.97 26.89 32.76 39.98 37.12 53.83 61.65 59.73];

    for i=1 : 8
        fprintf("------------------------ %dst GENETIC ALGORITHM TRY ------------------------\n", i);
        [solution, fval] = ga(f, 17, A, b, Aeq, beq, lb, ub)
        errors = h(solution)
        mse(errors)
    end

end

