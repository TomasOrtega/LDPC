clear; clc; close all;
set(groot, 'defaulttextinterpreter', 'latex');
set(groot, 'defaultAxesTickLabelInterpreter', 'latex');
set(groot, 'defaultLegendInterpreter', 'latex');

T = readtable('../AFF3CT_codes/outputs/PEG.csv');
Tr = readtable('../AFF3CT_codes/outputs/randomPEG.csv');
TGQ = readtable('../AFF3CT_codes/outputs/H44lifted2.csv');

N = 504;
K = N / 2;
R = K / N;

% Fix random seed.
random_seed = 3;
rng(random_seed);
H = readAlist('../AFF3CT_codes/alists/H44lifted2.alist');
NmK = gfrank(H);
K = N - NmK;
R2 = K / N;

%% Plot stuff
semilogy(Tr.Eb_N0, Tr.BER, '-x', 'DisplayName', 'Random 3-regular')
hold on
semilogy(TGQ.Eb_N0, TGQ.BER, '-o', 'DisplayName', '$H(4,4)$ 2-lifted')
semilogy(T.Eb_N0, T.BER, '-s', 'DisplayName', 'PEGirReg252x504')

title_string = "PEGirReg252x504 vs. $H(4,4)$ 2-lifted code vs. random";
title(title_string);
xlabel('$E_b/N_0$ (dB)')
ylabel('BER')
ylim([min(T.BER) 0.2])

aux = logspace(log10(1e-8), log10(0.188), 10000);
EbNosLong = db2pow(flip(0.188 - aux));
C = BIAWGN_Capacity(EbNo2sigma(EbNosLong, R));

weak_converse_BER = max(1 - C / R, 0);
semilogy(pow2db(EbNosLong), weak_converse_BER, 'black', 'DisplayName', "Shannon's converse for $R = 1/2$")

legend('location', 'best')

exportgraphics(gcf, 'PEG_vs_random_vs_GQ.pdf')
