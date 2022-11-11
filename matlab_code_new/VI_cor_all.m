function [Ch_data_epoch_complex_new,Ch_data_complex_new]=VI_cor_all(Ch_data_epoch_complex,Ch_data_complex,label)
Ch_data_epoch_complex_new=Ch_data_epoch_complex;
Ch_data_epoch_complex_new(:,:,:)=0;
for i=1:size(Ch_data_complex,2)
   [Ch_data_epoch_complex_new(:,i,:),Ch_data_complex_new(:,i)]=VI_cor(Ch_data_epoch_complex(:,i,:),Ch_data_complex(:,i),label);
    
end

end
function  [data_epoch_complex_new,data_complex_new]=VI_cor(data_epoch_complex,data_complex,label)

    num=0;
  
    inject_vec=[];
    inject_vec_ph=[];
    inject_vec_amp=[];
    data_epoch_complex=reshape(data_epoch_complex,size(data_epoch_complex,1),size(data_epoch_complex,3));
    for m=0:0.25:1
        for n=0:pi/20:2*pi
            
           
            vec_swp(num+1)=mean(abs(data_complex))*m*exp(n*1i);
            
            inject_vec(:,num+1)=data_complex-vec_swp(end);
            inject_vec_epoch(:,:,num+1)=data_epoch_complex-vec_swp(end);
            % only use amplitude 
            inject_vec_com(:,num+1)=m*exp(n*1i);
    
            
            cor_all(num+1)=VI(inject_vec(:,num+1),inject_vec_epoch(:,:,num+1),label);
            
            num=num+1;
        end
    end
            
            
[min_cor,ind]=max(cor_all);

data_complex_new=abs(inject_vec(:,ind));
data_epoch_complex_new=abs(inject_vec_epoch(:,:,ind));

inject_vec_com(ind)
 


end


function Cor_all=VI(inject_vec,inject_vec_epoch,label)
    
            
            for i=1:length(label)
                if i==length(label)
                    i_same=i-1;
                elseif label(i+1)==label(i)
                i_same=i+1;
                else i_same=i-1;
                end
              inject_vec_epoch=abs(inject_vec_epoch);  
%   r1= corrcoef(inject_vec_epoch(:,i),inject_vec_epoch(:,i_same)); 
%  r_cor_all(i) = r1(1,2);
 fsDS=500;
[x,r]=xcorr(inject_vec_epoch(:,i),inject_vec_epoch(:,i_same),fsDS,'normalized');  % x+m, y 
 r_cor_all(i)=max(x);
%         
%         dist_all(i)=dtw(inject_vec_epoch(:,i),inject_vec_epoch(:,i_same));
        

            end
            Cor_all=mean(r_cor_all);
end