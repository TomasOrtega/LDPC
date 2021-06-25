function H = generate_regular_H(N, K, ones_per_column, ones_per_row)
    %GENERATE_REGULAR_H Generates a regular H
    %   With a fixed number of ones per column and row
    assert(N * floor(ones_per_column) == (N - K) * floor(ones_per_row))
    H = zeros(N - K, N);
    ones_at_rows = zeros(N - K, 1);

    for i = 1:N
        rows = 1:N - K;
        rows = rows(ones_at_rows < ones_per_row);
        % shuffle rows
        rows = rows(randperm(length(rows)));

        if (length(rows) < ones_per_column)
            H = generate_regular_H(N, K, ones_per_column, ones_per_row);
            return;
        end

        H(rows(1:ones_per_column), i) = 1;
        ones_at_rows(rows(1:ones_per_column)) = ones_at_rows(rows(1:ones_per_column)) + 1;
    end

end
