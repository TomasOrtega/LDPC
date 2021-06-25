function cap = BSC_capacity_SNR(SNR)
    %BSC_CAPACITY Returns the capacity of a BSC given SNR assuming AWGN + hard
    %decision
    %   Vector input admitted
    ps = AWGN_to_BSC(SNR);
    cap = BSC_capacity(ps);
end
