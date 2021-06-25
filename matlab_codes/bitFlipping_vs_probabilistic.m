clear; clc; close all;
set(groot, 'defaulttextinterpreter', 'latex');
set(groot, 'defaultAxesTickLabelInterpreter', 'latex');
set(groot, 'defaultLegendInterpreter', 'latex');

% Fix random seed.
random_seed = 2;
rng(random_seed);

H = readAlist('/home/tomas/Documents/TFM-LDPC/code/MacKay/96.33.964');
H = full(H);
[M, N] = size(H);
K = N - M;

ones_per_column = 3;
R = K / N;

%% Change H to systematic form
[H_systematic, permutation_vector] = systematic_form(H);

% Generate a code generator matrix G from systematic H = [eye(N-K) P]
P = H_systematic(:, N - K + 1:end);
G = [P' eye(K)];
% Permute the column labels back from the systematic change
inverse_permutation(permutation_vector) = 1:length(permutation_vector);
G = G(:, inverse_permutation);
% Asserts that all the elements of H*G' are 0 mod 2
assert(all(~mod(H * G', 2), 'all'))
ldpcDecoder = comm.LDPCDecoder(sparse(logical(H)), 'OutputValue', 'Whole codeword');

%% Monte-carlo
ps = logspace(log10(0.02), log10(0.1), 10);
BERs = ps;
BERsProb = ps;
n_experiments = 100000; % 1670 segons

for k = 1:length(ps)
    p = ps(k);
    errs = 0;
    errsProb = 0;

    for i = 1:n_experiments
        % Generate c from 0 to 2^K - 1
        c = randi([0 1], 1, K);
        % Encode the word to obtain the sent vector s
        s = mod(c * G, 2);
        % Generate error vector.
        e = rand(1, N) < p;
        % Received vector.
        r = mod(s + e, 2);
        % Commercial probabilistic algorithm
        rxBits = ldpcDecoder(4 * (1 - 2 * r)')';
        reorderedBits = rxBits(permutation_vector);
        numErr = biterr(logical(c), reorderedBits(N - K + 1:N));
        errsProb = errsProb + numErr;
        % Decoded received vector, v
        v = logical(belief_propagation_mex(H, r, N));
        reorderedBits = v(permutation_vector);
        numErr = biterr(logical(c), reorderedBits(N - K + 1:N));
        errs = errs + numErr;
    end

    BERs(k) = errs / (n_experiments * K);
    BERsProb(k) = errsProb / (n_experiments * K);
end

%% Plot
semilogy(ps, BERs, '-s', 'DisplayName', 'Random LDPC: bit-flipping')
hold on
semilogy(ps, BERsProb, '-s', 'DisplayName', 'Random LDPC: sum-product')
psLong = linspace(min(ps), max(ps), 1e4);
semilogy(psLong, psLong, 'DisplayName', 'Uncoded')

title_string = '$N = %d$, $K = %d$, %d ones per column';
title(sprintf(title_string, N, K, ones_per_column));
xlabel('Channel probability of error $p$')
ylabel('BER')
xlim([min(ps), max(ps)])

legend('location', 'best')
exportgraphics(gcf, 'bitFlipping_vs_probabilistic.pdf')

%% save
save('bitFlipping_vs_probabilistic')
