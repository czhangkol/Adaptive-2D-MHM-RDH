function [R,flag,MSEmin] = MapSearch(Ec,Ed,payload,R,P,flag,MSEmin,S,M,n)
% minimize ED/EC with a given payload
% Search the optimal 2D mapping for each histogram

g = 1; % The start layer
if n > 1
    g = P(n-1);  % no-decrease
end
for t = g:S+2
    P(n) = t;
    x = 0;
    if n == M
        for k = 1:M
            x = x + Ec(k,P(k));
        end
        if x >= payload
            flag = 1;
            y = 0;
            for k = 1:M
                y = y + Ed(k,P(k));
            end
            if y/x < MSEmin
                MSEmin = y/x;
                R = P;
            end
        end
    else
        [R,flag,MSEmin] = MapSearch(Ec,Ed,payload,R,P,flag,MSEmin,S,M,n+1);
    end
end
end

