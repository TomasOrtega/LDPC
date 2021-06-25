random_seed = 3;
rng(random_seed);
Hgq = logical(load('../gap_code/incidence_matrices/Q52.txt'))';
L = 1; % lift_size
H = liftMatrixCarefully(Hgq, L);
[M, N] = size(H);
K = N - gfrank(H);
R = K / N;
writeAlist(H, 'Q52')
