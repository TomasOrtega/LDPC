function [FER, BER] = AWGN_error_rate_no_enc(EbNosdB, R, H, numFrames)
    %AWGN_ERROR_RATE_NO_ENC Runs Monte-Carlo experiments to calculate error rate of
    %LDPC in a BI-AWGN channel without encoding
    %   H must be a sparse boolean matrix
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

        for counter = 1:numFrames
            % Transmit and receive LDPC coded signal data
            encData = false(N, 1);
            modSig = bpskMod(encData);
            rxSig = channel(modSig);
            demodSig = bpskDemod(rxSig);
            rxBits = ldpcDecoder(demodSig);
            numErr = sum(rxBits); % get the bit errors
            ttlErrB = ttlErrB + numErr;
            ttlErrF = ttlErrF + (numErr > 0);
        end

        BER(ii) = ttlErrB / (numFrames * N);
        FER(ii) = ttlErrF / numFrames;
    end

end
