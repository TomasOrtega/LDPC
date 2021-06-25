function H = generate_random_H(N, K, ones_per_column)
    %GENERATE_RANDOM_H Generates a left-regular H
    %   With a fixed number of ones per row, and full rank
    %   If ones_per_column is even, this method will not finish
    assert(mod(ones_per_column, 2) == 1, 'ones_per_column is not odd!')

    H = zeros(N - K, N);

    while (gfrank(H, 2) < N - K)
        H = zeros(N - K, N);

        for i = 1:N
            H(randperm(N - K, ones_per_column), i) = 1;
        end

    end

end
