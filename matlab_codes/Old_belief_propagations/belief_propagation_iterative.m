function v = belief_propagation_iterative(H, v, N)
    %BELIEF_PROPAGATION_ITERATIVE Performs belief propagation of H with v
    %   Outputs res, which is corrected v
    %if ~exist('max_itr', 'var')
    %    max_itr = N;
    %end
    max_itr = N;

    for j = 1:max_itr
        % syndrome of v
        sv = mod(H * v', 2);
        % weight of the syndrome
        w_v = sum(sv);

        if w_v == 0
            return
        end

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
