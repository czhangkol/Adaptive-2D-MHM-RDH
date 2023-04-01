function [flag] = division(h,b,Q)
%DIVISION 此处显示有关此函数的摘要
%   此处显示详细说明
flag = zeros(Q+1,Q+1);
H1 = h(b+1,b+1);
if b+1 > Q
    H2 = 0;
else
    H2 = h(b+2,b+2);
end
for x = b:Q
    for y = b:Q
        if x > Q || y > Q
            continue
        end
        if x == b && y == b
            continue
        end
        if x == b+1 && y == b+1
            flag(x+1,y+1) = 1;
            continue
        end
        Hd = h(x+1,y+1); 
        d1 = abs(H1-Hd);
        d2 = abs(H2-Hd);
        if d1 > d2
            flag(x+1,y+1) = 1;
        end
    end
end
t = 1;
end

