function v = belief_propagation_sparse(H, v, N)
    %BELIEF_PROPAGATION_ITERATIVE Performs belief propagation of H with v
    %   Outputs corrected v
    %if ~exist('max_itr', 'var')
    %    max_itr = N;
    %end
    max_itr = N;

    for j = 1:max_itr
        w_v = syndrome(H, v);

        if w_v < 1
            return
        end

        % Compute weights of v + errors.
        ws = zeros(1, N);

        for i = 1:N
            ve = v;
            ve(i) = ~v(i);
            ws(i) = syndrome(H, ve);
        end

        % If there is a better syndrome, propagate beleif
        [min_w, i] = min(ws);

        if (min_w < w_v)
            v(i) = ~v(i);
        end

    end

end
