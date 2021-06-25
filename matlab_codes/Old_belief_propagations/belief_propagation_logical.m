function v = belief_propagation_logical(H, v, N)
    %BELIEF_PROPAGATION_LOGICAL Performs belief propagation of H with v, both
    %logical
    %   Outputs res, which is corrected v
    %if ~exist('max_itr', 'var')
    %    max_itr = N;
    %end
    coder.extrinsic('syndrome_logical');
    max_itr = N;

    for j = 1:max_itr
        % syndrome of v
        [n, m] = size(H);
        % mex -setup c++
        % mex syndrome_logical.cpp
        sv = false(n, 1);
        sv = syndrome_logical(H, v, n, m)';
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
