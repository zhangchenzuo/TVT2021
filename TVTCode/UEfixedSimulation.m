%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% In the scenario where the user location is fixed, different network
% bandwidth statistics are compared for the effect of performance gain
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear;
sumloop  = 1;

%% Generate user trace
lambda = 0.1;
[MSNUM, USERP, VEHICLE, ARVTIME] = data_gen_position(lambda, sumloop, 10, 0);

%% Simulation parameters
Sa = 0;
Sw = 0;
T_f = 1;                                                                    % length of one frame
T_s = 10e-3;                                                                % length of one time slot
Wmax = [20e6 20e6 20e6 20e6 20e6 20e6];                                     % available bandwidth of each
Pmax = 16.0206;                                                             % maximal tranmit power
dFactor = unifrnd(36.6,36.8,1,20);
pLoss1m = 36.8;
Nt = 8;                                                                     % number of antennas in each BS
beta = 1;
lambda_u = 2.5*10^(-4);                                                     %average packets size 4 kbits/packet
sigma = 2.0455e-6;
sigma2 = 10*log10(sigma^2);                                                

%% Road topology parameters
D = 500;                                                                    % diameter of each cell
Rzone = D/2;
bs_Posi = [0 500 1000 1500 2000 2500];                                      % position of each BS
nBS = length(bs_Posi);                                                      % number of BSs (cells)
figureplot = 0;                                                             % whether plot the cell
dis = [50 50 50 50 50 50 50 50 50];
dis = repmat(dis,1,50);
peakTime = 60;                                                             % length of peak-time (/frame)
offPeakTime = 0;                                                            % length of off-peak time (/frame)
%% transmission parameters
Index=1;
for nNRT=[3:-1:1]
    Tp =60;
    segNum =1;
    segLen = Tp;
    dis = [50 50 50 50 50 50 50 50 50];
    dis = repmat(dis,1,50);
    reqData = 1.5*30e6*8*segNum*nNRT; % Requested file size
    segReqData = reqData./segNum; 
    hisWindow = 0;
    preWindow = Tp;                                                        
    timeRange = 400;
    subCar = 1;
    
    bs_Posi0 = [250*sqrt(3)*sqrt(-1)+[0:6]*D-D/2,...
        bs_Posi,-250*sqrt(3)*sqrt(-1)+(0:6)*D-D/2];
    for iBS = 1:length(bs_Posi0)
        BS_sF{iBS} = load(['Data\Shadow\BS_', num2str(iBS), '.csv']);
    end
    
    %% Diff bandwidth
    ZETA=[38 44 57 75 83 94 108 120];
    w_bar = [1.6 1.53 1.4 1.2 1.11 1 0.85 0.62]*1e7;
    w_sig = [1.08 1.16 1.32 1.52 1.6 1.7 1.82 1.9]*1e6;
    loopindex = 1;
    for index = length(w_sig):-1:1;
        for loopK = 1:length(lambda)*sumloop
            loopLambda = floor((loopK-1)/sumloop)+1;
            nMS = MSNUM(loopK);
            usrpositionx = USERP{loopK};
            vehicles = VEHICLE{loopK};
            arvTime = 1;
            
            segArvTime = Gen_Seg_Arv(arvTime,segNum,segLen,nMS);
            nSEG = nMS * segNum;
            MSnum = nMS;
            nMSsegData = ones(1,nMS*segNum)*segReqData;
            nMSdata = ones(1,nMS)*reqData;
            
            W_his_pre = normrnd(w_bar(index),w_sig(index),nBS,timeRange);
            W_his = W_his_pre(:, 1:hisWindow);
            W_pre = W_his_pre(:, hisWindow+1:end);
            for user_num=1:segNum
                W(user_num)=mean(mean(W_pre(:,segArvTime(user_num):preWindow+segArvTime(user_num)-1),2));
                W_sig(user_num)=mean(std(W_pre(:,segArvTime(user_num):preWindow+segArvTime(user_num)-1),0,2));
            end
            [dataRateS,servBS_S,~,~,location,avgRateL,~,pathLossL,~, W_BSL] = ...
                channelcreatenew(nMS,timeRange,T_f,T_s,usrpositionx,vehicles,bs_Posi,pLoss1m,...
                dFactor,Pmax,sigma2,W_pre,Nt,dis,subCar,Sa,Sw,hisWindow,BS_sF);
            
            servBS_S = servBS_S(:, hisWindow/T_s+1:end);
            serveBS_L = servBS_S(:,1:T_f/T_s:end);
            dataRateL=zeros(nMS,200);
            for k=1:length(dataRateS)*T_s
                dataRateL(:,k) = mean(dataRateS(:,(k-1)/T_s+1:1:k/T_s),2);
            end
           %% calculate numerical result
            n=preWindow;
            for user_num=1:segNum
                x(user_num)=mean(dataRateL(:,segArvTime(user_num):preWindow+segArvTime(user_num)-1),2);
                sig(user_num)=std(dataRateL(:,segArvTime(user_num):preWindow+segArvTime(user_num)-1),0,2);
            end
            B=segReqData;
            CV=x/sig;
            beta=(1+n)*CV+3^0.5*n;
           
            % PRA transmission time
            transtime_pre_theory(:,loopK)=((n+1).*x+3^0.5*n.*sig-...
                (((n+1).*x+3^0.5*n.*sig).^2-4*3^0.5*B*(n+1).*sig).^0.5)./(2*3^0.5.*sig);
            transtime_pre_theory_appro(:,loopK)=B*(n+1)/(sig*beta);
            % Baseline transmission time
            transtime_base_theory(:,loopK)=B/x;
            
            % upper bound
            limit(:,loopK)=3^0.5*B/(x*x/sig+3^0.5*x);
            limit_appro(:,loopK)=3^0.5*B/(x*x/sig);
            limit_pre(:,loopK)=B/(x+3^0.5*sig);
            
            % Gain
            gain_theory(:,loopK)=transtime_base_theory(:,loopK)-transtime_pre_theory_appro(:,loopK);
            gain_appro(:,loopK)=3^0.5*n*B/((n+1)*CV*x+3^0.5*n*x);

            preArvTime = max(arvTime,1);
            for i = 1:length(arvTime)
                dataRateS(i,1:(preArvTime(i)-1)*T_f/T_s) = 0;
                pathLossL(i,1:preArvTime(i)-1) = 0;
            end
           %% Baseline 
            
            dataRateSegS4A1 = kron(dataRateS,ones(segNum,1));
            servBSSeg_S = kron(servBS_S,ones(1,segNum).');
            [seg_comptime_a_1,liyonglu_b] = QoSguarantee(nMSsegData,nSEG,timeRange,servBSSeg_S,...
                dataRateSegS4A1,T_s,nBS,segNum,segArvTime,segLen);
            eff_b(loopK)=liyonglu_b;
            
           %% PRA
            timepoints =  max(arvTime,1);
            user_index = 1:segNum;
            request_time = segArvTime(1:segNum) - timepoints(1) + 1;
            completetime = zeros(1,length(segArvTime));
            request_data = ones(1,length(arvTime))*reqData;
            
            [seg_comptime_a3,efficiency] = Linp1(servBS_S,T_f,T_s,request_data,...
                nBS,segNum,dataRateS,avgRateL,segArvTime,arvTime,segLen,dataRateL);
            eff(loopK)=efficiency;
        end
        
        simu(loopindex,:)=[mean(eff)*segLen,mean(eff_b)*segLen, mean(eff_b)*segLen-mean(eff)*segLen ];
        theory(loopindex,:)=[mean(transtime_pre_theory) mean(transtime_base_theory) mean(gain_theory)];
        Limit(loopindex,:)=[mean(limit,2) mean(limit_appro,2)];
        loopindex=loopindex+1;
    end 
    diversity_gain(:,Index)=simu(:,3);
    diversity_gain_theory(:,Index)=theory(:,3);
    diversity_gain_limit(:,Index)=Limit(:,1);
    diversity_gain_limit_appro(:,Index)=Limit(:,2);
    Index=Index+1;
end
