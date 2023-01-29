% Konstantinos Letros 8851
% Optimization Techniques
% The Project - Constant Rate of Incoming Vehicles
% Constrained Minimization Problem using Genetic Algorithm

%% Clear the Screen

clc
clear
close all;
format long;

tic

%% Parameters

% Number of Chromosomes in every Population
chromeNum = 200;

% Number of Parameters (Genes) in every Chromosome
geneNumber = 16;

% Number of generations until termination
generationsNum = 2000;

%% Problem - Fitness Function Definition

% Rate of Incoming Vehicles
V = 100;

% Road Capacity c_i (Row Vector)
c = [59.85, 43.05, 53.55, 26.25, ...
    44.10, 64.05, 36.75, 35.70, ...
    13.65, 21.00, 54.60, 63.00, ...
    33.60, 54.60, 46.20, 31.50];

% Constant a_i
a = ones(1,geneNumber);

% Minimum time t_i
gamma = 10;
t = gamma*c;

% Overall Time
T = @(x) t + a.*x./(1-x./c);

% Initial Objective Function
f = @(x) sum(x.*T(x));

% Equality Constraints
h = @(x) [ ...
    % 9 Equalities
    x(1)+x(2)+x(3)-V;
    x(6)+x(7)-x(1);
    x(8)+x(9)-x(7);
    x(15)-x(9)-x(10);
    x(5)+x(6)+x(8)-x(10)-x(11)-x(16);
    x(3)+x(4)-x(5)-x(12);
    x(2)-x(4)-x(13);
    x(11)+x(12)+x(13)-x(14);
    x(14)+x(15)+x(16)-V];

% Inequality Constraints
global lb ub
lb = zeros(1,geneNumber); % x > 0
ub = c; % x < c

r = 1e3;

