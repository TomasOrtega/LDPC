clear; clc; close all;
set(groot, 'defaulttextinterpreter', 'latex');
set(groot, 'defaultAxesTickLabelInterpreter', 'latex');
set(groot, 'defaultLegendInterpreter', 'latex');

% Fix random seed.
random_seed = 3;
rng(random_seed);
H = readAlist("../AFF3CT_codes/alists/H44lifted2.alist");
[~, N] = size(H);
K = N - gfrank(H);

ones_per_column = 3;
R = K / N;

H = readAlist("../MacKay/PEGirReg252x504");

%% Generate random H with a fixed number of ones per column
[M, N] = size(H);

Raux = (N - gfrank(H)) / N;

while R > Raux
    H = H(1:end - 1, :);
    Raux = (N - gfrank(H)) / N;
end

writeAlist(H, 'PEGreduced')
