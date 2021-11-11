%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The influence of the number of traversal cells and network bandwidth
% on the performance gain is analyzed in the user mobile scenario
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
BsMode = 2;                            % Set the mode of base station   0: traditional base station 1:5g Umi - Street 2:5g Umo
shadowing = 1;                         % 1 with shadowing, 0 without shadowing
factor = 1;
sumloop  = 1;
lambda = 0.1;
loopIndex=1;
loopS=1;
%% The base station parameters
T_s = 10e-3;                                                                % length of one time slot
Wmax = [20e6 20e6 20e6 20e6 20e6 20e6];                                     % available bandwidth of each
if BsMode == 0 % Umi
    Pmax = 16.0206; % 40W                                                     % maximal tranmit power
    D = 500;                                                                    % diameter of each cell
end
if BsMode == 1
    Pmax = 13.9794; % 25W   
    D = 400;
end
if BsMode == 2   % Uma
    Pmax = 19.0309; % 80W   
    D = 1000;
end

[MSNUM, USERP, VEHICLE, ARVTIME] = data_gen_simple(lambda, sumloop, 10, 0, D/2);
dFactor = unifrnd(36.6,36.8,1,20);
pLoss1m = 36.8;
relativeDis = 10;                                                           % distance of large scale channel
Nt = 8;                                                                     % number of antennas in each BS
beta = 1;
lambda_u = 2.5*10^(-4);                                                     %average packets size 4 kbits/packet
sigma = 2.0455e-6;
sigma2 = 10*log10(sigma^2); %average packets size 4 kbits/packet

%% Road topology parameters
Rzone = D/2;
bs_Posi = (0:1:5)*D;   % position of each BS
nBS = length(bs_Posi);                                                      % number of BSs (cells)
figureplot = 0;                                                             % whether plot the cell
dis = [50 50 50 50 50 50 50 50 50];
dis = repmat(dis,1,50);
peakTime = 60;                                                             % length of peak-time (/frame)
offPeakTime = 0;                                                            % length of off-peak time (/frame)
%% Transmission parameters
Tp = 60;
vehicle_s = [(1:1:3)*D./Tp];
segNum =1;
segLen = Tp;
reqData = 1.5*30e6*8*segNum;  % 120MB
segReqData = reqData./segNum;
hisWindow = 0;
preWindow = Tp;
subCar = 1;

bs_Posi0 = [Rzone*sqrt(3)*sqrt(-1)+[0:6]*D-Rzone,...
    bs_Posi,...
    -Rzone*sqrt(3)*sqrt(-1)+(0:6)*D-Rzone];
if shadowing == 1
    for iBS = 1:length(bs_Posi0)
        BS_sF{iBS} = load(['Data\Shadow\BS_', num2str(iBS), '.csv']);
    end
else
    for iBS = 1:length(bs_Posi0)
        BS_sF{iBS} = ones(3,3000)*0;
    end