% Fittness Function
fitnessFunc = @(x) r/(f(x) + r*h(x)'*h(x));
% fitnessFunc2 = @(params) 1 / (1 + f(params(1:16)) ) + 1 / (1 + sum(abs(h(params(1:16)))) );

%% Initialization

% Initialize Population of Chromosomes
% population(parameter_i,chromosome_j) in range (lb,ub)
population = initPopulation(geneNumber,chromeNum);
fitnessPop = fitnessEvaluation(population,fitnessFunc);

% Keep track of the fittest chromosome
fittest = zeros(generationsNum,1);
minimum = zeros(generationsNum,1);

[fittest(1),bestIdx] = max(fitnessPop);
optimalChromosome = population(bestIdx,:);
minimum(1) = f(optimalChromosome);
fprintf("Generation 1 \nCurrent Fittest Evaluation: %f \nCurrent Minimum: %f \n\n",...
    fittest(1),minimum(1))

%% Genetic Algorithm

% Count number of generations
generations = 1;

while generations <= generationsNum
    
    % Keep the previous population (for Elitism)
    prevPopulation = population;
    
    % Selection
    population = selectionProcess(population,fitnessPop);
    
    % Crossover - Crossover Parameter = 80%
    population = crossoverProcess(population,0.8);
    
    % Mutation - Mutation Parameter = 80%
    population = mutationProcess(population,0.8);
    
    % Elitism - Rate of Chromosomes to be passed directly = 1%
    population = elitismProcess(population,prevPopulation,fitnessPop,0.01);
    
    % Fitness Evaluation
    fitnessPop = fitnessEvaluation(population,fitnessFunc);
    
    % Print Progress Message
    [fittest(generations),bestIdx] = max(fitnessPop);
    optimalChromosome = population(bestIdx,:);
    minimum(generations) = f(optimalChromosome);
    
    if mod(generations,generationsNum/10) == 0
        fprintf("Generation %d \nCurrent Fittest Evaluation: %f \nCurrent Minimum: %f \n\n",...
            generations,fittest(generations),minimum(generations))
    end
    
    % Count number of generations
    generations = generations + 1;
    
end

%% Results - Evaluation

% Results
fprintf("\nFitness of the fittest chromosome: %f \n\n", fitnessPop(bestIdx) )

fprintf("Fittest Chromosome: \n\n")
disp(optimalChromosome')

fprintf("MSE of Constraints: %f \n\n", mse(h(optimalChromosome)))

fprintf("Objective Function's Minimum: %f \n\n",f(optimalChromosome))

% Plot Fittest Chromosome's Trace
figure
plot(1:generationsNum,fittest)
title('Fittest Chromosome - Fitness Evaluation through Generations')
xlabel('Generations')
ylabel('Fitness Evaluation')

% Plot Minimum's Trace
figure
plot(1:generationsNum,minimum)
title('Minimum - Objective Function Evaluation through Generations')
xlabel('Generations')
ylabel('Objective Function Evaluation')


minTimeConstraints = ...
    (T(optimalChromosome)-t)./T(optimalChromosome) - (optimalChromosome./c).^2 ;
fprintf("Minimum Time Constraint: %f/100 \n\n", 100*mean(abs(minTimeConstraints)) )

toc

% Save Plots
% for i = 1 : length(findobj('type','figure'))
%     figure(i)
%     savePlot([mfilename,'_',num2str(i)])
% end


filename = "partA_minimum"+num2str(floor(f(optimalChromosome)))+".mat";
save(filename)
%% Functions

%% Initialize Population

function chrom = initPopulation(geneNumber,chromeNumber)
% [lowerBound,upperBound]
global lb ub

% Random Initialize Population of Chromosomes
% Every chromosome includes several genes (gaussians)
% All Parameters initialized in [lowerBound,upperBound]

chrom = rand(chromeNumber,geneNumber).*(ub-lb)+lb;

end

%% Fittness Evaulation

function fitChrome = fitnessEvaluation(population,fitnessFunc)

fitChrome = zeros(size(population,1),1);

% Calculate fitness of every chromosome in population
for i = 1:size(population,1)
    fitChrome(i) = fitnessFunc(population(i,:));
end

end

%% Selection Process
% Roulette Wheel Selection
function newPopulation = selectionProcess(population,fitnessPop)

newPopulation = zeros(size(population));

counter = 1;

% Choose Chromosomes to survive
while counter <= size(newPopulation,1)
    
    % Split probabilities into segments
    % Ex: Segment 1 : [0,prob(1)]
    %     Segment 2 : [prob(1),prob(2)] etc.
    prob = length(fitnessPop);
    for i = 1:length(fitnessPop)
        prob(i) = sum(fitnessPop(1:i))/sum(fitnessPop);
    end
    
    % Generate a random number
    randNum = rand;
    
    % Choose which chromosome survives depending
    % on which segment includes the random number
    for index = 1 : length(fitnessPop)
        if prob(index)>=randNum
            break;
        end
    end
    
    % Pass the "lucky" chromosome to the next generation
    newPopulation(counter,:) = population(index,:);
    
    counter = counter + 1;
    
end

end

%% Crossover Process
function newPopulation = crossoverProcess(population,crossParam)

offspring = population;

counter = 1;

while counter <= size(population,1)
    
    prob = rand;
    
    if prob < crossParam
        
        % Choose 2 parent-chromosomes randomly
        parents = population(randi([1,size(population,1)],2,1),:);
        
        % Choose position of gene exchange randomly
        crossPos = randi([1,size(population,2)-1]);
        
        % ie. parent1   = [gene11, gene12, gene13]
        %     parent2   = [gene21, gene22, gene23]
        %     crossPos  = 2
        %     offspring = [gene11, gene12, gene23]
        offspring(counter,:) = [parents(1,1:crossPos),parents(2,crossPos+1:end)];
        offspring(counter+1,:) = [parents(2,1:crossPos),parents(1,crossPos+1:end)];
        
    end
    
    counter = counter + 2;
    
end

% Shuffle the population
idx = randperm(size(population,1));
newPopulation = offspring(idx,:);

end


%% Mutation Process
function newPopulation = mutationProcess(population,mutParam)

global lb ub

newPopulation = population;

counter = 1;

while counter <= size(population,1)
    
    prob = rand;
    
    if prob < mutParam
        
        % Random Gene's Position
        randGenePos = randi([1,size(population,2)]);
        
        % New Random Gene ~ Normal Distribution
        newGene = rand*(ub(randGenePos)-lb(randGenePos))+lb(randGenePos);
        
        % Random Gene Mutation
        newPopulation(counter,randGenePos) = newGene';
    end
    
    counter = counter + 1;
    
end


end

%% Elitism Process
function newPopulation = elitismProcess(population,prevPopulation,fitnessPop,elitParam)

newPopulation = population;
[~,Idx] = sort(fitnessPop,'descend');
for i = 1 : ceil(elitParam*size(population,1))
    newPopulation(Idx(end+1-i),:)= prevPopulation(Idx(i),:);
end

end

%% Function to automatically save plots in high resolution
function savePlot(name)

% Resize current figure to fullscreen for higher resolution image
set(gcf, 'Position', get(0, 'Screensize'));

% Save current figure with the specified name
saveas(gcf, join([name,'.jpg']));

% Resize current figure back to normal
set(gcf,'position',get(0,'defaultfigureposition'));

end