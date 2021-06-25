clear; clc; close all;
set(groot, 'defaulttextinterpreter', 'latex');
set(groot, 'defaultAxesTickLabelInterpreter', 'latex');
set(groot, 'defaultLegendInterpreter', 'latex');

% Fix random seed.
random_seed = 1;
rng(random_seed);

%% Generate H from Generalized Quadrangle
% Take out transposed if Q(3,q)
H_GQ = load('../gap_code/incidence_matrices/Q43.txt');

N = size(H_GQ, 2);
NmK = gfrank(H_GQ);
K = N - NmK;
selected_rows = randperm(size(H_GQ, 1), N - K);
H = H_GQ(selected_rows, :);

while (gfrank(H, 2) < N - K)
    selected_rows = randperm(size(H_GQ, 1), N - K);
    H = H_GQ(selected_rows, :);
end

R = K / N;

%% Change H to systematic form
[H_systematic, permutation_vector] = systematic_form(H);

%% Generate a code generator matrix G from systematic H = [eye(N-K) P]
P = H_systematic(:, N - K + 1:end);
G = [P' eye(K)];
% Permute the column labels back from the systematic change
inverse_permutation(permutation_vector) = 1:length(permutation_vector);
G = G(:, inverse_permutation);
% Asserts that all the elements of H*G' are 0 mod 2
assert(all(~mod(H * G', 2), 'all'))

ps = logspace(log10(0.002), log10(0.1), 10);

%% Run experiments
numFrames = 100000; % 3 mins for 10 ps and 1e5 frames
[FER, BER] = BSC_error_rate(ps, K, H, G, permutation_vector, numFrames);
[FER_GQ, BER_GQ] = BSC_error_rate(ps, K, H_GQ, G, permutation_vector, numFrames);

%% plot results
semilogy(ps, BER, '-s', 'DisplayName', 'Reduced $Q(4,3)$ code')
hold on;
semilogy(ps, BER_GQ, '-s', 'DisplayName', '$Q(4,3)$ code')
psLong = linspace(min(ps), max(ps), 1e4);
semilogy(psLong, psLong, 'DisplayName', 'Uncoded')

title_string = '$N = %d$, $K = %d$, $Q(4,3)$ code';
ones_per_column = mean(sum(H, 1));
title(sprintf(title_string, N, K));
xlabel('Probability of error $p$')
ylabel('BER')
ylim([1e-4, 1e-1])
xlim([min(ps), max(ps)])
legend('location', 'best')

%% save results
exportgraphics(gcf, 'full_vs_reduced.pdf')
save('full_vs_reduced.mat')
