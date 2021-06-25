clear; clc; close all;
set(groot, 'defaulttextinterpreter', 'latex');
set(groot, 'defaultAxesTickLabelInterpreter', 'latex');
set(groot, 'defaultLegendInterpreter', 'latex');

% Fix random seed.
random_seed = 3;
rng(random_seed);

GQ_file = '../gap_code/incidence_matrices/Q43.txt';

%% H from GQ
% Generate H from Generalized Quadrangle
% Take out transposed if Q(3,q)
H = load(GQ_file)';
N = size(H, 2);
NmK = gfrank(H);
K = N - NmK;
R = K / N;
ones_per_column = ceil(mean(sum(H)));

if (mod(ones_per_column, 2) == 0)
    ones_per_column = ones_per_column + 1;
end

% Change H to systematic form
[H_systematic, permutation_vector] = systematic_form_rank(H);

% Generate a code generator matrix G from systematic H = [eye(N-K) P]
P = H_systematic(:, N - K + 1:end);
Gsystematic = [P' eye(K)];
% Permute the column labels back from the systematic change
inverse_permutation_GQ(permutation_vector) = 1:length(permutation_vector);
G = Gsystematic(:, inverse_permutation_GQ);
% Asserts that all the elements of H*G' are 0 mod 2
assert(all(~mod(H * G', 2), 'all'))

%% Run experiments
ps = logspace(log10(0.002), log10(0.1), 10);
numFrames = 10000000; % 4 mins for 10 ps and 1e5 frames;
[FER_line, BER_line] = line_error_rate_mex(ps, K, H, G, permutation_vector, numFrames);
[FER, BER] = BSC_error_rate(ps, K, H, G, permutation_vector, numFrames);

%% Plot results
semilogy(ps, BER, '-s', 'DisplayName', 'Bit-flipping decoding')
hold on
semilogy(ps, BER_line, '-s', 'DisplayName', 'GQ line decoding')
psLong = linspace(min(ps), max(ps), 1e4);
semilogy(psLong, psLong, 'DisplayName', 'Uncoded')

title_string = '$N = %d$, $K = %d$, %d ones per column, random seed %d';
title('$Q(4,3)$ code, line decoding and bit-flipping decoding');
xlabel('Probability of error $p$')
ylabel('BER')
ylim([min(BER(FER * numFrames >= 50)), 0.1]) % fixes the current limits
xlim([min(ps), max(ps)])
%exportgraphics(gcf,'line_decoding.pdf')

legend('location', 'best')

%% save
save('line_decoding_performance')
