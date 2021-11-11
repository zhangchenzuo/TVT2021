load('.\Data\UEMoveWithoutShadowing.mat')
gain = baseline-PRA;
gain_numerical = baseline_numerical-PRA_numerical;

subplot(1,2,1);
y = [baseline;PRA;gain];
bar(y);
set(gca,'XTickLabel',{'non-PRA','PRA','Gain'},'fontsize',14,'Fontname','Times New Roman');
ylabel('Transmission time(s)','fontsize',14,'Fontname','Times New Roman');
xlabel({'(a) Simulation results'},'fontsize',14,'Fontname','Times New Roman');

subplot(1,2,2);
y1 = [baseline_numerical;PRA_numerical;gain_numerical];
bar(y1);
set(gca,'YTick',[0:1:8],'XTickLabel',{'non-PRA','PRA','Gain'},'fontsize',14,'Fontname','Times New Roman');
legend('Traverse one cell','Traverse two cells','Traverse three cells',...
    'fontsize',14,'Location','SouthWest','Fontname','Times New Roman')
xlabel({'(b) Numerical results'},'fontsize',14,'Fontname','Times New Roman');

applyhatch(gcf,'x++..');
grid on;