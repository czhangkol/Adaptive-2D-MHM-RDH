function [MapBase,InBase] = BaseMap(S,Q)
% Generate the initial 2D mapping

MapBase = cell(1,S+1);
InBase = cell(1,S+1);

for b = 0:S
    Map = cell(Q+1,Q+1); % Mapping 
    Input = ones(Q+1,Q+1)*-1; % In-degree
    for x = 0:Q
        for y = 0:Q
            Map{x+1,y+1} = [0,0,0,0];
            
            if x < b && y < b
                Input(x+1,y+1) = 0;
                Map{x+1,y+1} = [1,0,0,0];
                continue;
            end
            if (x==b) && (y==b)
                Input(x+1,y+1) = 0; %%%% In:(x,y)
                Map{x+1,y+1} = [1,1,1,1];
                continue;
            end
            if x < b && y == b
                Input(x+1,y+1) = 0;
                Map{x+1,y+1} = [1,0,1,0];
                continue;
            end
            if y < b && x == b
                Input(x+1,y+1) = 0;
                Map{x+1,y+1} = [1,1,0,0];
                continue;
            end
            if y == b
                Input(x+1,y+1) = 1; %&&&& In:(x-1,y)
                Map{x+1,y+1} = [0,1,0,1];
                continue;
            end
            if x == b
                Input(x+1,y+1) = 2; %%%%% In:(x,y-1)
                Map{x+1,y+1} = [0,0,1,1];
                continue;
            end
            if y < b
                Input(x+1,y+1) = 1; %&&&& In:(x-1,y)
                Map{x+1,y+1} = [0,1,0,0];
                continue;
            end
            if x < b
                Input(x+1,y+1) = 2; %%%%% In:(x,y-1)
                Map{x+1,y+1} = [0,0,1,0];
                continue;
            end
            Input(x+1,y+1) = 3; %%%%% In:(x-1,y-1)
            Map{x+1,y+1} = [0,0,0,1];
        end
    end
    MapBase{b+1} = Map;
    InBase{b+1} = Input;
end

t = 1;
end

