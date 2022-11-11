function h=plotWaveform_s(Ch_data,ChName,ind,fsDS,titleAll,xTickName)

tOff=((0:(length(Ch_data)-1))/fsDS)';

h(1)=figure;
a=0; % start from 5s 
sz=10;
cN={'red','blue','red','blue','red','blue','red','blue','red','blue'};
n=size(Ch_data,2);
for i =1:n
ax(i)=subplot(n,1,i);

plot(tOff,Ch_data(:,i),'color',cN{i},'LineWidth',1);

xlabel('time (s)','FontSize',sz)
ylabel('Amp (a.u.)','FontSize',sz)
xlim([a round(max(tOff))])
title([ChName{i},' ; ',num2str(ind(i))],'FontSize',sz)
xlim([a round(max(tOff))])
xticks(5:5:round(max(tOff)))
xticklabels(xTickName)

end

set(gcf,'Position',[50,50,1800,150*n]);

sgtitle(titleAll);


linkaxes(ax,'x')

end 