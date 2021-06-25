clear; clc; close all;
set(groot, 'defaulttextinterpreter', 'latex');
set(groot, 'defaultAxesTickLabelInterpreter', 'latex');
set(groot, 'defaultLegendInterpreter', 'latex');

% Fix random seed.
random_seed = 6;
rng(random_seed);

addpath('../graph_tests/'); % To see graph test functions

%% Generate H from Doily
P = get_doily_H();
H = logical([eye(15) P]);
H = readAlist('../MacKay/PEGirReg252x504');
[M, N] = size(H);
K = N - M;
R = K / N;

L = 1; % lift_size
P = liftMatrixCarefully(P, L);
N = L * N;
K = L * K;
M = L * M;
% H = logical([eye(N-K), P]);
%% Change H to systematic form
[H_systematic, permutation_vector] = systematic_form(H);

%% Doily experiments

% Generate a code generator matrix G from systematic H = [eye(N-K) P]
P = H_systematic(:, N - K + 1:end);
G = [P' eye(K)];
% Permute the column labels back from the systematic change
inverse_permutation(permutation_vector) = 1:length(permutation_vector);
G = G(:, inverse_permutation);
% Asserts that all the elements of H*G' are 0 mod 2
assert(all(~mod(H * G', 2), 'all'))

%% Run experiments
numFrames = 1000;
EbNosdB = [0, 0.5, 1:0.25:5];
[FER, BER] = AWGN_error_rate(EbNosdB, R, K, ...
    H, G, permutation_vector, numFrames);

%% Plot results
semilogy(EbNosdB, FER, '-s', 'DisplayName', 'LDPC Doily FER')
hold on

title_string = '$N = %d$, $K = %d$, random seed %d';
title(sprintf(title_string, N, K, random_seed));
xlabel('$E_b/N_0$ (dB)')
ylabel('Error rate')

EbNos = db2pow(EbNosdB);
EbNosLong = linspace(min(EbNos), max(EbNos), 1000);
C = BIAWGN_Capacity(EbNo2sigma(EbNosLong, R));

weak_converse = max(1 - C / R, 0); % FER bound
semilogy(pow2db(EbNosLong), weak_converse, ':', 'DisplayName', 'Shannon weak converse')

legend('location', 'best')

%% save
save('plot_FER_Doily')
