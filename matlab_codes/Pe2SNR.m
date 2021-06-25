function SNR = Pe2SNR(ps)
    %Pe2SNR Changes Pe probability of bit flipping to BPSK equivalent SNR
    % See https://en.wikipedia.org/wiki/Phase-shift_keying#Bit_error_rate
    SNR = (qfuncinv(ps).^2);
end
