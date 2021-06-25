function cap = BIAWGN_Capacity(sigma)
    %BIAWGN_Capacity Returns the capacity of a BIAWGN given sigma (noise std dv)
    %   Vector input admitted
    if (length(sigma) > 1)
        cap = zeros(1, length(sigma));

        for ii = 1:length(sigma)
            cap(ii) = BIAWGN_Capacity(sigma(ii));
        end

    else
        phi = @(x) (1 ./ (sigma * sqrt(8 * pi))) .* (exp(-((x + 1).^2) ./ (2 * sigma.^2)) + exp(-((x - 1).^2) ./ (2 * sigma.^2)));
        f = @(x) phi(x) .* log2(phi(x));
        cap = -0.5 * log2(2 * pi * exp(1) * sigma^2) -integral(f, -20 * sigma, 20 * sigma);
    end

end
