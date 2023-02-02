function [mutated_chromosome] = mutation(chromosome, upper_bounds, lower_bounds)
    % Mutation Process -- choose a random gene of the chromosome and
    % reassign it to a new value that satisfies the constraints
    chromosome_length = length(chromosome);

    % Random gene positions
    random_gene_positions = NaN(3, 1);
    random_gene_positions(1) = floor(unifrnd(1, chromosome_length+0.99));

    while true
        random_gene_positions(2) = floor(unifrnd(1, chromosome_length+0.99));
        if random_gene_positions(2) ~= random_gene_positions(1)
            break;
        end
    end

    while true
        random_gene_positions(3) = floor(unifrnd(1, chromosome_length+0.99));
        if random_gene_positions(3) ~= random_gene_positions(1) && random_gene_positions(3) ~= random_gene_positions(2)
            break;
        end
    end

    % Mutation every gene obtained by a Gaussian distribution centered around the
    % current value
    mutation_genes = NaN(3, 1);
    for i=1 : 3
        mutation_genes(i) = abs(upper_bounds(i) * randn);
        %mutation_genes(i) = lower_bounds(i) + upper_bounds(i) * rand;

        % Make sure that the new gene is inside the bounds
        while mutation_genes(i) >= upper_bounds(random_gene_positions(i)) || mutation_genes(i) <= lower_bounds(random_gene_positions(i))
            mutation_genes(i) = random('Normal', chromosome(random_gene_positions(i)), 1);
        end
    end

    mutated_chromosome = chromosome;
    for i=1 : 3
        mutated_chromosome(random_gene_positions(i)) = mutation_genes(i);
    end

end

