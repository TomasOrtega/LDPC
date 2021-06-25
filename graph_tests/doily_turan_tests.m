clear; close all;

P = get_doily_H();
H = logical(P);
[M, N] = size(H);
K = N - M;

seeds = 1:100;
girths = seeds;

for i = 1:length(seeds)

    random_seed = seeds(i);
    rng(random_seed);

    %% Lift it
    L = 3; % lift_size
    P_lifted = liftMatrixCarefully(P, L);
    H = logical(P_lifted);
    girths(i) = girth_of_H(H);
end

[gMax, i] = max(girths);

gMax
