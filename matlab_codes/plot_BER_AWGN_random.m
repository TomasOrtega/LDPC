% LEGACY CODE, USE AFF3CT LIBRARY FOR RANDOM CODES or ERROR FUNCTION
clear; clc; close all;
set(groot, 'defaulttextinterpreter', 'latex');
set(groot, 'defaultAxesTickLabelInterpreter', 'latex');
set(groot, 'defaultLegendInterpreter', 'latex');

% Fix random seed.
random_seed = 3;
ones_per_column = 5;
rng(random_seed);
Ns = [64, 64 * 4, 64 * 4 * 4, 64 * 4 * 4 * 4];
R = 1/2;
bitsPerSymbol = 1; % BPSK
EbNosdB = [-0.5:0.5:5];
codedEbNosdB = EbNosdB + pow2db(R);
EbNos = db2pow(EbNosdB);
numFrames = 1000;
bpskMod = comm.BPSKModulator();
bpskDemod = comm.BPSKDemodulator('DecisionMethod', 'Approximate log-likelihood ratio');
bpskuDemod = comm.BPSKDemodulator('DecisionMethod', 'Hard decision');
channel = comm.AWGNChannel('BitsPerSymbol', bitsPerSymbol);
errRates = zeros(length(Ns), length(EbNosdB));

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

    ldpcDecoder = comm.LDPCDecoder(sparse(H), 'OutputValue', 'Whole codeword');

    for ii = 1:length(EbNosdB)
        ttlErr = 0;
        channel.EbNo = codedEbNosdB(ii);

        for counter = 1:numFrames
            data = logical(randi([0 1], K, 1));
            % Transmit and receive LDPC coded signal data
            encData = logical(mod(data' * G, 2))';
            modSig = bpskMod(encData);
            rxSig = channel(modSig);
            demodSig = bpskDemod(rxSig);
            rxBits = ldpcDecoder(demodSig);
            reorderedBits = rxBits(permutation_vector);
            numErr = biterr(data, reorderedBits(N - K + 1:N)); % get the data bits
            ttlErr = ttlErr + numErr;
        end

        ttlBits = numFrames * K;
        errRates(j, ii) = ttlErr / ttlBits;
    end

end

%% plot everything

EbNosLong = linspace(min(EbNos), max(EbNos), 1000);
semilogy(pow2db(EbNosLong), AWGN_to_BSC(EbNo2SNR(EbNosLong, 1)), '--', 'DisplayName', 'Uncoded')
hold on
C = BIAWGN_Capacity(EbNo2sigma(EbNosLong, R));
weak_converse_BER = max(1 - 1 / (N * R) - C / R, 0) / K; % this is technically a FER bound, we divide it by K
semilogy(pow2db(EbNosLong), weak_converse_BER, ':', 'DisplayName', 'Weak converse BER')

for j = 1:length(Ns)
    N = Ns(j);
    semilogy(EbNosdB, errRates(j, :), '-s', 'DisplayName', sprintf('LDPC random , $N=%d$', Ns(j)))
end

title_string = '$R = %g$, %d ones per column, random seed %d';
title(sprintf(title_string, R, ones_per_column, random_seed));
xlabel('$E_b/N_0$ (dB)')
ylabel('BER calculated as $\frac{\textrm{Errors in N received bits}}{\textrm{N}}$')

legend('location', 'best')

%% save
save('plot_BER_AWGN_random')
