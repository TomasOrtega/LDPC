function [H, permutation_vector] = systematic_form(H)
    %SYSTEMHTIC_FORM Returns the matrix H in systematic form and the column
    %permutation vector associated with the transformation
    %   H must be a binary matrix, operations are done mod 2
    %   Leaves the left m x m matrix as a unitary matrix
    [m, n] = size(H);
    h = 1; % pivot row
    k = 1; % pivot col

    while (h <= m) && (k <= n)
        [val, i_max] = max(H(h:m, k));
        i_max = i_max + h - 1;

        if val % there is pivot in this col
            % swap rows h and i_max
            H([i_max h], :) = H([h i_max], :);

            for i = 1:m % for all rows ABOVE AND BELOW pivot

                if (i ~= h) && (H(i, k) == 1)
                    H(i, :) = mod(H(i, :) + H(h, :), 2);
                end

            end

            h = h + 1;
        end

        k = k + 1;
    end

    assert(sum(H(m, :)) > 0, 'Rank not maximum!')

    permutation_vector = 1:n;

    % Operations to make H have identity on the left
    for i = 1:m
        % if column i does not have 1 in row i, we have to switch it
        if H(i, i) == 0
            [~, max_j] = max(H(i, :));
            H(:, [i max_j]) = H(:, [max_j i]);
            permutation_vector([i max_j]) = permutation_vector([max_j i]);
            % eliminate all other ones in that column
            for k = 1:m

                if (k ~= i) && (H(k, i) == 1)
                    H(k, :) = mod(H(k, :) + H(i, :), 2);
                end

            end

        end

    end

end
