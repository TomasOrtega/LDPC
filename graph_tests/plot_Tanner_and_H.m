clear; clc; close all;
set(groot, 'defaulttextinterpreter', 'latex');
set(groot, 'defaultAxesTickLabelInterpreter', 'latex');
set(groot, 'defaultLegendInterpreter', 'latex');

H = [1 0 1 0 1; 1 1 1 1 0; 0 1 1 1 1];

%PLOT_H Plots the tanner graph corresponding to H
%sp = figure;
%spy(H);

%%
[M, N] = size(H);
A = H2adjacency(H);
G = graph(A);
tanner = figure();
p = plot(G);
hold on;
% Make it pretty
p.XData(1:N) = 1;
p.XData((N + 1):end) = 2;
p.YData(1:N) = flip(linspace(0, 2, N));
p.YData((N + 1):end) = flip(linspace(0.5, 1.5, M));
p.Marker = 'o';
p.MarkerSize = 6;
nlabel = strings(N + M, 1);

for i = 1:N
    lab = strcat("v_{", num2str(i), "}");
    nlabel(i) = lab;
end

p.NodeLabel = nlabel;

checks = plot(graph(zeros(M)));
checks.XData(:) = 2;
checks.YData(:) = flip(linspace(0.5, 1.5, M));
checks.Marker = 's';
checks.MarkerSize = 7;
nlabel = strings(M, 1);

for i = 1:M
    lab = strcat("c_{", num2str(i), "}");
    nlabel(i) = lab;
end

checks.NodeLabel = nlabel;
hold off;
