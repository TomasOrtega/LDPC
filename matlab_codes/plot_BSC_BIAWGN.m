% Various plots of BSC and BI-AWGN channel capacities
clear; clc; close all;
set(groot, 'defaulttextinterpreter', 'latex');
set(groot, 'defaultAxesTickLabelInterpreter', 'latex');
set(groot, 'defaultLegendInterpreter', 'latex');

SNR = linspace(0.001, 8, 1e4);
sigma = SNR2sigma(SNR);
cBSC = BSC_capacity_SNR(SNR);
cBIAWGN = BIAWGN_Capacity(sigma);

figure; hold on;
plot(SNR, cBIAWGN, 'DisplayName', 'BI-AWGN');
plot(SNR, cBSC, ':', 'DisplayName', 'BSC');
xlabel('SNR (not in dBs!)')
ylabel('Channel capacity (bits/channel use)')
legend('location', 'best')

%% same, but in EbNo (dBs)
SNRdB = linspace(-20, 20, 1e4);
SNR = db2pow(SNRdB);
sigma = SNR2sigma(SNR);
cBSC = BSC_capacity_SNR(SNR);
cBIAWGN = BIAWGN_Capacity(sigma);
EbNo = SNR2EbNo(SNR, 1);

bscbiawgn = figure(); hold on;
plot(pow2db(EbNo), cBIAWGN, 'DisplayName', 'BI-AWGN');
plot(pow2db(EbNo), cBSC, ':', 'DisplayName', 'BSC');
xlabel('$E_b/N_0$ (dB)')
xlim([min(SNRdB), 10]);
ylabel('Channel capacity (bits/channel use)')
legend('location', 'best')
exportgraphics(bscbiawgn, 'BSC_BIAWGN_capacity.pdf')

%% same, but in ps
ps = linspace(1e-3, 0.4, 1e4);
cBSC = BSC_capacity(ps);
SNR = Pe2SNR(ps);
cBIAWGN = BIAWGN_Capacity(SNR2sigma(SNR));

figure; hold on;
plot(ps, cBIAWGN, 'DisplayName', 'BI-AWGN');
plot(ps, cBSC, ':', 'DisplayName', 'BSC');
xlabel('$P_e$')
ylabel('Channel capacity (bits/channel use)')
legend('location', 'best')

%xlim([min(ps),max(ps)])
%ylim(ylim) % fixes the current limits
%exportgraphics(gcf,'BSC_BIAWGN_capacity.pdf')
