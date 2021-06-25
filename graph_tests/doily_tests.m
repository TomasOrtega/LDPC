clear; close all;
% Fix random seed.
random_seed = 10;
rng(random_seed);
P = get_doily_H();
H = logical(P);
[M, N] = size(H);
K = N - M;
R = K / N;

girth_of_H(H)

plot_H(H);

%% Lift it
girth_of_H(H)
L = 3; % lift_size
P_lifted = liftMatrixCarefully(P, L);
N = L * N;
K = L * K;
H = logical(P_lifted);
girth_of_H(H)
plot_H(H);
