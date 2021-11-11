%% plot R
load('.\Data\approx_R.mat')
plot([8:4:160], gain_8_45,'-','linewidth',1.5);hold on;
plot([8:4:160], gain_16_45,'--','linewidth',1.5);hold on;
plot([24:4:160], gain_16_135,'-.','linewidth',1.5);hold on;
plot([8:4:160], gain_app_8_45,'x','linewidth',1.5);hold on;
plot([8:4:160], gain_app_16_45,'^','linewidth',1.5);hold on;
plot([24:4:160], gain_app_16_135,'o','linewidth',1.5);hold on;
axis([0 160 0 40]);
xlabel('$$ \overline{R}$$ (Mbits/s)','Interpreter','LaTex','Fontname','Times New Roman','fontsize',14);
ylabel('Preformance gain (s)','Fontname','Times New Roman','fontsize',14);
legend('B=45 MB, $$\sigma_R=8$$ Mbits/s','B=45 MB, $$\sigma_R=16$$ Mbits/s','B=135 MB, $$\sigma_R=16$$ Mbits/s',...
    'approx. B=45 MB, $$\sigma_R=8$$ Mbits/s',...
    'approx. B=45 MB, $$\sigma_R=16$$ Mbits/s',...
    'approx. B=135 MB, $$\sigma_R=16$$ Mbits/s',...
    'Interpreter','LaTex','fontsize',14,'Fontname','Times New Roman');hold on;






