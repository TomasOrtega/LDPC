function adjacency = H2adjacency(H)
    %H2ADJACENCY Transforms H to adjacency matrix
    [m, n] = size(H);
    A = false(m + n);
    A(1:n, n + 1:m + n) = H';
    A(n + 1:n + m, 1:n) = H;
    adjacency = A;
end
