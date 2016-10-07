function [Output] = generalmixminoritygame(N1,N2,G,M1,M2,S)
% 1 CZMG agent in a population where all others play a K-state MG. Here each K-state player is a matrix (see generalcreateplayers.m),
%with G^M rows and S columns. So in each round, the History is converted
%into decimal form and then that number row is selected. Out of the S
%strategies(columns), the best strategy is selected and that element of
%matrix is the decision of that player.
A1=zeros(100,2);
for a=1:100
Player=cell(1,N1+N2);
for i=N1+1:N2+N1               %create K-state MG players
    Player{i}=generalcreateplayers(G,M2,S);
end
for i=1:N1                     % create CZMG players
    Player{i}=createCZMGplayers(M1,S);
end
 Score=cell(1,N1+N2);
for i=1:N1+N2                 %create their initial scorecards
    Score{i}=zeros(1,S);
end
History=randi(2,[1,M1])-1;        %initial CZMG History
History1=randi(G,[1,M2])-1;    %initial K-state MG history
Attendance1=zeros(1000,1); 
Attendance2=zeros(1000,1); 
if rem(N1+N2+1,G)==0      %all levels are of same granularity
    R1=2*(N1+N2);           %just a large random number
else                  % the levels of granularity 1 more than the reqd. (same throughout each realization)
R1=sort(randperm(G,rem(N1+N2+1,G)));   % rem(N+1,G) levels are of different granularity
end

    for i=1:10000
        A=zeros(N1+N2,1);
        Y=1;
        for j=1:M1                              % selecting the row of matrix for each CZMG player 
            Y=Y+History(1,j)*(2^(M1-j));
        end
        Y1=1;
        for j=1:M2         
            Y1=Y1 + History1(1,j)*(G^(M2-j));  % selecting the row of matrix for each K-state player 
        end
       for j=1:N1                 %decisions of CZMG players 
            D=zeros(1,S);
            [H,I]=max(Score{j});  %selecting the reqd strategy
            l=1;
            D(1,1)=I;
            for k=I:S;
                if Score{j}(1,k)==H
                    l=l+1;
                    D(1,l)=k;
                end
            end
            U=D(1,randi(l));
            A(j,1)=Player{j}{U}(1,Y);  %the responses of N1 CZMG players
       end
        for j=1+N1:N1+N2
            D=zeros(1,S);
            [H,I]=max(Score{j});  %selecting the reqd strategy
            l=1;
            D(1,1)=I;
            for k=I:S;
                if Score{j}(1,k)==H
                    l=l+1;
                    D(1,l)=k;
                end
            end
            U=D(1,randi(l));
            A(j,1)=Player{j}{U}(1,Y1);  %the responses of K-state players
        end
       
        
        Pop=cumsum(A);
        clear A
        if Pop(N1+N2,1)<=(N1+N2-1)/2             %deciding the minority
            minority=1;
        else
            minority=0;
        end
        
        p=0;                          %selecting the level of granularity
        while p+1<=rem(N1+N2+1,G) && R1(1,p+1)<=Pop(N1+N2,1)/floor((N1+N2+1)/G)
             p=p+1;                    %no of levels having additional granularity level
        end
        NewM=floor((Pop(N1+N2,1)-p)/floor((N1+N2+1)/G));   %final level of granularity
       
        NewHistory=zeros(1,M2);
        NewHistory(1,1)=NewM;
        if M2>=2
        for l=1:M2-1             %updating the history
            NewHistory(1,l+1)=History1(1,l);
        end
        end
        History1=NewHistory;       %updated history
        NewHistory=zeros(1,M1);
        NewHistory(1,1)=minority;
        for l=1:M1-1             %updating the history
            NewHistory(1,l+1)=History(1,l);
        end
        History=NewHistory;       %updated history  
        clear NewHistory
        for j=1:N1               %updating the scorecards of CZMG for strategies
            NewScore=zeros(1,S);
            for k=1:S;
                if Player{j}{k}(1,Y)==minority;
                   NewScore(1,k)=Score{j}(1,k)+1;
                else
                   NewScore(1,k)=Score{j}(1,k);
                end
            end
            Score{j}=NewScore;    %updated scorecards
            clear NewScore
        end
        for j=N1+1:N1+N2                 %updating the scorecards for DIMG for strategies
            NewScore=zeros(1,S);
            for k=1:S;
                if Player{j}{k}(1,Y1)==minority;
                   NewScore(1,k)=Score{j}(1,k)+1;
                else
                   NewScore(1,k)=Score{j}(1,k);
                end
            end
            Score{j}=NewScore;    %updated scorecards
            clear NewScore
        end
        if i>=9001
            if minority==1
               Attendance2(i-9000,1)=(Pop(N1+N2,1)-Pop(N1,1))/N2;
               Attendance1(i-9000,1)=Pop(N1,1)/N1;
           else
               Attendance2(i-9000,1)=(N2-Pop(N1+N2,1)+Pop(N1,1))/N2;
               Attendance1(i-9000,1)=(N1-(Pop(N1,1)))/N1;
           end
        end
    end
    A1(a,1)=sum(Attendance1)/1000;
    A1(a,2)=sum(Attendance2)/1000;
    clear Player
clear Score
clear Attendance
end
Output=sum(A1)/100;

end

