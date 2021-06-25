clear; clc; close all;
set(groot, 'defaulttextinterpreter', 'latex');
set(groot, 'defaultAxesTickLabelInterpreter', 'latex');
set(groot, 'defaultLegendInterpreter', 'latex');

T = readtable('../AFF3CT_codes/LDPC_N16200_K13320_hlayered_NMS_i40_DVB-S2.csv');
N = 16200;
K = 13320;
R = K / N;

%% Plot stuff

semilogy(T.Eb_N0, T.FER, '--s', 'DisplayName', 'Frame ER')
hold on
%semilogy(T.Eb_N0,T.BER, '-o', 'DisplayName', 'Bit ER')
title_string = "$N = %d$, $K = %d$, DVB-S2";
title(sprintf(title_string, N, K));
xlabel('$E_b/N_0$ (dB)')
ylabel('Error rate')
xlim([2.2, 3.7])
ylim([min(T.FER) / 1.5 1.5])

EbNosLong = linspace(db2pow(2.2), max(EbNos), 1e4);
C = BIAWGN_Capacity(EbNo2sigma(EbNosLong, R));
weak_converse_BER = max(1 - C / R, 0);
semilogy(pow2db(EbNosLong), weak_converse_BER, 'black', 'DisplayName', "Shannon's capacity converse bound")

legend('location', 'best')

xline(2.7, ':', 'DisplayName', '')
xline(3.3, ':', 'DisplayName', '')
text(2.3, 1/5, 'Error region')
text(2.8, 1/5e4, 'Waterfall region')
text(3.32, 1/1e3, 'Error floor region')

exportgraphics(gcf, 'dvbs2_nms_performance.pdf')
