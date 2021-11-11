k=1;
load('.\Data\performanceGainWithLengthOfWindow.mat')
B_range = [45 30 15];
timerange=[20 30:30:180];
plot(timerange,busy(1,:),'r-o','linewidth',1); hold on;
plot(timerange,busy(2,:),'r-x','linewidth',1); hold on;
plot(timerange,busy(3,:),'r-^','linewidth',1); hold on;
plot(timerange,idle(1,:),'b--o','linewidth',1); hold on;
plot(timerange,idle(2,:),'b--x','linewidth',1); hold on;
plot(timerange,idle(3,:),'b--^','linewidth',1); hold on;

grid on;
set(gca,'XTick',[20 30:30:180],'fontsize',14,'Fontname','Times New Roman');
xlabel('Length of prediction window (s)','Fontname','Times New Roman','fontsize',14);
ylabel('Preformance gain (s)','Fontname','Times New Roman','fontsize',14);
legend('B = 45 MB, busy','B = 30 MB, busy','B = 15 MB, busy',...
    'B = 45 MB, idle','B = 30 MB, idle','B = 15 MB, idle','fontsize',14,'Fontname','Times New Roman','NumColumns',2);hold on;
axis([20 180 0 1.8]);