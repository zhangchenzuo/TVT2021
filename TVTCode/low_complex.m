function [solution, exitflag]=low_complex(Aeq,beq,nMS,Tarrive,deadline, seglen,initialtime)
total_time=initialtime;
solution=zeros(total_time,nMS);
resi_data = beq;
if deadline>100
    a=2;
end
Aeq = Aeq+normrnd(0,0.0001,[1 initialtime]);
for i=1:nMS
    sort_Aeq=sort(Aeq(i,:),'descend');
    for k=1:Tarrive(i)+deadline
        [~,n(i,k)]=find(Aeq(i,:)==sort_Aeq(k));
        n(i,k)=n(i,k)-initialtime*(i-1);
        solution(n(i,k),i)=1-sum(solution(n(i,k),:));
        if (resi_data(i,:) - sort_Aeq(k)*solution(n(i,k),i))<0
            solution(n(i,k),i)=resi_data(i,:)/sort_Aeq(k);
            resi_data(i,:)= 0;
            break;
        else
            resi_data(i,:)= resi_data(i,:) - sort_Aeq(k)*solution(n(i,k),i);
        end
    end
end
if sum(sum(resi_data))~=0
    exitflag=0;
else
    exitflag=1;
end