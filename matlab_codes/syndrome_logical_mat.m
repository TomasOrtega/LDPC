function w = syndrome_logical(H, v)
    %SYNDROME Calculates syndrome with H and v (both logical)
    %   Outputs the syndrome logical value
    [n, m] = size(H);
    w = false(n, 1);

    for i = 1:n

        for j = 1:m
            w(i) = xor(w(i), and(H(i, j), v(j)));
        end

    end

end
