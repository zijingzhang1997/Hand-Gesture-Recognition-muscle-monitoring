

ExpDate='ZZ_v3';


SavePath=['D:\air drawRMG\data\',ExpDate,'\','feat_all\'];  

filtList=[0.1 5; 0.05 10 ;0.05 15];

for i=1:3
    Feat_ver=['filt_',num2str(filtList(i,1)),'_',num2str(filtList(i,2))];
    load([SavePath,'Data_all','Routine1',Feat_ver,'.mat']);
   
    feature_all_load{1}=feature_all;feature_all_complex_load{1}=feature_all_complex;
    label_all_load{1}=label_all;labelName_all_load{1}=labelName_all;
  
    opt_load{1}=opt_all;count_load{1}=count;
    caseNum_all_load{1}=caseNum_all;
    RoutineNum_all_load{1}=RoutineNum_all;
    
    
    load([SavePath,'Data_all','Routine2',Feat_ver,'.mat']);
  
    feature_all_load{2}=feature_all;feature_all_complex_load{2}=feature_all_complex;
    label_all_load{2}=label_all;labelName_all_load{2}=labelName_all;

    opt_load{2}=opt_all;count_load{2}=count;
    caseNum_all_load{2}=caseNum_all+max(caseNum_all_load{1});
    RoutineNum_all_load{2}=RoutineNum_all;
    
    feature_all=cat(3,feature_all_load{1},feature_all_load{2});
    
    feature_all_complex=cat(3,feature_all_complex_load{1},feature_all_complex_load{2});
    label_all=cat(1,label_all_load{1},label_all_load{2});
    labelName_all=cat(1,labelName_all_load{1},labelName_all_load{2});
   
    
    caseNum_all=cat(1,caseNum_all_load{1},caseNum_all_load{2});
    RoutineNum_all=cat(1,RoutineNum_all_load{1},RoutineNum_all_load{2});
    
    
    count.label_count =uniqueCount(label_all);
    
    count.case_count =uniqueCount(caseNum_all);
    

    
    save([SavePath,'Data_comb',Feat_ver,'.mat'],...
        'feature_all',...
        'feature_all_complex',...
    'feature_all_emg',...
        'label_all',...
        'caseNum_all','RoutineNum_all','Chan_Name','labelName_all','labelName',...
        'opt_load','count','-v7.3');
    
end
