function v = line_decoding(H, v, max_it)
    %LINE_DECODING Performs iterative decoding of v with the parity-check matrix H
    %   Outputs a corrected vector v

    if max_it < 1
        return
    end

    w_v = syndrome(H, v);

    if w_v < 1
        return
    end

    % Compute weights of v + errors.
    N = size(H, 2);

    ws = zeros(1, N);

    for i = 1:N
        ve = v;
        ve(i) = ~v(i);
        ws(i) = syndrome(H, ve);
    end

    % Flag bits to-flip
    to_flip = ws < w_v;

    if any(to_flip)
        reliable = false(1, N);

        for i = 1:N
            eqs = H(:, i);
            adjacent = any(H(eqs, :), 1);
            both = and(adjacent, to_flip);
            reliable(i) = (2 * sum(both)) >= sum(adjacent);
        end

        reliable_ws = ws .* reliable;

        % If there is a reliable flip, propagate it first
        if any(reliable_ws)
            [~, i] = min(reliable_ws);
            v(i) = ~v(i);
            v = line_decoding(H, v, max_it - 1);
        else
            [~, i] = min(ws);
            v(i) = ~v(i);
            v = line_decoding(H, v, max_it - 1);
        end

    end

end
