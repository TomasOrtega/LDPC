function [FER, BER] = BSC_error_rate(ps, K, H, G, permutation_vector, numFrames)
    %BSC_ERROR_RATE Runs Monte-Carlo experiments to calculate error rate of an LDPC in a BSC channel
    %   G must be a full-rank matrix in systematic form
    %   H must be a parity-check matrix

    BER = zeros(1, length(ps));
    FER = zeros(1, length(ps));
    [~, N] = size(H);

    for i = 1:length(ps)
        p = ps(i);
        ttlErrB = 0;
        ttlErrF = 0;

        for ii = 1:numFrames
            % Generate c from 0 to 2^K - 1
            data = logical(randi([0 1], 1, K));
            % Encode the word to obtain the sent vector s
            encData = mod(data * G, 2);
            % Generate error vector.
            e = rand(1, N) < p;
            % Received vector.
            r = mod(encData + e, 2);
            % Decoded received vector, v
            v = belief_propagation_mex(H, r, N);
            reorderedBits = logical(v(permutation_vector));
            numErr = biterr(data, reorderedBits(N - K + 1:N)); % get the data bits
            ttlErrB = ttlErrB + numErr;
            ttlErrF = ttlErrF + (numErr > 0);
        end

        BER(i) = ttlErrB / (numFrames * K);
        FER(i) = ttlErrF / numFrames;
    end

end
