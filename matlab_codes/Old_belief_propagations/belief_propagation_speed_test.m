clear; clc; close all;
set(groot, 'defaulttextinterpreter', 'latex');
set(groot, 'defaultAxesTickLabelInterpreter', 'latex');
set(groot, 'defaultLegendInterpreter', 'latex');

% Fix random seed.
random_seed = 3;
rng(random_seed);

N = 273;
K = 191;
ones_per_column = 3;
R = K / N;

%%
% Generate "random" H with a fixed number of ones per column
H = zeros(N - K, N);

while (gfrank(H, 2) < N - K)
    H = zeros(N - K, N);

    for i = 1:N
        H(randperm(N - K, ones_per_column), i) = 1;
    end

end

%%

% Change H to systematic form
[H_systematic, permutation_vector] = systematic_form(H);

% Generate a code generator matrix G from systematic H = [eye(N-K) P]
P = H_systematic(:, N - K + 1:end);
Gsystematic = [P' eye(K)];
% Permute the column labels back from the systematic change
inverse_permutation(permutation_vector) = 1:length(permutation_vector);
G = Gsystematic(:, inverse_permutation);
% Asserts that all the elements of H*G' are 0 mod 2
assert(all(~mod(H * G', 2), 'all'))

%%
% Change H to systematic form
[H_systematic, permutation_vector] = systematic_form(H);

% Generate a code generator matrix G from systematic H = [eye(N-K) P]
P = H_systematic(:, N - K + 1:end);
G = [P' eye(K)];
% Permute the column labels back from the systematic change
inverse_permutation(permutation_vector) = 1:length(permutation_vector);
G = G(:, inverse_permutation);
% Asserts that all the elements of H*G' are 0 mod 2
assert(all(~mod(H * G', 2), 'all'))
Hlogical = logical(H);
Hsparse = sparse(H);

p = 0.01/2;
n_experiments = 10;
Rs = zeros(n_experiments, N);

for i = 1:n_experiments
    % Generate c from 0 to 2^K - 1
    c = randi([0 1], 1, K);
    % Encode the word to obtain the sent vector s
    s = mod(c * G, 2);
    % Generate error vector.
    e = rand(1, N) < p;
    % Received vector.
    r = mod(s + e, 2);
    Rs(i, :) = r;
end

tic

for i = 1:n_experiments
    r = Rs(i, :);
    v = belief_propagation_sparse_mex(Hsparse, r, 200);
end

timer_sparse = toc
tic

for i = 1:n_experiments
    r = Rs(i, :);
    v = belief_propagation_iterative_mex(H, r, 200);
end

timer_iterative = toc
tic

for i = 1:n_experiments
    r = Rs(i, :);
    v = belief_propagation_mex(H, r, 200);
end

timer_recursive = toc
tic

for i = 1:n_experiments
    r = Rs(i, :);
    v = belief_propagation_fast_mex(H, r, 200, ones_per_column);
end

timer_fast = toc
Rs = logical(Rs);
[n, m] = size(H);
% tic
% for i=1:n_experiments
%     r = Rs(i,:);
%     v = belief_propagation_cpp(Hlogical,r,n,m,200);
% end
% timer_logical = toc
%%
save('belief_propagation_speed_test')
