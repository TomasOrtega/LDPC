clear; clc; close all;
set(groot, 'defaulttextinterpreter', 'latex');
set(groot, 'defaultAxesTickLabelInterpreter', 'latex');
set(groot, 'defaultLegendInterpreter', 'latex');

T = readtable('../AFF3CT_codes/outputs/Q52.csv');
T2 = readtable('../AFF3CT_codes/outputs/Q52lifted5.csv');
T4 = readtable('../AFF3CT_codes/outputs/Q52lifted20.csv');

%% Plot stuff
semilogy(T.Eb_N0, T.BER, '-o', 'DisplayName', '$Q^-(5,2)$ code')
hold on
semilogy(T2.Eb_N0, T2.BER, '-x', 'DisplayName', '5-lifted $Q^-(5,2)$ code')
semilogy(T4.Eb_N0, T4.BER, '-s', 'DisplayName', '20-lifted $Q^-(5,2)$ code')

title('$k$-lifts of the $Q^-(5,2)$ code');
xlabel('$E_b/N_0$ (dB)')
ylabel('BER')
ylim([1e-5/1.0001, 0.2])
%xlim([0, 1.8])

legend('location', 'best')

exportgraphics(gcf, 'Q52lifts.pdf')
