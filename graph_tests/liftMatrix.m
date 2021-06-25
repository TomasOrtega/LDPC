function Hl = liftMatrix(H, l)
    %LIFTMATRIX Lifts a matrix by l
    %   With a random unitary shift
    [n, m] = size(H);
    Hl = zeros(n * l, m * l);

    for i = 0:(n - 1)

        for j = 0:(m - 1)

            if (H(i + 1, j + 1))
                Hl(i * l + 1:(i + 1) * l, j * l + 1:(j + 1) * l) = circshift(eye(l), randi([1 l]), 2);
            end

        end

    end

end
