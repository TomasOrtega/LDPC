function Hl = liftMatrixCarefully(H, l)
    %LIFTMATRIXCAREFULLY Lifts a base matrix 'carefully' by l
    %   With an identity shift chosen with care
    [m, n] = size(H);
    Hl = false(m * l, n * l);
    girth = inf;

    for i = 0:(m - 1)

        for j = 0:(n - 1)

            if (H(i + 1, j + 1))
                best_k = 0;
                best_girth = inf;
                first = true;

                for k = 0:(l - 1) % maybe a shuffle works better
                    Hl(i * l + 1:(i + 1) * l, j * l + 1:(j + 1) * l) = false(l);
                    Hl(i * l + 1:(i + 1) * l, j * l + 1:(j + 1) * l) = circshift(eye(l), k, 2);
                    cand_girth = girth_of_H_at(Hl, i * l + 1);

                    if (first || (cand_girth > best_girth))
                        best_k = k;
                        best_girth = cand_girth;
                        first = false;
                    end

                end

                Hl(i * l + 1:(i + 1) * l, j * l + 1:(j + 1) * l) = false(l);
                Hl(i * l + 1:(i + 1) * l, j * l + 1:(j + 1) * l) = circshift(eye(l), best_k, 2);
            end

        end

    end

end
