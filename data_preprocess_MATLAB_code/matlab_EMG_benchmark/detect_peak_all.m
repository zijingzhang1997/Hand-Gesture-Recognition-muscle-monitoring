function [feat1_q1,feat1_q2,feat2_q1,feat2_q2]=detect_peak_all(LoadPath,ch_NCS,ch_EMG)

load(LoadPath);


% crop wavform into 5s 
fsDS=500;
timeInd=fsDS*1+1:fsDS*6;
feature_all=feature_all(timeInd,:,:);
feature_all_emg=feature_all_emg(timeInd,:,:);


%%

% divide into quick / quick double /slow /0   gesture groups 
l_q=[2,4,6,8,10,18,20]-1;
l_q2=[3,5,7,9,11,19,21]-1;% quick motions 
l_s=[12,13,14,15,16,17,22,23]-1;
l_0=0;
ind_q=[];ind_q2=[];ind_s=[];ind_0=[];
for i=1:size(l_q,2)
   ind_temp=find(label_all==l_q(i));
   ind_q=cat(1,ind_q ,ind_temp);
end
for i=1:size(l_q2,2)
   ind_temp=find(label_all==l_q2(i));
   ind_q2=cat(1,ind_q2 ,ind_temp);
end


opt.hmin=2.5;
opt.pmin=2.5;   % quick 1 gestures 
opt.np=1;
[feat1_q1, feat2_q1]=peak_feat_multi(feature_all,feature_all_emg,[ch_NCS,ch_EMG],ind_q,opt);

opt.hmin=2;
opt.pmin=0.7;   % quick 2 gestures 
opt.np=2;
[feat1_q2, feat2_q2]=peak_feat_multi(feature_all,feature_all_emg,[ch_NCS,ch_EMG],ind_q2,opt);




end

function [feat1, feat2]=peak_feat_multi(NCS_all,EMG_all,ch,index,opt)

NCS_all=NCS_all(:,ch(1),:);
EMG_all=EMG_all(:,ch(2),:);

zero_ind=[]
for i=1:size(index)
    [feat1(:,:,i), feat2(:,:,i)]=peak_feat(NCS_all(:,index(i)),EMG_all(:,index(i)),opt);
if feat1(:,:,i)==0 | feat2(:,:,i)==0 
    zero_ind=[zero_ind;i];
end
end
 
feat1(:,:,zero_ind)=[];
feat2(:,:,zero_ind)=[];


end

function [feat1, feat2]=peak_feat(NCS_temp,EMG_temp,opt)
NCS_temp = normalize(NCS_temp);
EMG_temp = normalize(EMG_temp);
fsDS=500;
[p1,loc1,wid1,pro1]=findpeaks(NCS_temp,fsDS,'MinPeakProminence',opt.pmin,'MinPeakHeight',opt.hmin,'Npeaks',opt.np);
feat1=[p1,loc1,wid1,pro1];


[p2,loc2,wid2,pro2]=findpeaks(EMG_temp,fsDS,'MinPeakProminence',opt.pmin,'MinPeakHeight',opt.hmin,'Npeaks',opt.np);
feat2=[p2,loc2,wid2,pro2];


if size(feat1,1)~=opt.np
    feat1=zeros(opt.np,4);
end
if size(feat2,1)~=opt.np
    feat2=zeros(opt.np,4);
end  

% figure()
% findpeaks(NCS_temp,fsDS,'MinPeakProminence',opt.pmin,'Npeaks',opt.np);
% hold on 
% findpeaks(EMG_temp,fsDS,'MinPeakProminence',opt.pmin,'Npeaks',opt.np);

end