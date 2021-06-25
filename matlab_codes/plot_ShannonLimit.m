clear; clc; close all;
set(groot, 'defaulttextinterpreter', 'latex');
set(groot, 'defaultAxesTickLabelInterpreter', 'latex');
set(groot, 'defaultLegendInterpreter', 'latex');

N = 1000;
K = 0.5 * N;

R = K / N;

EbNodB = linspace(0, 2, 1e4);
C = BIAWGN_Capacity(EbNo2sigma(db2pow(EbNodB), R));
% Weak converse for discrete memoryless channels
weak_converse_BER = max(1 - 1 / (N * R) - C / R, 0);
semilogy(EbNodB, weak_converse_BER, 'DisplayName', 'Weak converse Shannon')
hold on

% Strong converse for discrete memoryless channels
% As derived from the weak converse equation, with n=1.
As = ((R - C).^2) .* ((C + 1) / R - exp(-(R - C) / 2)) / 4;
strong_converse_BER = 1 - 4 * As ./ (N * (R - C).^2) - exp(-N * (R - C) / 2);
strong_converse_BER = max(strong_converse_BER, 0);
semilogy(EbNodB, strong_converse_BER, ':', 'DisplayName', 'Strong converse Shannon')

% Limit weak converse for discrete memoryless channels
limit_weak_converse_BER = max(1 - C / R, 0);
semilogy(EbNodB, limit_weak_converse_BER, 'DisplayName', 'Limit Weak converse Shannon')
hold on
legend('location', 'best')

title_string = '$N = %d$, $K = %d$, Shannon limit plots';
title(sprintf(title_string, N, K));
xlabel('$E_b/N_0$ (dB)')
ylabel('BER')

%% Plot for various rates
% The shannon limit is not the limit weak converse
% See Shannon http://www.inference.org.uk/mackay/codes/images/shannon.png

Rs = [1/5, 1/2];
figure
EbNodB = linspace(-1.5, 1, 1e4);
EbNo = db2pow(EbNodB);
semilogy(EbNodB, AWGN_to_BSC(EbNo2SNR(EbNo, 1)), '--', 'DisplayName', 'Uncoded');
hold on

for i = 1:length(Rs)
    R = Rs(i);
    C = BIAWGN_Capacity(EbNo2sigma(EbNo, R));
    limit_weak_converse_BER = max(1 - C / R, 0);
    semilogy(EbNodB, limit_weak_converse_BER, 'DisplayName', 'Limit Weak converse Shannon')
end

ylim([1e-6 1])
