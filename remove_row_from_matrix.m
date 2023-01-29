function [new_matrix] = remove_row_from_matrix(matrix, idx)
    % Remove line at index idx from the matrix
    new_rows = size(matrix, 1)-1;
    new_columns = size(matrix, 2);
    new_matrix = NaN(new_rows, new_columns);

    % Copy every row except the indexed one
    for i=1 : new_rows + 1
        % Skip row idx
        if i == idx
            continue;
        elseif i < idx
            new_matrix(i,:) = matrix(i,:);
        else
            new_matrix(i-1,:) = matrix(i,:);
        end
    end

end