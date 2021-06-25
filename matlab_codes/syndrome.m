function w = syndrome(H, v)
    %SYNDROME Calculates syndrome with H and v
    %   Outputs the weight of the syndrome
    w = sum(mod(H * v', 2));
end
