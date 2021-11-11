load('.\Data\3UEMove.mat')

y11 = dynamic(1,1:3);
y22 = dynamic(2,1:3);
y33 = dynamic(3,1:3);
y_1 = constant(1,1:3);
y_2 = constant(2,1:3);
y_3 = constant(3,1:3);

subplot(1,2,1);
y1 = [y11;y22;y33]; 
bar(y1);
set(gca,'XTickLabel',{'30%','50%','70%'},'fontsize',14,'Fontname','Times New Roman');
ylabel('Performance gain\Deltat (s)','fontsize',14,'Fontname','Times New Roman');
xlabel({'(a) Dynamic residual bandwidth'},'fontsize',14,'Fontname','Times New Roman');

subplot(1,2,2);
y = [y_1;y_2;y_3];
bar(y);
set(gca,'XTickLabel',{'30%','50%','70%'},'fontsize',14,'Fontname','Times New Roman');
legend('Traverse one cell','Traverse two cells','Traverse three cells','fontsize',14,'Location','SouthWest','Fontname','Times New Roman');
xlabel({'(b) Constant residual bandwidth'},'fontsize',14,'Fontname','Times New Roman');
applyhatch(gcf,'x++..');  