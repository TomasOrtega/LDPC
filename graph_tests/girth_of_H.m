function g = girth_of_H(H)
    %GIRTH_OF_H Girth of a parity check matrix
    %   Using local girth
    g = inf;
    [m, ~] = size(H);

    for i = 1:m
        g = min(g, girth_of_H_at(H, i));
    end

end
