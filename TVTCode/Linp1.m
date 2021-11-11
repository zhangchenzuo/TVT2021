function [seg_comptime_all,efficiency] = Linp1(svBS_S,Tf,Ts,request_data,nBS,segNum,dataRateS,avgRateL,segArvTime,arvTime, segLen,dataRateL)
segData = request_data(1)/segNum;
seg_comptime_all = ones(length(arvTime),segNum) * Inf;
seg_index = 1:segNum;
reqDataSeg = ones(1,length(arvTime)) * segData;
resiSegs = ones(1,length(arvTime)) * segNum;
% TRANS = zeros(length(arvTime),50000);
timeslot_data = 0;
efficiency = 0;
all_time = 0;
svBS_L = svBS_S(:, 1 : Tf/Ts : end);
iframe = 1;
BS_forward = 3;


while sum(request_data)~=0
    alloMS = find(arvTime <= iframe & request_data > 0);
    maxFrame = arvTime(find(arvTime > iframe));
    if isempty(maxFrame) == 0
        trFrame = maxFrame(1) - iframe;
    else
        trFrame = Inf;
    end
    if isempty(alloMS) == 0
        temp = repmatself(resiSegs(alloMS));
        subBS = svBS_S(alloMS, (iframe-1)*Tf/Ts+1:end);
        subavgR = dataRateL(alloMS, iframe:end);
        subBSseg = subBS(temp.', :);
        subusernum = length(temp);
        subavgRseg = subavgR(temp.', :);
        request_data1 = ones(1, length(temp)) * segData;
        [~, temp1] = unique(temp);
        request_data1(temp1) = reqDataSeg(alloMS);
        seg_selected = segselect(segNum, alloMS, resiSegs);
        request_time = max(segArvTime(seg_selected) + segLen - iframe, 0);
        if request_time==0
            a=1;
        end
        
        [solution] = ...
            newplan_bisearch_sampling(200, Tf*200,1,1,Tf,Ts,1,subBSseg,subusernum,request_data1,nBS,request_time,1,1,1,subavgRseg,segLen);
        
        efficiency = sum(solution)*Tf/segLen;
        seg_comptime_all = max(find(solution>0));
        if(Tf<0.3)
            seg_comptime_all = max(find(solution>0));
        end
        return;
        trFrame = min(size(solution,1), trFrame);
        solution = solution(1:trFrame, :);
        solution = solu_manag(solution, seg_selected, segNum);
        i = 1;
        timeslot_data = timeslot_data + sum(sum(solution(1:trFrame,:)));% zcz
        resiData = zeros(1,length(arvTime));
        for iF = iframe : iframe + trFrame - 1
            all_time=all_time+1;%zcz
            for iBS = 1:nBS
                MSiniBS = alloMS(find(svBS_L(alloMS,iF)==iBS));
                if isempty(MSiniBS) == 0
                    planData = solution(i, find(svBS_L(alloMS,iF)==iBS)) .* dataRateL(MSiniBS,iF).';
                    
                    transData = zeros(1,length(planData));
                    time_solution = ceil(solution(i,find(svBS_L(alloMS,iF)==iBS))*100);
                    trans=sum(time_solution);
                    for iSlot = (iF-1)*Tf/Ts+1:iF*Tf/Ts
                        transMS0 = MSiniBS(find(time_solution>0));
                        transMS = transMS0(find(request_data(transMS0)>0));
                        trans=sum(time_solution);
                        if trans>0&&isempty(transMS) == 0
                            [~, finMS_ind] = max(dataRateS(transMS,floor(iSlot)));
                            finMS = transMS(finMS_ind);
                            data = dataRateS(finMS,floor(iSlot))*Ts;
                            transData(find(MSiniBS==finMS)) = transData(find(MSiniBS==finMS)) + data;
                            request_data(finMS) = max(request_data(finMS) - data,0);
                            if request_data(finMS)<=10e6
                                request_data(finMS) = 0;
                            end
                            time_solution(find(MSiniBS==finMS))=time_solution(find(MSiniBS==finMS))-1;
                        end
                        
                    end
                    resiSegs = ceil(request_data/segData);
                    reqDataSeg = mod(request_data-1, segData);
                    seg_comptime_all(seg_index<=segNum-resiSegs.' & seg_comptime_all==Inf) = iF;
                end
            end
            i = i + 1;
        end
    end
    iframe = iframe + trFrame;
    
end
efficiency = timeslot_data/(arvTime(length(arvTime))+segLen-arvTime(1)+1);