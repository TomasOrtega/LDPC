function H = get_doily_H()
    %GET_DOILY_H Generates the point-line incidence matrix of the Doily
    points = nchoosek(1:6, 2);
    lines_cand = nchoosek(1:15, 3);
    lines = [];

    for i = 1:length(lines_cand)
        points_line = points(lines_cand(i, :), :);
        full_line = true;

        for j = 1:6
            full_line = full_line && any(points_line == j, 'all');
        end

        if (full_line)
            lines = [lines; lines_cand(i, :)];
        end

    end

    H = false(15, 15);

    for i = 1:15

        for j = 1:15

            if (any(lines(j, :) == i))
                H(i, j) = true;
            end

        end

    end

end
