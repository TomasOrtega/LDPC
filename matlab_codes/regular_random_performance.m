clear; clc; close all;
set(groot, 'defaulttextinterpreter', 'latex');
set(groot, 'defaultAxesTickLabelInterpreter', 'latex');
set(groot, 'defaultLegendInterpreter', 'latex');

T = readtable('../AFF3CT_codes/outputs/random_regular.csv');
N = 2e4;
K = N / 2;
R = K / N;

%% Plot stuff
T.BER(end) = 0;
semilogy(T.Eb_N0, T.BER, '-o', 'DisplayName', '$(3,6)$-regular random code')
hold on
Tw = readtable('../AFF3CT_codes/outputs/wifi_long.csv');
semilogy(Tw.Eb_N0, Tw.BER, '-o', 'DisplayName', 'Wi-Fi code')

title_string = "$N = %d$, $K = %d$, $(3,6)$-regular random code";
title(sprintf(title_string, N, K));
xlabel('$E_b/N_0$ (dB)')
ylabel('BER')
ylim([1e-5/1.1, 0.15])
xlim([0, 1.8])

EbNosLong = linspace(db2pow(0), db2pow(0.2), 10000);
C = BIAWGN_Capacity(EbNo2sigma(EbNosLong, R));
weak_converse_BER = max(1 - C / R, 0);
semilogy(pow2db(EbNosLong), weak_converse_BER, 'black', 'DisplayName', "Shannon's capacity converse bound")

EbNosLong2 = linspace(db2pow(0), db2pow(1.8), 10000);
uncoded = AWGN_to_BSC(EbNo2SNR(EbNosLong2, 1));
semilogy(pow2db(EbNosLong2), uncoded, 'yellow', 'DisplayName', "Uncoded")

legend('location', 'best')

exportgraphics(gcf, 'random_regular.pdf')
