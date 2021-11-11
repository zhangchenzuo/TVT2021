%% plot snr_R
load('.\Data\approx_snr_r.mat')
plot(snrDB_range, r_12_1,'-','linewidth',1.5);hold on;
plot(snrDB_range, r_6_1,'-.','linewidth',1.5);hold on;
plot(snrDB_range, r_app_12_1,'x','linewidth',1.5);hold on;
plot(snrDB_range, r_app_6_1,'o','linewidth',1.5);hold on;
xlabel('SNR (dB)','Interpreter','LaTex','Fontname','Times New Roman','fontsize',14);
ylabel('Data rate (Mbits/s)','Fontname','Times New Roman','fontsize',14);
axis([0 30 0 1200]);
legend('$$\overline{W}=12$$ MHz, $$\sigma_W=1$$ MHz','$$\overline{W}=6$$ MHz, $$\sigma_{W}=1$$ MHz',...
    'approx. $$\overline{W}=12$$ MHz, $$\sigma_{W}=1$$ MHz',...
    'approx. $$\overline{W}=6$$ MHz, $$\sigma_{W}=1$$ MHz',...
    'Interpreter','LaTex','fontsize',14,'Fontname','Times New Roman');hold on;