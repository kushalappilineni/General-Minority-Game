function [Output] = generalminoritygamenoise(N,G,M,S)
%K-state MG. Here each player is a matrix (see generalcreateplayers.m),
%with G^M rows and S columns. So in each round, the History is converted
%into decimal form and then that number row is selected. Out of the S
%strategies(columns), the best strategy is selected and that element of
%matrix is the decision of that player.
A1=zeros(30,1);
for a=1:30
Player=cell(1,N);
for i=1:N
    Player{i}=generalcreateplayers(G,M,S);
end
 Score=cell(1,N);
for i=1:N                 %create their initial scorecards
    Score{i}=zeros(1,S);
end
Attendance=zeros(1000,1); %chart showing attendance and std. dev at side "1"

    for i=1:3000
        A=zeros(N,1);
        History=randi(G,[1,M])-1;    %noisy history
        Y=1;
        for j=1:M         
            Y=Y + History(1,j)*(G^(M-j));  % selecting the row of matrix for each player 
        end
       for j=1:N
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
            A(j,1)=Player{j}{U}(1,Y);  %the responses of N players
        end
       
        
        Pop=sum(A);
        clear A
        if Pop<=(N-1)/2             %deciding the minority
            minority=1;
        else
            minority=0;
        end
        
       for j=1:N                 %updating the scorecards for strategies
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
        if i>=2001
        Attendance(i-2000,1)=Pop;        %updating attendance on side "1" after the round
        end
    end
    Attendance(:,1)=Attendance(:,1)-(sum(Attendance)/1000);
    A1(a,1)=(sum(Attendance.*Attendance))/(1000*N);
    clear Player
clear Score
clear Attendance
end
Output=sum(A1)/30;

end

