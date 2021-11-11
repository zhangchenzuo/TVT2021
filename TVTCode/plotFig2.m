load('.\Data\trafficload and residual bandwith.mat')
range=[1:60:60*60*24*7];

subplot(2,1,2);
plot(range,W_pre(1,1:60:60*60*24*7)/1e6,'linewidth',0.1);hold on;
xlabel('Frame (s)','fontsize',14,'Fontname','Times New Roman');
ylabel('Residual bandwidth (MHz)','fontsize',12,'Fontname','Times New Roman');
axis([0 604800 0 25]);
set(gca,'YTick',[0:10:20],'fontsize',14,'Fontname','Times New Roman');
grid on;

subplot(2,1,1);
plot(range,gen_data(1,1:60:60*60*24*7)/1e6,'linewidth',0.1);hold on;% pre
xlabel('Frame (s)','fontsize',14,'Fontname','Times New Roman');
ylabel('Traffic load (Mbytes)','fontsize',14,'Fontname','Times New Roman');
axis([0 604800 0 100]);
set(gca,'YTick',[0:40:80],'fontsize',14,'Fontname','Times New Roman');
grid on;
