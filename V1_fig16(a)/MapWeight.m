function [w,map,u] = MapWeight(Map,Input,H,EcBase,EdBase,x,y,k,Q,u,payload)
%%%% Return the weight and the mapping
%%%  k: In-degree
w = 0;
map = Map;
xr = [0,-1,0,-1]; yr = [0,0,-1,-1];

in_or = Input(x+1,y+1); %%% The original in-degree
x1 = x+xr(in_or+1); y1 = y+yr(in_or+1);
x2 = x+xr(k+1); y2 = y+yr(k+1);
%%%% Adjust the mapping
if k ~= in_or
    map1 = Map{x1+1,y1+1};
    map1(in_or+1) = 0;
    map{x1+1,y1+1} = map1;
    
    map2 = Map{x2+1,y2+1};
    map2(k+1) = 1;
    map{x2+1,y2+1} = map2;
end
%%% Calculate the performance
MapEc = zeros(Q+1,Q+1);
MapEd = zeros(Q+1,Q+1);
dis = [0,1,1,2];
for i = 0:Q
    for j = 0:Q
        if i<= Q && j <= Q
            map1 = map{i+1,j+1};
            k = length(find(map1==1));
            MapEc(i+1,j+1) = log2(k);
            MapEd(i+1,j+1) = sum(dis.*map1)/k;
        end
    end
end
Ec = EcBase + sum(sum(H.*MapEc));
Ed = EdBase + sum(sum(H.*MapEd));
w = Ed^2 + u*(Ec-payload)^2;
u = u - (Ec-payload)^2;
t = 1;
end

