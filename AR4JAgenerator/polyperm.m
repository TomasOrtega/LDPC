function p = polyperm( Hx )
% Computes the permament of square matrix, H(x)
%   The entries are assumed to be exponents of monomials.
%   Negative entries used for empty location.

% Written by Brian Butler, 2010

[m n]=size(Hx);

if (m ~= n),
    error('Error. Matrix passed to polyperm() was not square %d %d\n',m,n)
end

if (m == 1),
    if ( (Hx(1,1) >= 0) ),
        p = Hx(1,1);
    else
        p = [];  % empty list
    end
        
elseif (m == 2),
    if ( (Hx(1,1) >= 0) && (Hx(2,2) >= 0) ),
        p = Hx(1,1)+Hx(2,2);  % adding exponents
    else
        p = [];  % empty list
    end
        
    if ( (Hx(1,2) >= 0) && (Hx(2,1) >= 0) ),
        p = [p Hx(1,2)+Hx(2,1)];    % concatenate
    end
    
else
    p = [];  % start w/ empty list
    for ind = 1:m,
        compind = [1:(ind-1) (ind+1):m];  % complementary indices to m
        if (Hx(1,ind) >= 0)
            p = [p   Hx(1,ind) + polyperm(Hx(2:m,compind))]; % concatenate
                             % using recursion for cofactor expansion
        end
    end
end

return
