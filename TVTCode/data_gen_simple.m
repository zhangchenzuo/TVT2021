function [MSNUM, USERP, VEHICLE, ARVTIME] = data_gen_simple(lambda, sumloop, peakTime, chronous, R)
% Base Parameters                              % arrival rate                            % length of peak-time (/frame)
offPeakTime = 0;                            % length of off-peak time (/frame)
%dis = [50 50 100 100 100 150 150 150 150];
 dis = zeros(1,9)+50;
dis = repmat(dis,1,150);
MSNUM = zeros(1,length(lambda)*sumloop);
USERP = cell(1,length(lambda)*sumloop);
VEHICLE = cell(1,length(lambda)*sumloop);
displaystep = 100;

for loopK = 1:length(lambda)*sumloop
    loopLambda = floor((loopK-1)/sumloop)+1;
    flag = 0;
    while flag==0
        if chronous == 0
            arvHist = poissrnd(lambda(loopLambda),1,peakTime);
        else
            arvHist = [round(lambda(loopLambda)*peakTime), zeros(1, peakTime-1)];
        end
        nMS = sum(arvHist);
        if sum(arvHist) == round(lambda(loopLambda)*peakTime)
            u1 = find(arvHist~=0);
            u2 = arvHist(u1(1));
            if u2>=1
                flag = 1;
            end
        end
    end
    arrivetime = find(arvHist~=0);
    arrivehist = arvHist(arrivetime);
    arvTime = [];
    for time = 1:length(arrivetime)
        arvTime = [arvTime repmat(arrivetime(time),1,arrivehist(time))];
    end
    usrpositionx = -sqrt(-1)*dis(1:nMS) + unifrnd(-R*0.8,R*0.8,1,nMS)+2*R*(unidrnd(6)-1);
    vehicles = 5;
    arvTime = ones(1,lambda*peakTime); % 固定请求时间
    MSNUM(loopK) = nMS;
    USERP{loopK} = usrpositionx;
    VEHICLE{loopK} = vehicles;
    ARVTIME{loopK} = arvTime;
    if mod(loopK, displaystep) == 0
        display(['Generating data...  The ' num2str(loopK) 'th loop, Total loop: ' num2str(length(lambda)*sumloop)])
    end
end