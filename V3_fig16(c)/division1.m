function [flag] = division1(h,b,Q)
%DIVISION 此处显示有关此函数的摘要
%   此处显示详细说明
flag = zeros(Q+1,Q+1);

H1 = h(b+1,b+1);
if b+1 > Q
    H2 = 0;
else
    H2 = h(b+2,b+2);
end
stoop = 1;
while stoop == 1
    stable = 1;
    passive = []; active = [];
    for x = b:Q
        for y = b:Q
            old_flag = flag(x+1,y+1);
            Hd = h(x+1,y+1);
            d1 = abs(H1-Hd);
            d2 = abs(H2-Hd);
            new_flag = 0;
            if d1 > d2
                new_flag = 1;
                active = [active Hd];
            else
                passive = [passive Hd];
            end
            if new_flag ~= old_flag
                stable = 0;
            end
            flag(x+1,y+1) = new_flag;
        end
    end
    if stable == 1
        break;
    end
    if isempty(passive)
        H1 = 0;
    else
        H1 = mean(passive);
    end
    if isempty(active)
        H2 = 0;
    else
        H2 = mean(active);
    end
end

t = 1;
end

