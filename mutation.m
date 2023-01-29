function [mutated_chromosome] = mutation(chromosome, upper_bound, lower_bound)
    % Mutation Process -- choose a random gene of the chromosome and
    % reassign it to a new value that satisfies the constraints
    chromosome_length = length(chromosome);

    % Random gene
    random_gene_position = floor(unifrnd(1, chromosome_length+0.99));

    % Mutation gene obtained by a Gaussian distribution centered around the
    % current value
    mutation_gene = random('Normal', chromosome(random_gene_position), 1);
    while mutation_gene >= upper_bound || mutation_gene <= lower_bound
        mutation_gene = random('Normal', chromosome(random_gene_position), 1);
    end

    mutated_chromosome = chromosome;
    mutated_chromosome(random_gene_position) = mutation_gene;

end

