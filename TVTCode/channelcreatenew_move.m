function [meanB1,serveBS1,distance,W_BS,location,avgRateL,variRateL,pathLossL,pathLossdB_his, W_BSL]...
            = channelcreatenew_move(usernumber,Tmax,T,t,locationini,vehicle,...
            nBSposition,pLoss1m,dFactor,Pmax,sigma2,W_pre,Nt,dis,hisWindow,sF,D,relativeDis)
nBS = length(nBSposition);
R_bs = D/2;
meanB1 = zeros(usernumber,Tmax/t);
meanB = zeros(usernumber,Tmax/t);
serveBS1 = zeros(usernumber,(Tmax+hisWindow)/t);
location = zeros(usernumber,(Tmax+hisWindow)/t);
distance = zeros(usernumber,(Tmax+hisWindow)/t);
location_x = path_gen(real(locationini), vehicle, 600, nBS, D, t);
location = location_x - sqrt(-1)*dis(1:usernumber).';
location = location(:, 1:(Tmax+hisWindow)/t);

for user= 1:usernumber
    BS = kron(nBSposition, ones((Tmax+hisWindow)/t,1));
    US = kron(location(user,:), ones(nBS,1)).';
    [distance(user,:),serveBS1(user,:)]=min([abs(BS-US)'; ones(1,(Tmax+hisWindow)/t)*Inf]);
end
sampleDis = abs(floor(relativeDis/abs(vehicle(1))/t));
serveBSL = serveBS1(:,1:T/t:end);
%serveBSL = serveBS1(:,1:sampleDis:end);
distance(distance>R_bs) = R_bs;
pathLossdB_his_pre = pLoss1m + dFactor(serveBS1+7) .* log10(distance);
sampleD = int64(T/t);
samplenum = 400;
for user = 1:usernumber
    for j = 1:samplenum
        roadIndex = find(abs(imag(location(user)))==unique(dis));
        pathLossdB_his_pre(user,(j-1)*sampleD+1:j*sampleD) = pathLossdB_his_pre(user,(j-1)*sampleD+1:j*sampleD)...
            + sF{serveBSL(user,j)}(roadIndex,rem(round(min(max(real(location(user,(j-1)*sampleD+1:j*sampleD))+R_bs,1),D*6)),3000)+1);
    end
end

pathLossdB_his = pathLossdB_his_pre(:,1:T/t:hisWindow/t);

pathLossdB = pathLossdB_his_pre(:,hisWindow/t+1:end);
pathLoss = 10.^(-pathLossdB/10);
pathLossL = pathLoss(:,1:T/t:end);
SINRdB = Pmax - pathLossdB - sigma2;
SINR = 10.^(SINRdB/10);
H = zeros(usernumber,Tmax/t);
for j = 1:Nt
    H = H + abs(((randn(usernumber,Tmax/t)+sqrt(-1)*randn(usernumber,Tmax/t))/sqrt(2)).^2);
end
SINRh = SINR.*8;

BS_index = (serveBSL(:,hisWindow+1:end)-1)*Tmax+kron(floor(1:T:samplenum*T+0.9), ones(usernumber,1));
W_preT = W_pre.';
W_BS = W_preT(BS_index);
W_BS = kron(W_BS,ones(1,T/t));

W_BSL1 = W_BS(:,1:T/t:end);
W_BSL2 = W_BS(:,T/t:T/t:end);
W_BSL = min(W_BSL1,W_BSL2); 

W_BSLn = normrnd(W_BSL,0);  
W_BSsub = kron(W_BSLn,ones(1,T/t));
W_BSsub(W_BSsub<=0) = 0.1;
meanB = W_BSsub(1:length(SINRh)) .* log2(1+SINRh);
meanB1 = meanB1 + meanB;

avgRateL = zeros(usernumber,Tmax);
variRateL = zeros(usernumber,Tmax);
a = 10^(Pmax/10)*pathLossL*Nt/(10^(sigma2/10));
b = pathLossL;
avgRateL = 1 * W_BSLn .* log2(1+10^(Pmax/10)*pathLossL*Nt/(10^(sigma2/10)));
location = location(:,1:T/t:end);



