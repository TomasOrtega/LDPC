function sigma = SNR2sigma(SNR)
    %SNR2sigma linear to linear
    sigma = sqrt(1 ./ SNR);
end
