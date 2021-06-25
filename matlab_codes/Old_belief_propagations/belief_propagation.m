function v = belief_propagation(H, v, N)
    %BELIEF_PROPAGATION Performs belief propagation bit-flipping of v with the parity-check matrix H
    %   Outputs a corrected vector v
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
        v = belief_propagation(H, v, N);
    end

end
