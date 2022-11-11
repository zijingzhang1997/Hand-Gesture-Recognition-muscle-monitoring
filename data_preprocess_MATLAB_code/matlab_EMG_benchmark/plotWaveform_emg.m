
%% ploe 4 main self channels 

function h=plotWaveform_emg(Ch_data_emg_raw,Ch_data_emg_en,Ch_data_emg_filt_raw,Ch_data_emg_filt,CaseName,gesture,fsDS)

tOff=((0:(length(Ch_data_emg_raw)-1))/fsDS)';

% [up1,lo1] = envelope(Ch_data_emg_filt_raw(:,1),);
% [up2,lo2] = envelope(Ch_data_emg_filt_raw(:,2),1,'analytic');

h(1)=figure;
a=0;
sz=9;

n=4;
subplot(n,1,1);

plot(tOff,Ch_data_emg_raw(:,1),'LineWidth',0.5,'color','red');
xlabel('time (s)','FontSize',sz)
ylabel('Amp (a.u.)','FontSize',sz)
xlim([a round(max(tOff))])
xticks(0:5:round(max(tOff)))
xticklabels(gesture)
title([CaseName,' EMG ch1 raw '],'FontSize',sz)

subplot(n,1,2);
plot(tOff,Ch_data_emg_en(:,1),'LineWidth',0.5,'color','m');

xlabel('time (s)','FontSize',sz)
ylabel('Amp (a.u.)','FontSize',sz)
xlim([a round(max(tOff))])
xticks(0:5:round(max(tOff)))
%xticklabels(gesture)
title([CaseName,'EMG ch1 envelope'],'FontSize',sz)

subplot(n,1,3);
plot(tOff,Ch_data_emg_filt_raw(:,1),'LineWidth',0.5,'color','green');
xlabel('time (s)','FontSize',sz)
ylabel('Amp (a.u.)','FontSize',sz)
xlim([a round(max(tOff))])
xticks(0:5:round(max(tOff)))
xticklabels(gesture)
title([CaseName,' EMG ch1 filter'],'FontSize',sz)


subplot(n,1,4);

plot(tOff,Ch_data_emg_filt(:,1),'LineWidth',0.5,'color','blue');
xlabel('time (s)','FontSize',sz)
ylabel('Amp (a.u.)','FontSize',sz)
xlim([a round(max(tOff))])
xticks(0:5:round(max(tOff)))
xticklabels(gesture)
title([CaseName,'EMG ch1 filter + smooth + norm'],'FontSize',sz)


set(gcf,'Position',[100,100,1500,500]);

% figName = [SavePath,CaseName,'_waveform_Ch1_2'];
% print(h(1),[figName,'.tiff'],'-dtiff','-r300');
% savefig(h(1),[figName,'.fig']);
h(2)=figure;
n=4;
subplot(n,1,1);

plot(tOff,Ch_data_emg_raw(:,2),'LineWidth',0.5,'color','red');
xlabel('time (s)','FontSize',sz)
ylabel('Amp (a.u.)','FontSize',sz)
xlim([a round(max(tOff))])
xticks(0:5:round(max(tOff)))
xticklabels(gesture)
title([CaseName,' EMG ch2 raw '],'FontSize',sz)

subplot(n,1,2);
plot(tOff,Ch_data_emg_en(:,2),'LineWidth',0.5,'color','m');

xlabel('time (s)','FontSize',sz)
ylabel('Amp (a.u.)','FontSize',sz)
xlim([a round(max(tOff))])
xticks(0:5:round(max(tOff)))
%xticklabels(gesture)
title([CaseName,'EMG ch2 envelope'],'FontSize',sz)

subplot(n,1,3);
plot(tOff,Ch_data_emg_filt_raw(:,2),'LineWidth',0.5,'color','green');
xlabel('time (s)','FontSize',sz)
ylabel('Amp (a.u.)','FontSize',sz)
xlim([a round(max(tOff))])
xticks(0:5:round(max(tOff)))
xticklabels(gesture)
title([CaseName,' EMG ch2 filter'],'FontSize',sz)


subplot(n,1,4);

plot(tOff,Ch_data_emg_filt(:,2),'LineWidth',0.5,'color','blue');
xlabel('time (s)','FontSize',sz)
ylabel('Amp (a.u.)','FontSize',sz)
xlim([a round(max(tOff))])
xticks(0:5:round(max(tOff)))
xticklabels(gesture)
title([CaseName,'EMG ch2 filter + smooth + norm'],'FontSize',sz)

set(gcf,'Position',[100,100,1500,500]);






end 