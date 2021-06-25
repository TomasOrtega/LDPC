function ps = AWGN_to_BSC(SNR)
    %AWGN_to_BSC Changes SNR to BSC p assuming AWGN + hard-decision
    % See https://en.wikipedia.org/wiki/Phase-shift_keying#Bit_error_rate
    ps = qfunc(sqrt(SNR));
end
