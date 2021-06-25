function min_dist = estimated_min_hamming_dist(G)
    %ESTIMATED_MIN_HAMMING_DIST Outputs the minimum Hamming distance of a
    %number of random iterations of the code. Not formal, but gives an upper
    %bound of the minimum Hamming distance
    [K, min_dist] = size(G);
    n_loop = min(1e6, floor(1e8 / min_dist));

    for k = 1:n_loop
        c = randi(2, 1, K) - 1;

        while sum(c) < 1
            c = randi([0 1], 1, K);
        end

        s = mod(c * G, 2);
        min_dist = min(min_dist, sum(s));
    end

end
