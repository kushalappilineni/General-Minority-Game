function [TrPlayer] = generalcreateplayers(G,memory,strategy)
%We create players i.e. matrices for a general minority game. Here N is the
%number of agents, G is the level of degeneracy (i.e. level of granularity)
%   Detailed explanation goes here
    TrPlayer=cell(1,strategy);
    for i=1:strategy
    TrPlayer{i}=randi(2,[1,G^memory])-1;
    end
    
  
end

 

