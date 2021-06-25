close all;
H = hammgen(3);
[M, N] = size(H);
L = 30; % lift_size
A = H2adjacency(H);
G = graph(A);
girth_of_H(H)

P = liftMatrixCarefully(H(:, (M + 1):N), L);
H = [eye(M * L) P];

girth_of_H(H)

%% plot
plot_H(H);
