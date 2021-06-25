clear; clc; close all;
set(groot, 'defaulttextinterpreter', 'latex');
set(groot, 'defaultAxesTickLabelInterpreter', 'latex');
set(groot, 'defaultLegendInterpreter', 'latex');

T = readtable('../AFF3CT_codes/outputs/wifi_long.csv');
Tr = readtable('../AFF3CT_codes/outputs/wifirandom.csv');
N = 1944;
K = N / 2;
R = K / N;

% Fix random seed.
random_seed = 3;
rng(random_seed);
H = generate_random_H(N, K, 3);

%% Plot stuff

semilogy(Tr.Eb_N0, Tr.BER, '--s', 'DisplayName', 'Random code')
hold on
semilogy(T.Eb_N0, T.BER, '-o', 'DisplayName', 'Wi-Fi code')

title_string = "$N = %d$, $K = %d$, WiFi 802.11n";
title(sprintf(title_string, N, K));
xlabel('$E_b/N_0$ (dB)')
ylabel('Error rate')
ylim([1e-5, 0.15])

EbNosLong = linspace(db2pow(0), db2pow(0.2), 10000);
C = BIAWGN_Capacity(EbNo2sigma(EbNosLong, R));
weak_converse_FER = max(1 - C / R, 0);
semilogy(pow2db(EbNosLong), weak_converse_FER, 'black', 'DisplayName', "Shannon's capacity converse bound")

EbNosLong2 = linspace(db2pow(0), db2pow(2.5), 10000);
uncoded = AWGN_to_BSC(EbNo2SNR(EbNosLong2, 1));
semilogy(pow2db(EbNosLong2), uncoded, 'yellow', 'DisplayName', "Uncoded")

legend('location', 'best')

exportgraphics(gcf, 'WiFi_performance.pdf')
