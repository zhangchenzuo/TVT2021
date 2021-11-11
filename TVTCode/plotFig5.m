%% plot B
load('.\Data\approx_B.mat');
figure();
plot([10:10:300], gain_64_32,'-','linewidth',1.5);hold on;
plot([10:10:300], gain_120_32,'--','linewidth',1.5);hold on;
plot([10:10:300], gain_120_16,'-.','linewidth',1.5);hold on;
plot([10:10:300], gain_app_64_32,'x','linewidth',1.5);hold on;
plot([10:10:300], gain_app_120_32,'^','linewidth',1.5);hold on;
plot([10:10:300], gain_app_120_16,'o','linewidth',1.5);hold on;

xlabel('$$ B$$ (MB)','Interpreter','LaTex','Fontname','Times New Roman','fontsize',14);
ylabel('Preformance gain (s)','Fontname','Times New Roman','fontsize',14);
axis([0 300 0 22]);
legend('$$\overline{R}=64$$ Mbits/s, $$\sigma_R=32$$ Mbits/s','$$\overline{R}=120$$ Mbits/s, $$\sigma_{R}=32$$ Mbits/s','$$\overline{R}=120$$ Mbits/s, $$\sigma_{R}=16$$ Mbits/s',...
    'approx. $$\overline{R}=64$$ Mbits/s, $$\sigma_{R}=32$$ Mbits/s',...
    'approx. $$\overline{R}=120$$ Mbits/s, $$\sigma_{R}=32$$ Mbits/s',...
    'approx. $$\overline{R}=120$$ Mbits/s, $$\sigma_{R}=16$$ Mbits/s',...
    'Interpreter','LaTex','fontsize',14,'Fontname','Times New Roman');hold on;