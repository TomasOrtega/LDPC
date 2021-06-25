function v = belief_propagation_fast(H, v, N, c)
    % c is ones per column
    max_itr = N;

    for j = 1:max_itr
        sv = mod(H * v', 2);
        % weight of the syndrome
        w_v = sum(sv);

        if w_v == 0
            return
        end

        % Compute number of unsatisfied constraints
        uns = sv' * H;
        flip_bits = uns > c / 2;
        % Flip bits which have a majority of unsatisfied constraints
        v = xor(v, flip_bits);
        % if no fast flipping was done, perform slow flipping
        if ~any(flip_bits)
            % Compute weights of v + errors.
            ws = zeros(1, N);

            for i = 1:N
                % calculate syndrome of v + e
                sve = xor(sv, H(:, i));
                ws(i) = sum(sve);
            end

            % If there is a better syndrome, propagate beleif
            [min_w, i] = min(ws);

            if (min_w < w_v)
                v(i) = ~v(i);
            end

        end

    end

end
