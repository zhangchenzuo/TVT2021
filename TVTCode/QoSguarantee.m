function [seg_comptime,eff] = QoSguarantee(sumTrans,sum_segnum,preWindow,...
    serveBS1,meanB1,t,nBS,seg_num,segArvTime,Tseg,slotInFrames)
monitor = zeros(1,sum_segnum);
segDeadline = segArvTime + Tseg;
Trans = sumTrans;
flagUE = zeros(1,sum_segnum);
iSlot = 1;
UEcomplete = ones(1,sum_segnum)*preWindow;
sumTemp=0;
eff = 0;
for iMS = 1:sum_segnum
    if Trans(iMS)<=0
        flagUE(iMS) = 1;
    end
end
while iSlot<=preWindow/t
    for iBS = 1:nBS
        UEwait = find(serveBS1(:,iSlot)==iBS);
        UEwait = UEwait(find(flagUE(UEwait)~=1));
        b_EDF = segDeadline(UEwait) - iSlot*t;
        if isnan(UEwait)==0
            UE1_index = find(b_EDF == min(b_EDF));
            UE1 = UEwait(UE1_index);
            if length(UE1_index)==1
                Trans(UE1) = Trans(UE1) - t*meanB1(UE1,iSlot);
                if meanB1(UE1,iSlot)>0
                    sumTemp = sumTemp + 1;
                end
                if Trans(UE1)<=0 && flagUE(UE1)==0
                    Trans(UE1)=0;
                    UEcomplete(UE1) = ceil(iSlot*t);
                    flagUE(UE1) = 1;
                end
            else
                b_BIT = Trans(UE1);
                UE2_index = find(b_BIT == max(b_BIT));
                UE2 = UE1(UE2_index);
                if length(UE2_index)==1
                    Trans(UE2) = Trans(UE2) - t*meanB1(UE2,iSlot);
                    if meanB1(UE1,iSlot)>0
                        sumTemp = sumTemp + 1;
                    end
                    if Trans(UE2)<=0 && flagUE(UE2)==0
                        Trans(UE2)=0;
                        UEcomplete(UE2) = ceil(iSlot*t);
                        flagUE(UE2) = 1;
                    end
                else
                    b_APP = meanB1(UE2,iSlot);
                    [~,UE3_index] = max(b_APP);
                    UE3 = UE2(UE3_index);
                    Trans(UE3) = Trans(UE3) - t*meanB1(UE3,iSlot);
                    if meanB1(UE1,iSlot)>0
                        sumTemp = sumTemp + 1;
                    end
                    if Trans(UE3)<=0 && flagUE(UE3)==0
                        Trans(UE3)=0;
                        UEcomplete(UE3) = ceil(iSlot*t);
                        flagUE(UE3) = 1;
                    end
                end
            end
        end
    end
    if sum(flagUE==0)==0
        eff=sumTemp*t/(segArvTime(length(segArvTime))+Tseg-segArvTime(1));
        break;
    end
    iSlot = iSlot + 1;
end
seg_comptime = reshape(UEcomplete, [seg_num sum_segnum/seg_num]).';
