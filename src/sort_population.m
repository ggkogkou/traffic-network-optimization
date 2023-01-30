function [sorted_population, sorted_fitness_scores] = sort_population(population, fitness_scores)
    % Sort fitness_scores array in descending order and keep the sort index
    [sorted_fitness_scores, idx] = sort(fitness_scores, 'descend');

    % Sort population array by using idx order
    sorted_population = NaN(size(population));
    
    % Based on idx recreate the sorted array
    for i=1 : size(sorted_population, 1)
        sorted_population(i,:) = population(idx(i),:);
    end

end