end
%%
for chs=1:1:length(vehicle_s)
    vehicle = vehicle_s(chs);
    absvehicle = abs(vehicle);
    vehicles = (randi(2,1,lambda*10)-1.5)*2.*vehicle;
    loopS=1;
    
    
    %% Main
    
    busys = [0.3 0.5 0.7];
    for iter = 1:1:length(busys)
        %loopS=1;
        sigs = [0.12 0.16 0.225];
        busy = busys(iter);
        sig_r = sigs(iter);
        dis_example = 50;
        dis = ones(1,9)*dis_example;
        dis = repmat(dis,1,50);
        T_f = floor(relativeDis/vehicle/T_s)/100;                                                              % length of one frame
        timeRange = T_f*400;
        for loopK = 1:length(lambda)*sumloop
            loopK1 = loopK;
            loopLambda = floor((loopK1-1)/sumloop)+1;
            nMS = MSNUM(loopK1);
            usrpositionx = USERP{loopK1};
            arvTime = ARVTIME{loopK1};
            segArvTime = Gen_Seg_Arv(arvTime,segNum,segLen,nMS);
            nSEG = nMS * segNum;
            MSnum = nMS;
            nMSsegData = ones(1,nMS*segNum)*segReqData;
            
            W_his_pre = normrnd(20e6*busy,20e6*busy*sig_r,nBS,timeRange);
            W_his = W_his_pre(:, 1:hisWindow);
            W_pre = W_his_pre(:, hisWindow+1:end);
            for user_num=1:segNum
                W(user_num)=mean(mean(W_pre(:,segArvTime(user_num):preWindow+segArvTime(user_num)-1),2));
                W_sig(user_num)=mean(std(W_pre(:,segArvTime(user_num):preWindow+segArvTime(user_num)-1),0,2));
            end
            
            [dataRateS,servBS_S,~,~,~,avgRateL,~,pathLossL,~, ~] = ...
                channelcreatenew_move(nMS,timeRange,T_f,T_s,usrpositionx,vehicles,bs_Posi,pLoss1m,...
                dFactor,Pmax,sigma2,W_pre,Nt,dis,hisWindow,BS_sF,D,relativeDis);
            servBS_S = servBS_S(:, hisWindow/T_s+1:end);
            serveBS_L = servBS_S(:,1:T_f/T_s:end);
            samplinNum = floor(vehicle*Tp/relativeDis);
            dataRateL=zeros(nMS,samplinNum);
            sampleDis = floor(relativeDis/absvehicle/T_s);
            for k=1:floor(timeRange/T_f)
                dataRateL(:,k) = mean(dataRateS(:,(k-1)*sampleDis+1:sampleDis:k*sampleDis),2);
            end
            
           %% calculate numerical result
            n=preWindow;
            nc=D/relativeDis;
            for user_num=1:segNum
                x(user_num,:)=mean(dataRateL,2);
                sig(user_num,:)=std(dataRateL,0,2);
            end
            B=segReqData;
            CV=x./sig;
            R_MAX = max(dataRateL,[],2);
            R_MIN = min(dataRateL,[],2);
            % PRA transmission time
            transtime_pre_theory(:,loopK)=((n+1).*x+3^0.5*n.*sig-...
                (((n+1).*x+3^0.5*n.*sig).^2-4*3^0.5*B*(n+1).*sig).^0.5)./(2*3^0.5.*sig);
            transtime_pre_theory_appro(:,loopK)=2*B*(nc+1)./(R_MAX*(2*nc+1)+R_MIN);
            
            % upper bound
            transtime_pre_theory_appro_dlimit(:,loopK)=B./(R_MAX);
            % baseline
            transtime_base_theory(:,loopK)=B/mean(dataRateL(:,segArvTime:preWindow+segArvTime),2);
            % gain
            gain_theory(:,loopK)=transtime_base_theory(:,loopK)-transtime_pre_theory(:,loopK);
            
           %% Baseline
            dataRateSegS4A1 = kron(dataRateS,ones(segNum,1));
            servBSSeg_S = kron(servBS_S,ones(1,segNum).');
            [seg_comptime_a_1,liyonglu_b] = QoSguarantee(nMSsegData,nSEG,timeRange,servBSSeg_S,...
                dataRateSegS4A1,T_s,nBS,segNum,segArvTime,segLen,T_f/T_s);
            eff_b(loopK)=liyonglu_b;
           
           %% PRA
            user_index = 1:segNum;
            request_data = nMSsegData(1:segNum);
            completetime = zeros(1,length(segArvTime));
            request_data = ones(1,length(arvTime))*reqData;
            
            [seg_comptime_a3,efficiency] = Linp1(servBS_S,T_f,T_s,request_data,...
                nBS,segNum,dataRateS,avgRateL,segArvTime,arvTime,segLen,dataRateL);
            eff(loopK)=efficiency;
        end
        
        simu(loopS,:)=[mean(eff)*segLen,mean(eff_b)*segLen, mean(eff_b)*segLen-mean(eff)*segLen ]; %仿真 预测方法 非预测方法 增益
        theory(loopS,:)=[mean(eff_b)*segLen-mean(transtime_pre_theory,'all')...
            mean(eff_b)*segLen-mean(transtime_pre_theory_appro,'all')];
        loopS=loopS+1;
    end 

    diversity_gain(:,loopIndex)= simu(:,3);
    diversity_gain_theory(:,loopIndex)=theory(:,1);
    diversity_gain_appro(:,loopIndex)=theory(:,2); 
    loopIndex=loopIndex+1;
end
