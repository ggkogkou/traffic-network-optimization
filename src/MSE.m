function [error] = MSE(x)
    % If x is a row vector transpose it to a column
    if size(x, 2) > 1
        x = transpose(x);
    end

    % Calculate MSE of matrix x as MSE = RMSE^2
    a = zeros(length(x), 1);
    error = rmse(x, a);
    error = error^2;

end