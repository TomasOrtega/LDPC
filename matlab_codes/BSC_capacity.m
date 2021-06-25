function cap = BSC_capacity(ps)
    %BSC_CAPACITY Returns the capacity of a BSC given p
    %   Vector input admitted
    cap = ps;

    for i = 1:length(ps)
        p = ps(i);

        if p == 0
            cap(i) = 1;
        else
            cap(i) = 1 + p * log2(p) + (1 - p) * log2(1 - p);
        end

    end

end
