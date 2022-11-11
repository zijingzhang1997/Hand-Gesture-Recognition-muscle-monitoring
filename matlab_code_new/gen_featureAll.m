% combine all results in the same Routine 

ExpDate='ZZ_v3';

Routine=2;  %

ind=1:7;

i_ind=ind;

 filt=[0.1,5];
% 
filt2=[0.05,10];
filt3=[0.05,15];
% 
gen_feat(ExpDate,filt,Routine,i_ind);
gen_feat(ExpDate,filt2,Routine,i_ind);
gen_feat(ExpDate,filt3,Routine,i_ind);



function gen_feat(ExpDate,filt,R,i_ind)

dataPath=['D:\air drawRMG\data\',ExpDate,'\','feature\'];
SavePath=['D:\air drawRMG\data\',ExpDate,'\','feat_all\'];

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







count.label_count =uniqueCount(label_all);


count.case_count =uniqueCount(caseNum_all);

save([SavePath,'Data_all',RoutineNum,Feat_ver,'.mat'],...
'feature_all_complex',...
'feature_all',...
'feature_all_emg',...
'label_all',...
'caseNum_all','RoutineNum_all','Chan_Name','labelName_all','labelName',...
'opt_all','count','-v7.3');


end


