load('.\Data\UEMoveWithShadowing.mat')
Gain = baseline-PRA;
y = [baseline;PRA;Gain];
bar(y);
set(gca,'XTickLabel',{'non-PRA','PRA','Gain'},'fontsize',14);
ylabel('Transmission time(s)','fontsize',14);
legend('Traverse one cell','Traverse two cells','Traverse three cells',...
    'fontsize',14,'Location','SouthWest','Fontname','Times New Roman')

applyhatch(gcf,'x+...'); 