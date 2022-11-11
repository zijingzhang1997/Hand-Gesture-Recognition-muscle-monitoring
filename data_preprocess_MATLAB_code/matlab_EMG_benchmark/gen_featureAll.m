
ExpDate='emg3';
Routine=2;  %
%Routine=4;  %
ind=2:8;

i_ind=ind;
filt=[0.1,5];
filt2=[0.1,1];
filt3=[0.05,10];
% 
gen_feat(ExpDate,filt,Routine,i_ind);
gen_feat(ExpDate,filt2,Routine,i_ind);
gen_feat(ExpDate,filt3,Routine,i_ind);
% % % 

i_ind=1:4;
gen_feat(ExpDate,filt,4,i_ind);
gen_feat(ExpDate,filt2,4,i_ind);
gen_feat(ExpDate,filt3,4,i_ind);


function gen_feat(ExpDate,filt,R,i_ind)
% dataPath=['D:\RFMG\data\',ExpDate,'\','feature\'];
% SavePath=['D:\RFMG\data\',ExpDate,'\','feat_all\'];
dataPath=['D:\RFMG\data\',ExpDate,'\','feature\'];
SavePath=['D:\RFMG\data\',ExpDate,'\','feat_all\'];

label_all=[];
caseNum_all=[];
labelName_all=[];
feature_all= [];
num=0;
opt_all={};

RoutineNum=['Routine',num2str(R)];

Feat_ver=['filt_',num2str(filt(1)),'_',num2str(filt(2))];
for i = i_ind
    CaseName=['Case',num2str(i)];

    fileName=[CaseName,RoutineNum];
    filePathName=[dataPath,Feat_ver,'\',fileName,'.mat'];
    
    if ~exist(filePathName,'file')
        fprintf('not found  case %s\n',fileName);
        continue
    end
    load(filePathName);
    feature=Ch_data_epoch;
    feature_complex=Ch_data_epoch_complex;
    feature_emg=Ch_data_epoch_emg;
    label=label';
    labelName=gesture';
    
    if num==0
        num = num+1;
        label_all=label;
        feature_all=feature;
        feature_all_complex=feature_complex;
        feature_all_emg=feature_emg;
        labelName_all=labelName;

        caseNum_all=zeros(length(label),1);
        caseNum_all(:)=num;
        
        RoutineNum_all=zeros(length(label),1);
        RoutineNum_all(:)=R;
        opt_all{end+1}=opt;

    else
        num=num+1;
        label_all=[label_all;label];
        feature_all=cat(3,feature_all,feature);
        feature_all_complex=cat(3,feature_all_complex,feature_complex);
        feature_all_emg=cat(3,feature_all_emg,feature_emg);
        labelName_all=[labelName_all;labelName];
 
        caseNum_all=[caseNum_all; ones(length(label),1).*num];
        RoutineNum_all=[RoutineNum_all; ones(length(label),1).*R];
        opt_all{end+1}=opt;
        
    end
   
end



% delete some special wrong cases using function 
% function has history for deleted cases in each experiment 

del=del_case(ExpDate,R,caseNum_all);


feature_all(:,:,del)=[];
feature_all_complex(:,:,del)=[];
feature_all_emg(:,:,del)=[];
label_all(del)=[];
caseNum_all(del)=[];
labelName_all(del)=[];

%%
% 'gesture','0 r','1 G','2 G*2','3 P1','4 P1*2','5 P2','6 P2*2','7 P4','8 P4*2',
%     '9  sG','10 sF', 11 sP1, 12 sP2, 13 sP4,);

% gestureLabel={'R','G','G*2','P1','P1*2','P2','P2*2','P23','P23*2','P4','P4*2','sG','sF','sP1','sP2','sP23','sP4',...
%     'U','U*2','D','D*2','sU','sD'};




count.label_count =uniqueCount(label_all);


count.case_count =uniqueCount(caseNum_all);

save([SavePath,'Data_all',RoutineNum,Feat_ver,'.mat'],...
'feature_all_complex',...
'feature_all',...
'feature_all_emg',...
'label_all',...
'caseNum_all','RoutineNum_all','Chan_Name','labelName_all','labelName',...
'opt_all','count','del');


end


