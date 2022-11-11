
%% ploe 4 main self channels 

function h=select_ch_plotWaveform(Ch_data,CaseName,gesture,fsDS,ch)

tOff=((0:(length(Ch_data)-1))/fsDS)';



h(1)=figure;
a=0;
sz=9;

n=4;
subplot(n,1,1);

plot(tOff,Ch_data(:,ch(1)),'LineWidth',0.5,'color','red');
xlabel('time (s)','FontSize',sz)
ylabel('Amp (a.u.)','FontSize',sz)
xlim([a round(max(tOff))])
xticks(0:5:round(max(tOff)))
xticklabels(gesture)
title([CaseName,' Ch1 amp '],'FontSize',sz)

subplot(n,1,2);
plot(tOff,Ch_data(:,ch(2)),'LineWidth',0.5,'color','red');
xlabel('time (s)','FontSize',sz)
ylabel('Amp (a.u.)','FontSize',sz)
xlim([a round(max(tOff))])
xticks(0:5:round(max(tOff)))
xticklabels(gesture)
title([CaseName,' Ch1 ph '],'FontSize',sz)


subplot(n,1,3);
plot(tOff,Ch_data(:,ch(3)),'LineWidth',0.5,'color','green');
xlabel('time (s)','FontSize',sz)
ylabel('Amp (a.u.)','FontSize',sz)
xlim([a round(max(tOff))])
xticks(0:5:round(max(tOff)))
xticklabels(gesture)
title([CaseName,'Ch2 amp '],'FontSize',sz)
subplot(n,1,4);
plot(tOff,Ch_data(:,ch(4)),'LineWidth',0.5,'color','green');
xlabel('time (s)','FontSize',sz)
ylabel('Amp (a.u.)','FontSize',sz)
xlim([a round(max(tOff))])
xticks(0:5:round(max(tOff)))
%xticklabels(gesture)
title([CaseName,' Ch2 ph '],'FontSize',sz)

set(gcf,'Position',[100,100,1500,500]);

% figName = [SavePath,CaseName,'_waveform_Ch1_2'];
% print(h(1),[figName,'.tiff'],'-dtiff','-r300');
% savefig(h(1),[figName,'.fig']);

h(2)=figure;
subplot(n,1,1);
plot(tOff,Ch_data(:,ch(5)),'LineWidth',0.5,'color','b');
xlabel('time (s)','FontSize',sz)
ylabel('Amp (a.u.)','FontSize',sz)
xlim([a round(max(tOff))])
xticks(0:5:round(max(tOff)))
xticklabels(gesture)
title([CaseName,' Ch3 amp '],'FontSize',sz)
subplot(n,1,2);
plot(tOff,Ch_data(:,ch(6)),'LineWidth',0.5,'color','b');
xlabel('time (s)','FontSize',sz)
ylabel('Amp (a.u.)','FontSize',sz)
xlim([a round(max(tOff))])
xticks(0:5:round(max(tOff)))
%xticklabels(gesture)
title([CaseName,' Ch3 ph '],'FontSize',sz)

subplot(n,1,3);
plot(tOff,Ch_data(:,ch(7)),'LineWidth',0.5,'color','m');
xlabel('time (s)','FontSize',sz)
ylabel('Amp (a.u.)','FontSize',sz)
xlim([a round(max(tOff))])
xticks(0:5:round(max(tOff)))
xticklabels(gesture)
title([CaseName,' Ch4 amp '],'FontSize',sz)
subplot(n,1,4);
plot(tOff,Ch_data(:,ch(8)),'LineWidth',0.5,'color','m');
xlabel('time (s)','FontSize',sz)
ylabel('Amp (a.u.)','FontSize',sz)
xlim([a round(max(tOff))])
xticks(0:5:round(max(tOff)))
title([CaseName,' Ch4 ph '],'FontSize',sz)
%xticklabels(gesture)
xlim([a round(max(tOff))])
set(gcf,'Position',[100,100,1500,500]);





end 