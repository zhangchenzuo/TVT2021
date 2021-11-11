function [solution,completeTime,serveBS,avgRate,deadline]...
    = newplan_bisearch_sampling(sample, initialtime,W1,alphaL1,T_f,T_s,...
    Nt,serveBS1,usernum,transformation,nBS,Tarrive,subTarrive,timepoint,Pmax,subavgR,seglen)
options = optimset('Display','off');
exitflag = 0;
OLB = 0;
OUB = 50;
deadline = 0;
outloop = 1;
open = 0;
nMS = length(Tarrive);
% avgRateA = gen_Ese_new_guojia(Pmax,Nt,alphaL,W);
avgRateA = subavgR;
serveBS = serveBS1(:,1:T_f/T_s:initialtime/T_s);
sBSrow = reshape(serveBS.',[1 numel(serveBS)]);
sBS = kron(sBSrow,ones(nBS*sample,1));
X = 1:nBS;
XX = kron(X.',ones(1,sample*nMS));
XXX = repmat(XX,[sample 1]);
M = (sBS==XXX);
Y = eye(sample);
YY = kron(Y,ones(nBS,1));
YYY = repmat(YY,[1,nMS]);
As = M.*YYY;
P = 1:sample*nMS;
PP = reshape(P,[sample nMS]);

fmatrix = ones(usernum,sample);

LB = 0;
UB = sample;
Tupbound = UB;
loop = 1;
finish=0;
while finish~=1
    
    avgRate = avgRateA(:,1:Tupbound);
    for irow = 1:nMS
        avgRate(irow,max(floor(Tarrive(irow)/T_f)+1,1):end) = 0;
    end
    avgRateRow = reshape(avgRate.',[1 numel(avgRate)]);
    rateM = kron(avgRateRow,ones(nMS,1));
    eyesM = kron(eye(nMS),ones(1,Tupbound));
    Aeq = rateM.*eyesM;
    beq = transformation.';
    Aeq = Aeq./1e8.*T_f;
    beq = beq./1e8;
    
    total_time=10+deadline;
    n=zeros(nMS,total_time);
    [solution, exitflag]=low_complex(Aeq,beq,nMS,Tarrive,deadline,seglen,sample);
    break;
    if exitflag~=1
        if outloop==1
            deadline = 5;
            outloop = outloop + 1;
            continue;
        else
            OLB = deadline;
            if OLB>=OUB
                OUB = 2*OLB;
            end
            deadline = round((OLB+OUB)/2);
        end
    else
        finish=1;
    end
end
solution(find(solution<=0.001)) = 0;
