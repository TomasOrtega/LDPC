clear; clc; close all;
set(groot, 'defaulttextinterpreter', 'latex');
set(groot, 'defaultAxesTickLabelInterpreter', 'latex');
set(groot, 'defaultLegendInterpreter', 'latex');

% Fix random seed.
random_seed = 3;
rng(random_seed);
load('plot_BER_AWGN_Q53.mat');

%%
T_GQ = readtable('../AFF3CT_codes/outputs/Q53.csv');
T = readtable('../AFF3CT_codes/outputs/randomforQ53.csv');

EbNosLong = linspace(db2pow(1), db2pow(6), 1000);
semilogy(T.Eb_N0, T.BER, '-s', 'DisplayName', 'LDPC random: sum-product')
hold on
semilogy(T_GQ.Eb_N0, T_GQ.BER, '-s', 'DisplayName', 'GQ LDPC: sum-product')
semilogy(pow2db(EbNosLong), AWGN_to_BSC(EbNo2SNR(EbNosLong, 1)), 'DisplayName', 'Uncoded')

title_string = '$N = %d$, $K = %d$, %d ones per column, random seed %d';
title(sprintf(title_string, N, K, ones_per_column, random_seed));
title('$Q^-(5,3)$ vs. random code with 5 ones per column')
xlabel('$E_b/N_0$ (dB)')
ylabel('BER')
ylim([min(T_GQ.BER), 0.1])

legend('location', 'best')

%% save
exportgraphics(gcf, 'plot_BER_AWGN_Q53_aff3ct.pdf')
