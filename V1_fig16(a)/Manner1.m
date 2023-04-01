function [performance,ECmax] = Manner1(I,ECfinal,auxR)
%MANNER1 此处显示有关此函数的摘要
%   此处显示详细说明

M = 16; % The amount of histograms
S = 7; % max-bin
Q = 7; % max-layer

%%%%%%%%%%%%% Read the image
[A,B] = size(I);
J = I;
ECmax = 0;
performance = zeros(2,1);
AuxM = 0;
N = fix((B-2)/2)*fix((A-2)/2); % the number of pairwise PE
[MapBase,InBase] = BaseMap(S,Q);
% auxR = 750;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% First layer embedding
Layer = 1;
% [Location map, Compressed location map, cover image]
[LM,data,J] = LocationMap(J,Layer);

% [e(2i-1),e(2i),line index,column index,Complexity]
[PEx,PEy,XiPos,XjPos,YiPos,YjPos,NL,T] = Prediction(J,N,Layer,M);

%%%%%%%%%%%%% Aux information length
% Nend: 16 bits
% Threshold T: log2(N)*M
% MapData & length: To be determined
% LM & length(16 bits)
s = ceil(log2(T(M-1)));
if sum(LM) == 0
    Aux = 16+16+(M-1)*s+auxR;
else
    Aux = 8*length(data)+16+16+(M-1)*s+auxR;
end

EC = ECfinal/2+Aux;

[R,flag,Map,MapAux] = BinSelection(PEx,PEy,NL,EC,S,Q,M,MapBase,InBase);

if flag == 1
    %%%%%%%%%% modify the aux information length
    Mbis = M - 1;
    for i = M:-1:1
        if R(i) == S+2
            Mbis = i-1;
        end
    end
    s = ceil(log2(T(Mbis)));
    if sum(LM) == 0
        Aux = 16*2+Mbis*s+8*length(MapAux)+16+3;
    else
        Aux = 8*length(data)+16*2+Mbis*s+8*length(MapAux)+16+3;
    end

    EC = ECfinal/2+Aux;
    
    %%%%%%% Data Embedding
    [J,nBit] = Embedding1(J,EC,Aux,N,PEx,PEy,XiPos,XjPos,YiPos,YjPos,R,Map,NL,S,Q); 
    ECmax = ECmax+nBit-Aux;
    AuxM = AuxM + Aux;
end
R1 = R;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Second layer embedding
Layer = 2;
% [Location map, Compressed location map, cover image]
[LM,data,J] = LocationMap(J,Layer);

% [e(2i-1),e(2i),line index,column index,Complexity]
[PEx,PEy,XiPos,XjPos,YiPos,YjPos,NL,T] = Prediction(J,N,Layer,M);

%%%%%%%%%%%%% Aux information length
% Nend: 16 bits
% Threshold T: log2(N)*M
% MapData & length: To be determined
% LM & length(16 bits)
s = ceil(log2(T(M-1)));
if sum(LM) == 0
    Aux = 16+16+(M-1)*s+auxR;
else
    Aux = 8*length(data)+16+16+(M-1)*s+auxR;
end

EC = ECfinal/2+Aux;

[R,flag,Map,MapAux] = BinSelection(PEx,PEy,NL,EC,S,Q,M,MapBase,InBase);

if flag == 1
    %%%%%%%%%% modify the aux information length
    Mbis = M - 1;
    for i = M:-1:1
        if R(i) == S+2
            Mbis = i-1;
        end
    end
    s = ceil(log2(T(Mbis)));
    if sum(LM) == 0
        Aux = 16*2+Mbis*s+8*length(MapAux)+16+3;
    else
        Aux = 8*length(data)+16*2+Mbis*s+8*length(MapAux)+16+3;
    end
    EC = ECfinal/2+Aux;
    
    %%%%%%% Data Embedding
    [J,nBit] = Embedding1(J,EC,Aux,N,PEx,PEy,XiPos,XjPos,YiPos,YjPos,R,Map,NL,S,Q); 
    ECmax = ECmax+nBit-Aux;
    AuxM = AuxM + Aux;
end
R2 = R;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  Embed the aux message, LSB
Aux = AuxM;

%%%%%%%%%%% Read the edge pixels
iPos = []; jPos = [];
for i = 1:A
    for j = 1:B
        if i >= 2 && i <= A-2 && j >=2 && j <= B-2
            continue;
        end
        iPos = [iPos i];
        jPos = [jPos j];
    end
end
%%%%%%%%%% Random message
X = randperm(A*B);
M = zeros(A,B);
for i = 1:A
    for j = 1:B
        M(i,j) = mod(X(B*(i-1)+j),2);
    end
end
for t = 1:length(iPos)
     i = iPos(t);j = jPos(t);
     if Aux > 0
         J(i,j) = 2*floor(J(i,j)/2)+M(i,j);
         Aux = Aux-1;
     end
end

MSE1 = sum(sum(abs(J-I)));
PSNR1 = 10*log10(A*B*255^2/MSE1);
MSE=sum(sum(abs(I-J).^2));
PSNR=10*log10((255^2*A*B)/MSE);
performance(1) = ECmax;
performance(2) = PSNR;
end

