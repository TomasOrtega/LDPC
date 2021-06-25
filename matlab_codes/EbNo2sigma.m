function sigma = EbNo2sigma(EbNo, R)
    %EbNo2sigma linear to linear
    SNR = EbNo2SNR(EbNo, R);
    sigma = SNR2sigma(SNR);
end
