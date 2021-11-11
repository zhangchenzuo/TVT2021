load('.\Data\approx_sigma.mat');
figure();
plot([0:1.6:40], gain_64_45,'-','linewidth',1.5);hold on;
plot([0:1.6:40], gain_120_45,'--','linewidth',1.5);hold on;
plot([0:1.6:40], gain_120_135,'-.','linewidth',1.5);hold on;
plot([0:1.6:40], gain_app_64_45,'x','linewidth',1.5);hold on;
plot([0:1.6:40], gain_app_120_45,'^','linewidth',1.5);hold on;
plot([0:1.6:40], gain_app_120_135,'o','linewidth',1.5);hold on;

xlabel('$$ \sigma_R$$ (Mbits/s)','Interpreter','LaTex','Fontname','Times New Roman','fontsize',14);
ylabel('Preformance gain (s)','Fontname','Times New Roman','fontsize',14);
axis([0 40 0 4.5]);
legend('B=45 MB, $$\overline{R}=64$$ Mbits/s','B=45 MB, $$\overline{R}=120$$ Mbits/s','B=135 MB, $$\overline{R}=120$$ Mbits/s',...
    'approx. B=45 MB, $$\overline{R}=64$$ Mbits/s',...
    'approx. B=45 MB, $$\overline{R}=120$$ Mbits/s',...
    'approx. B=135 MB, $$\overline{R}=120$$ Mbits/s',...
    'Interpreter','LaTex','fontsize',14,'Fontname','Times New Roman');hold on;
