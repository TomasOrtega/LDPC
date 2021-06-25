clear; clc; close all;
set(groot, 'defaulttextinterpreter', 'latex');
set(groot, 'defaultAxesTickLabelInterpreter', 'latex');
set(groot, 'defaultLegendInterpreter', 'latex');

T = readtable('../AFF3CT_codes/outputs/H44.csv');
T2 = readtable('../AFF3CT_codes/outputs/H44lifted2.csv');
T4 = readtable('../AFF3CT_codes/outputs/H44lifted4.csv');
N = 297;
K = 177;
R = K / N;

%% Plot stuff
semilogy(T.Eb_N0, T.BER, '-o', 'DisplayName', '$H(4,4)$ code')
hold on
semilogy(T2.Eb_N0, T2.BER, '-x', 'DisplayName', '2-lifted $H(4,4)$ code')
semilogy(T4.Eb_N0, T4.BER, '-s', 'DisplayName', '4-lifted $H(4,4)$ code')

title('$k$-lifts of the $H(4,4)$ code');
xlabel('$E_b/N_0$ (dB)')
ylabel('BER')
ylim([1e-5/1.0001, 0.2])
%xlim([0, 1.8])

legend('location', 'best')

exportgraphics(gcf, 'H44lifts.pdf')
