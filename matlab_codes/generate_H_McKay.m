function H = generate_H_McKay(N, K, ones_per_column)
    % Generates parity check matrix H as in MacKay paper,
    % consecutive columns may not overlap in more than one position.
    H = false(N - K, N);
    prev = false(N - K, 1);
    prev(1:ones_per_column) = true;

    for i = 1:N
        row = prev(randperm(N - K));

        while sum(and(row, prev)) > 1
            row = row(randperm(N - K));
        end

        H(:, i) = row;
        prev = row;
    end

end
