function H = PEG_v2(N, K, ones_per_column)
    %PEG_v2 Runs PEG
    %   Where M = N-K
    M = N - K;
    ones_per_row = ceil(ones_per_column * N / M);
    H = false(M, N);

    deg_checks = sum(H, 2);
    deg_vars = sum(H, 1);

    last_j = 0;

    for jj = 1:(ones_per_column * N)

        for j = (mod((0:N - 1) + last_j - 1, N) + 1)
            last_j = j;
            best_i = 1;
            best_girth = inf;
            first = true;

            for i = 1:M
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
