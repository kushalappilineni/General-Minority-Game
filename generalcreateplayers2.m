function [TrPlayer] = generalcreateplayers2(N,G,memory,strategy)
%We create players i.e. matrices for a general minority game. Here N is the
%number of agents, G is the level of degeneracy (i.e. level of granularity)
%   Detailed explanation goes here
TrPlayer=cell(1,strategy);  

  i=1;
  while i*(N+1)/G < (N+1)/2 -3*(sqrt(N+1))/2
     
   i=i+1;
  end
  j=1;

  while j*(N+1)/G < (N+1)/2 +3*(sqrt(N+1))/2
     
     j=j+1;
  end
  for o=1:strategy
      TrPlayer{o}=randi(2,[1,(j-i+1)^memory])-1;
  end
end

 