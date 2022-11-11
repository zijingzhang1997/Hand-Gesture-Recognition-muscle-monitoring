function h=plotWaveform_selected(Ch_data,ChName,fsDS)

tOff=((0:(length(Ch_data)-1))/fsDS)';



h(1)=figure;
a=0;
sz=10;

n=size(Ch_data,2);
for i =1:n
subplot(n,1,i);

plot(tOff,Ch_data(:,i),'LineWidth',0.5);
xlabel('time (s)','FontSize',sz)
ylabel('Amp (a.u.)','FontSize',sz)
xlim([a round(max(tOff))])


title(ChName{i},'FontSize',sz)

end

set(gcf,'Position',[100,100,1000,500]);






end 