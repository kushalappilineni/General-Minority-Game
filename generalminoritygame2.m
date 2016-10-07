function [Output] = generalminoritygame2(N,G,M,S)
%K-state MG. Here each player is a matrix (see generalcreateplayers.m),
%with G^M rows and S columns. So in each round, the History is converted
%into decimal form and then that number row is selected. Out of the S
%strategies(columns), the best strategy is selected and that element of
%matrix is the decision of that player.
A1=zeros(100,1);
i1=0;
while (i1+1)*(N+1)/G < (N+1)/2 - 3*sqrt(N+1)/2
    i1=i1+1;
end
j1=0;
while (j1+1)*(N+1)/G < (N+1)/2 + 3*sqrt(N+1)/2
    j1=j1+1;
end

for a=1:100
Player=cell(1,N);
for i=1:N
    Player{i}=generalcreateplayers2(N,G,M,S);
end
 Score=cell(1,N);
for i=1:N                 %create their initial scorecards
    Score{i}=zeros(1,S);
end
History=randi(G,[1,M])-1;    %initial history
Attendance=zeros(5000,1); %chart showing attendance and std. dev at side "1"
XHistory=zeros(1,M);


    for i=1:50000
        A=zeros(N,1);
        Y=1;
        for j=1:M
            if History(1,j)<i1
                XHistory(1,j)=0;
            elseif History(1,j)>j1
                XHistory(1,j)=j1-i1;
            else
                XHistory(1,j)=History(1,j)-i1;
            end
        end
        for j=1:M         
            Y=Y + XHistory(1,j)*((j1-i1+1)^(M-j));  % selecting the row of matrix for each player 
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
        
       p=0;
       while (p+1)*(N+1)/G <=Pop
           p=p+1;
       end
        NewHistory=zeros(1,M);
        NewHistory(1,1)=p;
        if M>=2
        for l=1:M-1             %updating the history
            NewHistory(1,l+1)=History(1,l);
        end
        end
        History=NewHistory;       %updated history
        clear NewHistory
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
        if i>=45001
        Attendance(i-45000,1)=Pop;        %updating attendance on side "1" after the round
        end
    end
    Attendance(:,1)=Attendance(:,1)-(sum(Attendance)/5000);
    A1(a,1)=(sum(Attendance.*Attendance))/(5000*N);
    clear Player
clear Score
clear Attendance
end
Output=sum(A1)/100;

end

