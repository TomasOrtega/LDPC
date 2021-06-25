clear; clc; close all;
set(groot, 'defaulttextinterpreter', 'latex');
set(groot, 'defaultAxesTickLabelInterpreter', 'latex');
set(groot, 'defaultLegendInterpreter', 'latex');

% Fix random seed.
random_seed = 3;
ones_per_column = 5;
rng(random_seed);
Ns = 256 * [1, 2, 2 * 2];
R = 1/2;
bitsPerSymbol = 1; % BPSK
f = @(x) BSC_capacity(x) - R;
plot_right = fzero(f, 0.1);
ps = logspace(log10(0.02), log10(plot_right), 10);
numFrames = 1000;
errRates = zeros(length(Ns), length(ps));

for j = 1:length(Ns)
    N = Ns(j);
    K = R * N;
    %% Generate "random" H with a fixed number of ones per column
    H = generate_random_H(N, K, ones_per_column);

    %% Change H to systematic form
    [H_systematic, permutation_vector] = systematic_form(H);

    % Generate a code generator matrix G from systematic H = [eye(N-K) P]
    P = H_systematic(:, N - K + 1:end);
    Gsystematic = [P' eye(K)];
    % Permute the column labels back from the systematic change
    inverse_permutation = permutation_vector;
    inverse_permutation(permutation_vector) = 1:length(permutation_vector);
    G = Gsystematic(:, inverse_permutation);
    % Asserts that all the elements of H*G' are 0 mod 2
    assert(all(~mod(H * G', 2), 'all'))

    %% Run Monte-Carlo
    bpskMod = comm.BPSKModulator();
    bpskDemod = comm.BPSKDemodulator('DecisionMethod', 'Approximate log-likelihood ratio');
    ldpcDecoder = comm.LDPCDecoder(sparse(H), 'OutputValue', 'Whole codeword');

    for ii = 1:length(ps)
        ttlErr = 0;

        for counter = 1:numFrames
            data = logical(randi([0 1], K, 1));
            % Transmit and receive LDPC coded signal data
            encData = logical(mod(data' * G, 2))';
            % Generate error vector.
            e = logical(rand(N, 1) < ps(ii));
            demodSig = xor(e, encData);
            rxBits = ldpcDecoder(bpskDemod(bpskMod(demodSig)));
            % rxBits = logical(belief_propagation_iterative_mex(H, double(demodSig)', 50))';
            reorderedBits = rxBits(permutation_vector);
            numErr = biterr(data, reorderedBits(N - K + 1:N)); % get the data bits
            ttlErr = ttlErr + numErr;
        end

        ttlBits = numFrames * K;
        errRates(j, ii) = ttlErr / ttlBits;
    end

end

%% plot everything

psLong = linspace(min(ps), max(ps), 1000);

C = BSC_capacity(psLong);
weak_converse_BER = max(1 - 1 / (N * R) - C / R, 0) / K; % this is technically a FER bound, we divide it by K
semilogy(psLong, weak_converse_BER, ':', 'DisplayName', 'Weak converse BER')
hold on

for j = 1:length(Ns)
    N = Ns(j);
    semilogy(ps, errRates(j, :), '-s', 'DisplayName', sprintf('LDPC random , $N=%d$', Ns(j)))
end

title_string = '$R = %g$, %d ones per column, random seed %d';
title(sprintf(title_string, R, ones_per_column, random_seed));
xlabel('$P_e$ (of the BSC)')
ylabel('BER')

legend('location', 'best')

%% save
save('plot_BER_BSC_random')
