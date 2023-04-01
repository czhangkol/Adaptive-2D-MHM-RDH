function [R,flag,Map,MapAux] = BinSelection(PEx,PEy,NL,payload,S,Q,M,MapBase,InBase)
% The optimization
% select the optimal 2D mappings
R = zeros(1,M);
Map = cell(1,M);
flag = 0;


%%% Generate Q+1 mappings for each sub-histogram
[MapSet,InSet,Ec,Ed] = MapG(PEx,PEy,NL,S,Q,M,MapBase,InBase,payload);
%%%%%% Compress the Mappings
for r = 1:M
    for b = 0:S
        Input = InSet{r,b+1}+1;
        Input_or = InBase{b+1}+1;
        for i = 1:Q+1
            for j = 1:Q+1
                if Input(i,j) == Input_or(i,j)
                    if Input(i,j)~=0
                        Input(i,j) = 0;
                    end
                end
            end
        end
        InSet{r,b+1} = Input;
    end
end

%%%%%% Optimize the parameter
P = zeros(1,M);
MSEmin = 10000000000000000;
n = 1;
[R,flag,MSEmin] = MapSearch(Ec,Ed,payload,R,P,flag,MSEmin,S,M,n);
EC = 0; ED = 0;
%%%%%% Save the optimal 2D mappings
MapData = [];
if flag == 1
    for i = 1:M
        if R(i) == S+2
            Map{i} = R(i);
        else
            Map{i} = MapSet{i,R(i)};
            Input = InSet{i,R(i)};
            for x = 1:Q+1
                for y = 1:Q+1
                    MapData = [MapData Input(x,y)];
                end
            end
        end
        EC = EC + Ec(i,R(i));
        ED = ED + Ed(i,R(i));
    end
end
xC = cell(1,1);
xC{1} = MapData;
MapAux = arith07(xC);
t = 1;
end

