load('.\Data\UEMoveWithDiffBS.mat')
UMi = diversity_gain_0(:,1)';
UMA = diversity_gain(:,1)';

y = [UMi;UMA];
bar(y);

set(gca,'XTickLabel',{'UMi-Street','UMa'},'fontsize',14,'Fontname','Times New Roman');
ylabel('Performance gain \Deltat (s)','fontsize',14,'Fontname','Times New Roman');
legend('Residual Bandwidth = 30%','Residual Bandwidth = 50%',...
    'Residual Bandwidth = 70%','fontsize',14,'Location','NorthWest','Fontname','Times New Roman');
applyhatch(gcf,'x+..');                           