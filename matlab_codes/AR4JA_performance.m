clear; clc; close all;
set(groot, 'defaulttextinterpreter', 'latex');
set(groot, 'defaultAxesTickLabelInterpreter', 'latex');
set(groot, 'defaultLegendInterpreter', 'latex');

T = readtable('ar4ja.csv');
N = 8192;
K = 4096;
R = K / N;

%% Plot stuff
semilogy(T.Eb_N0, T.FER, '--s', 'DisplayName', 'Frame ER')
hold on
semilogy(T.Eb_N0, T.BER, '-o', 'DisplayName', 'Bit ER')

title_string = "$N = %d$, $K = %d$, NASA's AR4JA";
title(sprintf(title_string, N, K));
xlabel('$E_b/N_0$ (dB)')
ylabel('Error rate')
ylim([1e-6 1])
EbNos = db2pow(T.Eb_N0);

EbNosLong = linspace(db2pow(0), db2pow(0.2), 10000);
C = BIAWGN_Capacity(EbNo2sigma(EbNosLong, R));

weak_converse_BER = max(1 - C / R, 0);
semilogy(pow2db(EbNosLong), weak_converse_BER, 'black', 'DisplayName', "Shannon's capacity converse bound")

legend('location', 'best')

exportgraphics(gcf, 'AR4JA_performance.pdf')
