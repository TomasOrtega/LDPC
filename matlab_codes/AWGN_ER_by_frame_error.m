function [FER, BER, numFrames] = AWGN_ER_by_frame_error(EbNosdB, R, K, H, G, permutation_vector, numEF)
    %AWGN_ER_BY_FRAME_ERROR Runs Monte-Carlo experiments to calculate error rate of
    %LDPC in a BI-AWGN channel until numEF number of error frames are reached
    %   G must be a full boolean matrix
    H = sparse(logical(H));
    G = logical(G);
    [~, N] = size(H);
    bitsPerSymbol = 1; % BPSK
    codedEbNosdB = EbNosdB + pow2db(R);
    ldpcDecoder = comm.LDPCDecoder(H, 'OutputValue', 'Whole codeword');
    bpskMod = comm.BPSKModulator();
    bpskDemod = comm.BPSKDemodulator('DecisionMethod', 'Approximate log-likelihood ratio');
    channel = comm.AWGNChannel('BitsPerSymbol', bitsPerSymbol);

    BER = zeros(1, length(EbNosdB));
    FER = zeros(1, length(EbNosdB));

    for ii = 1:length(EbNosdB)
        ttlErrB = 0;
        ttlErrF = 0;
        channel.EbNo = codedEbNosdB(ii);
        numFrames = 0;

        while ttlErrF < numEF
            numFrames = numFrames + 1;
            data = logical(randi([0 1], K, 1));
            % Transmit and receive LDPC coded signal data
            encData = logical(mod(data' * G, 2))';
            modSig = bpskMod(encData);
            rxSig = channel(modSig);
            demodSig = bpskDemod(rxSig);
            rxBits = ldpcDecoder(demodSig);
            reorderedBits = rxBits(permutation_vector);
            numErr = biterr(data, reorderedBits(N - K + 1:N)); % get the data bits
            ttlErrB = ttlErrB + numErr;
            ttlErrF = ttlErrF + (numErr > 0);
        end

        BER(ii) = ttlErrB / (numFrames * K);
        FER(ii) = ttlErrF / numFrames;
    end

end
