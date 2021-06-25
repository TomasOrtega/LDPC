function BERs = upper_bound_on_BER(H, ps)
    %UPPER_BOUND_ON_BER Computes an upperbound on the error rate of the code
    %using basic probability. An error is made if ANY bit of the received
    %vector after belief propagation is different from a sent bit
    % 0 errors when we receive a codeword + all 0s, probability (1-p)^n
    % 1 error: n possible vectors, with probability (1-p)^n-1 * p
    % 2 errors: n choose 2 possible vectors, with probability (1-p)^n-2 *
    % p^2
    % 3 errors: so on and so forth

    BERs = ps;
    N = size(H, 2);
    max_depth = 1;

    while nchoosek(N, max_depth) < 1e4
        max_depth = max_depth + 1;
    end

    max_depth = max_depth - 1;
    errs = zeros(1, max_depth);
    subsets_amount = 1:max_depth;

    for i = 1:max_depth
        subsets = nchoosek(1:N, i);
        subsets_amount(i) = nchoosek(N, i);

        for j = 1:size(subsets, 1)
            s = zeros(1, N);
            s(subsets(j, :)) = 1;
            v = belief_propagation_mex(H, s, N);
            errs(i) = errs(i) + sum(v);
        end

    end

    for k = 1:length(ps)
        exps = 1:max_depth;
        p = ps(k);
        prob_errs = ((1 - p).^(N - exps)) .* (p.^exps);
        BERs(k) = sum(errs .* prob_errs);
        prob_other = 1 - sum(subsets_amount .* prob_errs) - (1 - p)^N;
        BERs(k) = BERs(k) + prob_other * N;
    end

    BERs = BERs / N;
end
