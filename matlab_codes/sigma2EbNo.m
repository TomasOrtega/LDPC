function EbNo = sigma2EbNo(sigma, R)
    %sigma2EbNo linear to linear
    SNR = 1 ./ (sigma.^2);
    EbNo = SNR2EbNo(SNR, R);
end
