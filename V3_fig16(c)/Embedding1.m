function [I,nBit] = Embedding1(I,payload,Aux,N,PEx,PEy,XiPos,XjPos,YiPos,YjPos,R,Map,NL,S,Q)
% Actual embedding
J = I;

data = randperm(512^2); % Secret message
nBit = 0; % Amount of embedded bits
nData = 1;
dis = 0;
count  = 0;
[A,B] = size(I);
% modification
xm = [0,1,0,1];
ym = [0,0,1,1];

for t = 1:N
    % Is payload satisfied? 
    if nBit >= payload
        break;
    end
    % Is complexity satisified?
    k = R(NL(t)) - 1;
    if k == S+1
        count = count+1;
        continue;
    end
    map = Map{NL(t)}; 
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% embedding
    x = abs(PEx(t))-0.5; y = abs(PEy(t))-0.5;
    xi = XiPos(t);xj = XjPos(t);
    yi = YiPos(t);yj = YjPos(t);  
    
    if  (x <= Q) && (y <= Q)
        s = map{x+1,y+1};
        base = length(s);
        bit = mod(data(fix(t/255)*500+mod(t,255)),base);
        if base == 1
        % Shifting
            a = xm(s+1); b = ym(s+1);
            I(xi,xj) = I(xi,xj)+sign(PEx(t))*a;
            I(yi,yj) = I(yi,yj)+sign(PEy(t))*b;
            dis = dis+a+b;
        else
        % Expansion
            a = xm(s(bit+1)+1); b= ym(s(bit+1)+1);
            I(xi,xj) = I(xi,xj)+sign(PEx(t))*a;
            I(yi,yj) = I(yi,yj)+sign(PEy(t))*b;
            nBit = nBit+log2(base);
            dis = dis+a+b;
            nData = nData + 1;
        end
        continue
    end
    
    if y == k
        bit = mod(data(fix(t/255)*500+mod(t,255)),2);
        nBit = nBit+1;
        nData = nData +1;
        if bit==0
           I(xi,xj) = I(xi,xj)+sign(PEx(t))*1;
           dis = dis + 1;
        else
           I(xi,xj) = I(xi,xj)+sign(PEx(t))*1;
           I(yi,yj) = I(yi,yj)+sign(PEy(t))*1;
           dis = dis + 2;
        end
        continue;
    end
    if x == k
        bit = mod(data(fix(t/255)*500+mod(t,255)),2);
        nBit = nBit+1;
        nData = nData +1;
        if bit==0
           I(yi,yj) = I(yi,yj)+sign(PEy(t))*1;
           dis = dis + 1;
        else
           I(xi,xj) = I(xi,xj)+sign(PEx(t))*1;
           I(yi,yj) = I(yi,yj)+sign(PEy(t))*1;
           dis = dis + 2;
        end
        continue;
    end
    if x < k
        dis = dis + 1;
        I(yi,yj) = I(yi,yj)+sign(PEy(t))*1;
        continue;
    end
    if y < k
        dis = dis + 1;
        I(xi,xj) = I(xi,xj)+sign(PEx(t))*1;
        continue;
    end
    % Shifting
    dis = dis + 2;
    I(xi,xj) = I(xi,xj)+sign(PEx(t))*1;
    I(yi,yj) = I(yi,yj)+sign(PEy(t))*1;
end
MSE = sum(sum(abs(I-J)));
t = 1;
end

