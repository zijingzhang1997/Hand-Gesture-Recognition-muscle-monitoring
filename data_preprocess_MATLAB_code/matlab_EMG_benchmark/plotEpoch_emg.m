function h=plotEpoch_emg(data,chNum,label,fs,StartEndT)

n=20;
figNum=ceil(size(data,3)/n);
for i =1:figNum
    
    h(i)=figure;
    for j=1:n
        ind=(i-1)*n+j;
        if ind <= size(data,3)
        subplot(4,n/4,j);
       
        t=1:length(data);
        t=t/fs;
        plot(t,data(:,chNum,ind));
        ylim([-4,4])
        
        a=[string(ind),string(label(ind)),num2str(StartEndT(1,ind)),':',num2str(StartEndT(2,ind))];
        a=join(a);
        title(a);
        end
        
        
    end
    sgtitle(join(['EMG ch:',string(chNum)])) 
    set(gcf,'Position',[100,100,1200,900]);
end




end