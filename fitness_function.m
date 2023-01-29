function [fitness_score] = fitness_function(f, chromosome, g, h)

    V = 70;
    r = 10;

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

    penalty = sum(h(chromosome).^2);

    fitness_score = r / (f(5) + r*penalty);

end


