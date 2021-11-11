function [meanB1,serveBS1,distance,W_BS,location,avgRateL,variRateL,pathLossL,pathLossdB_his, W_BSL]...
            = channelcreatenew(usernumber,Tmax,T,t,locationini,vehicle,...
            nBSposition,pLoss1m,dFactor,Pmax,sigma2,W_pre,Nt,dis,subCar,Sa,Sw,hisWindow,sF)
nBS = length(nBSposition);
meanB1 = zeros(usernumber,Tmax/t);
meanB = zeros(usernumber,Tmax/t);
serveBS1 = zeros(usernumber,(Tmax+hisWindow)/t);
location = zeros(usernumber,(Tmax+hisWindow)/t);
distance = zeros(usernumber,(Tmax+hisWindow)/t);
location_x = path_gen(real(locationini), vehicle, 600, nBS, 500, t);
location = location_x - sqrt(-1)*dis(1:usernumber).';
location = location(:, 1:(Tmax+hisWindow)/t);

for user= 1:usernumber
    BS = kron(nBSposition, ones((Tmax+hisWindow)/t,1));
    US = kron(location(user,:), ones(nBS,1)).';
    [distance(user,:),serveBS1(user,:)]=min([abs(BS-US)'; ones(1,(Tmax+hisWindow)/t)*Inf]);
end

serveBSL = serveBS1(:,1:T/t:end);
pathLossdB_his_pre = pLoss1m + dFactor(serveBS1+7) .* log10(distance);
for user = 1:usernumber
    for j = 1:Tmax+hisWindow
        roadIndex = find(abs(imag(location(user)))==unique(dis));
        pathLossdB_his_pre(user,(j-1)*T/t+1:j*T/t) = pathLossdB_his_pre(user,(j-1)*T/t+1:j*T/t) + sF{serveBSL(user,j)}(roadIndex,...
            round(min(max(real(location(user,(j-1)*T/t+1:j*T/t))+250,1),3000)));
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
SINRh = SINR.*H;


BS_index = (serveBSL(:,hisWindow+1:end)-1)*Tmax+kron(1:Tmax, ones(usernumber,1));
W_preT = W_pre.';
W_BS = W_preT(BS_index);
W_BS = kron(W_BS,ones(1,T/t));

W_BSL1 = W_BS(:,1:T/t:end);
W_BSL2 = W_BS(:,T/t:T/t:end);
W_BSL = min(W_BSL1,W_BSL2); 

W_BSLn = normrnd(W_BSL,0);  
W_BSsub = kron(W_BSLn,ones(1,T/t));
W_BSsub(W_BSsub<=0) = 0.1;
meanB = W_BSsub .* log2(1+SINRh);
meanB1 = meanB1 + meanB;

avgRateL = zeros(usernumber,Tmax);
variRateL = zeros(usernumber,Tmax);

avgRateL = 1 * W_BSLn .* log2(1+10^(Pmax/10)*pathLossL*Nt/(10^(sigma2/10)));
location = location(:,1:T/t:end);



