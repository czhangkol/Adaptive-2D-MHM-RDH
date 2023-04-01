function [MapSetbis,InSet,Ec,Ed] = MapG(PEx,PEy,NL,S,Q,M,MapBase,InBase,payload)
% Change the start layer from 0 to S
% Generate S+1 2D mappings for each histogram
% The max optimized layer is Q

MapSet = cell(M,S+1); % The mappings
InSet = cell(M,S+1); % The in-degree
Ec = zeros(M,S+2);
Ed = zeros(M,S+2);
N = length(PEx);


%%%% Generate the 2D histogram
H = cell(1,M);
for r = 1:M
    h = zeros(Q+1,Q+1);
    for t = 1:N
        x = abs(PEx(t))-0.5; y = abs(PEy(t))-0.5;
        if x<=Q && y<=Q
            if NL(t) == r
                h(x+1,y+1) = h(x+1,y+1) + 1;
            end
%             h(x+1,y+1) = h(x+1,y+1) + 1;
        end
    end
    H{r} = h;
end
%%%%% Performance for the no-optimized dots
EcBase = zeros(M,S+1);
EdBase = zeros(M,S+1);
for r = 1:M
    for b = 0:S
        for t = 1:N
            x = abs(PEx(t))-0.5; y = abs(PEy(t))-0.5;
            if NL(t) ~= r
                continue;
            end
            if x<=Q && y<=Q
                continue;
            end
            if (x==b) || (y==b)
                EcBase(r,b+1) = EcBase(r,b+1) + 1;
                EdBase(r,b+1) = EdBase(r,b+1) + 3/2;
                continue;
            end
            if (x<b) || (y<b)
                EdBase(r,b+1) = EdBase(r,b+1) + 1;
                continue;
            end
            EdBase(r,b+1) = EdBase(r,b+1) + 2;
        end
    end
end
%%%%%% Generate the optimal 2D mappings
scoreBais = 10000000;
for r = 1:M
    h = H{r}; 
    for b = 0:S
        u = 10^12;
        Map = MapBase{b+1}; Input = InBase{b+1};
        for i = 0:Q+Q % i: current layer
            for x = 0:i
                y = -1*x+i;
                if x > Q || y > Q
                    continue
                end
                if (x < b+1) || (y < b+1)
                    continue
                end
                if (x == b) && (y == b)
                    continue
                end
%                 if x == b
%                     [w,map,u0]   = MapWeight(Map,Input,h,EcBase(r,b+1),EdBase(r,b+1),x,y,0,Q,u,payload);
%                     [w2,map2,u2] = MapWeight(Map,Input,h,EcBase(r,b+1),EdBase(r,b+1),x,y,2,Q,u,payload);
%                     if w < w2
%                         Input(x+1,y+1) = 0;
%                         Map = map; u = u0;
%                     else
%                         Input(x+1,y+1) = 2;
%                         Map = map2; u = u2;
%                     end
%                     continue;
%                 end
%                 if y == b
%                     [w,map,u0]   = MapWeight(Map,Input,h,EcBase(r,b+1),EdBase(r,b+1),x,y,0,Q,u,payload);
%                     [w1,map1,u1] = MapWeight(Map,Input,h,EcBase(r,b+1),EdBase(r,b+1),x,y,1,Q,u,payload);
% 
%                     if w < w1
%                         Input(x+1,y+1) = 0;
%                         Map = map; u = u0;
%                     else
%                         Input(x+1,y+1) = 1;
%                         Map = map1; u = u1;
%                     end
%                     continue;
%                 end
    
                [w,map,u0]   = MapWeight(Map,Input,h,EcBase(r,b+1),EdBase(r,b+1),x,y,0,Q,u,payload);
                [w1,map1,u1] = MapWeight(Map,Input,h,EcBase(r,b+1),EdBase(r,b+1),x,y,1,Q,u,payload);
                [w2,map2,u2] = MapWeight(Map,Input,h,EcBase(r,b+1),EdBase(r,b+1),x,y,2,Q,u,payload);
                [w3,map3,u3] = MapWeight(Map,Input,h,EcBase(r,b+1),EdBase(r,b+1),x,y,3,Q,u,payload);
                %%% Afjust the weight for reversibility
                if (Input(x+1,y) ~= 1) && (Input(x,y+1) ~= 2)
                     w3 = 0-abs(w1)-abs(w2)-abs(w3);
                end
                if (w <= w1) && (w <= w2) && (w <= w3)
                    Input(x+1,y+1) = 0;
                    Map = map; u = u0;
                elseif (w1 <= w) && (w1 <= w2) && (w1 <= w3)
                    Input(x+1,y+1) = 1;
                    Map = map1; u = u1;
                elseif (w2 <= w) && (w2 <= w1) && (w2 <= w3)
                    Input(x+1,y+1) = 2;
                    Map = map2; u = u2;
                elseif (w3 <= w) && (w3 <= w1) && (w3 <= w2) 
                    Input(x+1,y+1) = 3;
                    Map = map3; u = u3;
                end
            end
        end
        MapSet{r,b+1} = Map;
        InSet{r,b+1} = Input;
    end
end
% for r = 1:M
%     for b = 0:S
%         MapSet{r,b+1} = MapBase{b+1};
%     end
% end

%%%%% Calculate the performance
MapSetbis = cell(M,S+1);
dis = [0,1,1,2];
for r = 1:M
    h = H{r};
    for b = 0:S
        MapEc = zeros(Q+1,Q+1); MapEd = zeros(Q+1,Q+1);
        MapBis = cell(Q+1,Q+1);
        Map = MapSet{r,b+1}; 
        for x = 0:Q
            for y = 0:Q
                if x<= Q && y<=Q
                    map = Map{x+1,y+1};
                    k = length(find(map==1));
                    MapEc(x+1,y+1) = log2(k);
                    MapEd(x+1,y+1) = sum(dis.*map)/k;
                    %%%% Translate the mapping
                    for i = 1:length(map)
                        if map(i) == 1
                            MapBis{x+1,y+1} = sort([MapBis{x+1,y+1},i-1]);
                        end
                    end
                end
            end
        end
        MapSetbis{r,b+1} = MapBis;
        Ec(r,b+1) = EcBase(r,b+1) + sum(sum(MapEc.*h));
        Ed(r,b+1) = EdBase(r,b+1) + sum(sum(MapEd.*h));
    end
end

t = 1;
end

