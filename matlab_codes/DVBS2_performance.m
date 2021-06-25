clear; clc; close all;
set(groot, 'defaulttextinterpreter', 'latex');
set(groot, 'defaultAxesTickLabelInterpreter', 'latex');
set(groot, 'defaultLegendInterpreter', 'latex');

T = readtable('../AFF3CT_codes/dvbs2_30it.csv');
N = 64800;
K = N / 2;
R = K / N;

%% Plot stuff
semilogy(T.Eb_N0, T.FER, '--s', 'DisplayName', 'Frame ER')
hold on
semilogy(T.Eb_N0, T.BER, '-o', 'DisplayName', 'Bit ER')

title_string = "$N = %d$, $K = %d$, DVB-S2";
title(sprintf(title_string, N, K));
xlabel('$E_b/N_0$ (dB)')
ylabel('Error rate')
ylim([min(T.BER) / 1.1 1.5])

aux = logspace(log10(1e-8), log10(0.188), 10000);
EbNosLong = db2pow(flip(0.188 - aux));
C = BIAWGN_Capacity(EbNo2sigma(EbNosLong, R));

weak_converse_BER = max(1 - C / R, 0);
semilogy(pow2db(EbNosLong), weak_converse_BER, 'black', 'DisplayName', "Shannon's capacity converse bound")

legend('location', 'best')

exportgraphics(gcf, 'dvbs2_performance.pdf')
