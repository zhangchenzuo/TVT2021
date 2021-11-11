%% plot snr
load('.\Data\approx_snr_gain.mat');
plot(snrDB_range, gain_12_1,'-','linewidth',1.5);hold on;
plot(snrDB_range, gain_12_2,'--','linewidth',1.5);hold on;
plot(snrDB_range, gain_6_1,'-.','linewidth',1.5);hold on;
plot(snrDB_range, gain_app_12_1,'x','linewidth',1.5);hold on;
plot(snrDB_range, gain_app_12_2,'^','linewidth',1.5);hold on;
plot(snrDB_range, gain_app_6_1,'o','linewidth',1.5);hold on;
xlabel('SNR (dB)','Interpreter','LaTex','Fontname','Times New Roman','fontsize',14);
ylabel('Upper bounf of preformance gain (s)','Fontname','Times New Roman','fontsize',14);
legend('$$\overline{W}=12$$ MHz, $$\sigma_W=1$$ MHz','$$\overline{W}=12$$ MHz, $$\sigma_{W}=2$$ MHz','$$\overline{W}=6$$ MHz, $$\sigma_{W}=1$$ MHz',...
    'approx. $$\overline{W}=12$$ MHz, $$\sigma_{W}=1$$ MHz',...
    'approx. $$\overline{W}=12$$ MHz, $$\sigma_{W}=2$$ MHz',...
    'approx. $$\overline{W}=6$$ MHz, $$\sigma_{W}=1$$ MHz',...
    'Interpreter','LaTex','fontsize',14,'Fontname','Times New Roman');hold on;