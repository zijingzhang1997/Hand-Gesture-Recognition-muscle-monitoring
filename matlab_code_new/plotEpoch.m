function h=plotEpoch(data,chNum,label,fs,StartEndT,Chan_Name)

n=42;
rown=7;
figNum=ceil(size(data,3)/n);
for i =1:figNum
    
    h(i)=figure;
    for j=1:n
        ind=(i-1)*n+j;
        if ind <= size(data,3)
        subplot(rown,n/rown,j);
       
        t=1:length(data);
        t=t/fs;
        plot(t,data(:,chNum,ind));
        ylim([-4,4])
        xlim([0,5])
%         a=[string(ind),string(label(ind)),num2str(StartEndT(1,ind)),':',num2str(StartEndT(2,ind))];
        a=[string(ind),string(label(ind))];
        a=join(a);
        title(a);
        end
        
        
    end
    sgtitle(join(['ch:',string(Chan_Name(chNum))])) 
    set(gcf,'Position',[100,100,1200,900]);
end




end