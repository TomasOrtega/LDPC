% Plot some sparse check matrices (H) for different LDPC codes
clear; clc; close all;
set(groot, 'defaulttextinterpreter', 'latex');
set(groot, 'defaultAxesTickLabelInterpreter', 'latex');
set(groot, 'defaultLegendInterpreter', 'latex');

%% Wi-Fi plot
B = [57, -1, -1, -1, 50, -1, 11, -1, 50, -1, 79, -1, 1, 0, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1;
    3, -1, 28, -1, 0, -1, -1, -1, 55, 7, -1, -1, -1, 0, 0, -1, -1, -1, -1, -1, -1, -1, -1, -1;
    30, -1, -1, -1, 24, 37, -1, -1, 56, 14, -1, -1, -1, -1, 0, 0, -1, -1, -1, -1, -1, -1, -1, -1;
    62, 53, -1, -1, 53, -1, -1, 3, 35, -1, -1, -1, -1, -1, -1, 0, 0, -1, -1, -1, -1, -1, -1, -1;
    40, -1, -1, 20, 66, -1, -1, 22, 28, -1, -1, -1, -1, -1, -1, -1, 0, 0, -1, -1, -1, -1, -1, -1;
    0, -1, -1, -1, 8, -1, 42, -1, 50, -1, -1, 8, -1, -1, -1, -1, -1, 0, 0, -1, -1, -1, -1, -1;
    69, 79, 79, -1, -1, -1, 56, -1, 52, -1, -1, -1, 0, -1, -1, -1, -1, -1, 0, 0, -1, -1, -1, -1;
    65, -1, -1, -1, 38, 57, -1, -1, 72, -1, 27, -1, -1, -1, -1, -1, -1, -1, -1, 0, 0, -1, -1, -1;
    64, -1, -1, -1, 14, 52, -1, -1, 30, -1, -1, 32, -1, -1, -1, -1, -1, -1, -1, -1, 0, 0, -1, -1;
    - 1, 45, -1, 70, 0, -1, -1, -1, 77, 9, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 0, 0, -1;
    2, 56, -1, 57, 35, -1, -1, -1, -1, -1, 12, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 0, 0;
    24, -1, 61, -1, 60, -1, -1, 27, 51, -1, -1, 16, 1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 0];

[m, n] = size(B);
l = 81;
H = zeros(m * l, n * l);

for i = 1:m

    for j = 1:n

        if B(i, j) < 0
            H((i - 1) * l + 1:i * l, (j - 1) * l + 1:j * l) = zeros(l);
        else
            H((i - 1) * l + 1:i * l, (j - 1) * l + 1:j * l) = circshift(eye(l), B(i, j), 2);
        end

    end

end

wifi = figure;
spy(H)
xlabel('')
title 'WiFi (802.11n), rate $1/2$'
exportgraphics(wifi, 'wifi_parity_check.pdf')

%% NASA plot
H = load('/home/tomas/Documents/TFM-LDPC/code/AR4JAparitycheck/AR4JA_r12_k4096.mat').H;
nasa = figure;
spy(H)
title 'NASA''s AR4JA, rate $1/2$'
xlabel('')
exportgraphics(nasa, 'nasa_parity_check.pdf')

%% DVB-S2 plot
H = dvbs2ldpc(1/2);
dvbs2 = figure;
set(dvbs2, 'Units', 'centimeters', 'Position', [10 10 20 10]);
subplot(1, 2, 1)
spy(H)
title 'DVB-S2, rate $1/2$'
xlabel('')
ax = gca;
ax.DataAspectRatio = [1 1 1];
subplot(1, 2, 2)
spy(H(:, 1:1e3))
xlabel('$x$-axis zoom-in to see the circulants')
ax = gca;
ax.DataAspectRatio = [1 64 1];
exportgraphics(dvbs2, 'dvbs2_parity_check.pdf')
