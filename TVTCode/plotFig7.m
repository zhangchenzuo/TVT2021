load('.\Data\performanceGainWithZeta.mat')

plot(ZETA,numerical(:,1),'r--','linewidth',1.5,'Markersize',6);hold on;% appro_pre
plot(ZETA,numerical(:,2),'b-.','linewidth',1.5,'Markersize',6);hold on; % base
plot(ZETA,numerical(:,3),'g-','linewidth',1.5,'Markersize',6);hold on; % appro_gain

plot(ZETA,simulation(:,1),'x','linewidth',1.5,'Markersize',11);hold on;% pre
plot(ZETA,simulation(:,2),'*','linewidth',1.5,'Markersize',11);hold on;% base
plot(ZETA,simulation(:,3),'o','linewidth',1.5,'Markersize',8);hold on;% gain
%legend('theory pre appro','simulation pre','simulation gain','theory gain appro','fontsize',12,'NumColumns',2)
legend('$$B$$=45 MB (numerical)', '$$B$$=30 MB (numerical)','$$B$=15 MB (numerical)',...
    '$$B$$=45 MB (simulation)','$$B$$=30 MB (simulation)','$$B$$=15 MB (simulation)',...
    'Interpreter','LaTex','fontsize',14,'Fontname','Times New Roman');
xlabel('\zeta -coefficient','fontsize',14,'Fontname','Times New Roman');ylabel('Performance gain \Deltat (s)','fontsize',14,'Fontname','Times New Roman');
axis([2*1e7 25*1e7 0 5]);
set(gca,'XTick',[2 4 6 8 10 15 20 25]*1e7,'YTick',[0:1:5],'fontsize',14,'Fontname','Times New Roman');
grid on;