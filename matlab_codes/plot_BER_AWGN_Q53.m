clear; clc; close all;
set(groot, 'defaulttextinterpreter', 'latex');
set(groot, 'defaultAxesTickLabelInterpreter', 'latex');
set(groot, 'defaultLegendInterpreter', 'latex');

% Fix random seed.
random_seed = 3;
rng(random_seed);

%% Generate H from Generalized Quadrangle
% Take out transposed if Q(3,q)
H_GQ = load('../gap_code/incidence_matrices/Q53.txt')';
N = size(H_GQ, 2);
NmK = gfrank(H_GQ);
K = N - NmK;
R = K / N;
ones_per_column = ceil(mean(sum(H_GQ)));

if (mod(ones_per_column, 2) == 0)
    ones_per_column = ones_per_column + 1;
end

%% Generate "random" H with a fixed number of ones per column

H = generate_random_H(N, K, ones_per_column);

%% Making Gs

% Change H to systematic form
[H_systematic, permutation_vector] = systematic_form(H);

% Generate a code generator matrix G from systematic H = [eye(N-K) P]
P = H_systematic(:, N - K + 1:end);
Gsystematic = [P' eye(K)];
% Permute the column labels back from the systematic change
inverse_permutation(permutation_vector) = 1:length(permutation_vector);
G = Gsystematic(:, inverse_permutation);
% Asserts that all the elements of H*G' are 0 mod 2
assert(all(~mod(H * G', 2), 'all'))

% Change H to systematic form
[H_GQ_systematic, permutation_vector_GQ] = systematic_form_rank(H_GQ);

% Generate a code generator matrix G from systematic H = [eye(N-K) P]
P_GQ = H_GQ_systematic(:, N - K + 1:end);
Gsystematic_GQ = [P_GQ' eye(K)];
% Permute the column labels back from the systematic change
inverse_permutation_GQ(permutation_vector_GQ) = 1:length(permutation_vector_GQ);
G_GQ = Gsystematic_GQ(:, inverse_permutation_GQ);
% Asserts that all the elements of H*G' are 0 mod 2
assert(all(~mod(H_GQ * G_GQ', 2), 'all'))

%% Run experiment
EbNosdB = 1:0.25:5;
EbNos = db2pow(EbNosdB);
numEF = 100;
[FER, BER, numFrames] = AWGN_ER_by_frame_error(EbNosdB, R, K, H, G, permutation_vector, numEF);
[FERGQ, BERGQ, numFramesGQ] = AWGN_ER_by_frame_error(EbNosdB, R, K, H_GQ, G_GQ, permutation_vector_GQ, numEF);

%% Plot results
T = readtable('../AFF3CT_codes/outputs/3ones.csv');
EbNosLong = linspace(min(db2pow(T.Eb_N0)), max(db2pow(T.Eb_N0)), 1000);
%semilogy(T.Eb_N0,T.BER, '-s', 'DisplayName', 'LDPC random: sum-product')
semilogy(EbNosdB, BER, '-s', 'DisplayName', 'LDPC random: sum-product')
hold on
semilogy(EbNosdB, BERGQ, '-s', 'DisplayName', 'GQ LDPC: sum-product')

semilogy(pow2db(EbNosLong), AWGN_to_BSC(EbNo2SNR(EbNosLong, 1)), 'DisplayName', 'Uncoded')

title_string = '$N = %d$, $K = %d$, %d ones per column, random seed %d';
title(sprintf(title_string, N, K, ones_per_column, random_seed));
title('$Q^-(5,3)$ vs. random code with 5 ones per column')
xlabel('$E_b/N_0$ (dB)')
ylabel('BER')

legend('location', 'best')

%% save
exportgraphics(gcf, 'plot_BER_AWGN_Q53.pdf')
save('plot_BER_AWGN_G53_with_random')
