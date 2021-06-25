function H = PEG_left_Id(N, K, ones_per_column)
    %PEG_LEFT_ID Runs PEG leaving the left MxM block of H as an identity matrix
    %   Where M = N-K
    M = N - K;
    ones_per_row = ceil(K * ones_per_column / M) + 1;
    H = false(M, N);
    H(1:M, 1:M) = eye(M);

    deg_checks = sum(H, 2);
    deg_vars = sum(H, 1);

    for j = (M + 1):N
        % add edges until we have desired number of edges in column (if possible)
        edges_to_add = ones_per_column - deg_vars(j);

        for jj = 1:edges_to_add
            best_i = 1;
            best_girth = inf;
            first = true;

            for i = random_shuffle(1:M)
                % check if we can add a one in this position
                if (~H(i, j)) && (deg_checks(i) < ones_per_row)
                    H(i, j) = true;
                    cand_girth = girth_of_H_at(H, i);

                    if (first || (cand_girth >= best_girth))
                        best_i = i;
                        best_girth = cand_girth;
                        first = false;

                        if cand_girth == Inf
                            break;
                        end

                    end

                    H(i, j) = false;
                end

            end

            if ~first
                H(best_i, j) = true;
                deg_vars(j) = deg_vars(j) + 1;
                deg_checks(best_i) = deg_checks(best_i) + 1;
            end

        end

    end

end
