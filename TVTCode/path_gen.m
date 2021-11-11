function XT_s = path_gen(X0,V,Tmax,nBS,D,Ts)
XT = zeros(length(X0), Tmax);
XT_s = zeros(length(X0), Tmax/Ts);
for iMS = 1:length(X0)
    x0 = X0(iMS);
    v = V(iMS);
    aT = unifrnd(0,0,1,Tmax);
    vT = cumsum(aT,2) + v;
    XT_s(iMS, :) = mod(x0 + cumsum(kron(vT/100, ones(1,1/Ts))) + D/2, nBS*D) - D/2;
end