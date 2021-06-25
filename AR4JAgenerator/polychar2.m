function Vout = polychar2( V )
% Reduces the polynomial (vector) assuming coefficients are 
% characteristic 2.  Assumes input is sorted.

% Written by Brian Butler, 2010

n=length(V);

flag = 0;

for i=2:n,
    
    if V(i) == V(i-1),
        V(i)   = 9e55;   % very big
        V(i-1) = 9e55;   % very big
        flag = 1;
    end
    
end

if (flag),
    V = sort(V);
    n = n - length(find(V > 1e55));
    Vout = V(1:n);
else
    Vout = V; 
end
