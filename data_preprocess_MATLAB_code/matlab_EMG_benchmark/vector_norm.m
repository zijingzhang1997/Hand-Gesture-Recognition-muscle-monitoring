function  [ncs_complex_normalized]=vector_norm(amp,phase,toff,opt,fsDS,fs)

    amp=resample(amp,fsDS,fs);
    amp=amp((toff(1)*fsDS):toff(size(toff))*fsDS);
    
    phase=resample(phase,fsDS,fs);
    phase=phase((toff(1)*fsDS):toff(size(toff))*fsDS);
    
    
    
    phase_filt = ncs_filt(phase,opt.Vec_fLow,opt.Vec_fHigh,fsDS,opt.Vec_filtType);
    amp_filt = ncs_filt(amp,opt.Vec_fLow,opt.Vec_fHigh,fsDS,opt.Vec_filtType);
    
    phase=phase_filt;
    amp=amp_filt;
    phase=exp(phase/180*pi*1i);
    magnitude=abs(amp);

    ncs_complex = magnitude.*phase;


    ncs_complex = ncs_complex- complex(min(real(ncs_complex)),min(imag(ncs_complex)));

    real_mean = mean(real(ncs_complex));
    imag_mean = mean(imag(ncs_complex));


    complex_angle_shift_rate = real(ncs_complex)\imag(ncs_complex);
    complex_angle_shift = atan(complex_angle_shift_rate);
    
    
    % complex - mini value . So in first Quadrant  real & img >0
    % shift angle to close to pi/4 
    ncs_complex_normalized = ncs_complex.*exp(-complex_angle_shift*1i).*exp(pi/4*1i);
    
    
    
    ncs_complex_normalized=ncs_complex_normalized/mean(abs(ncs_complex_normalized));
    ncs_complex_1=real(ncs_complex_normalized);
    ncs_complex_2=imag(ncs_complex_normalized);
    
    
%     
%     num=0;
%     template=resample(template,25,500);
%     inject_vec=[];
%     inject_vec_ph=[];
%     inject_vec_amp=[];
%     
%     for m=0:0.1:0.9
%         for n=0:pi/4:2*pi
%             
%            
%             vec_swp(num+1)=mean(abs(ncs_complex_normalized))*m*exp(n*1i);
%             
%             inject_vec=ncs_complex_normalized-vec_swp(end);
%             
%             inject_vec_amp(:,num+1)=abs(inject_vec);
%             inject_vec_ph(:,num+1)=angle(inject_vec);
%             dtw_inject_vec_amp(num+1)=dtw(inject_vec_amp(:,end),template);
%             dtw_inject_vec_ph(num+1)=dtw(inject_vec_ph(:,end),template);
%             num=num+1;
%         end
%     end
%             
%             
% [min_dtw,ind]=min(dtw_inject_vec_ph);
% 
% n=4;
% figure()
% subplot(n,1,1);
% plot(inject_vec_ph(:,ind));
% title('injected vector min DTW');
% 
% subplot(n,1,2);
% plot(inject_vec_ph(:,10));
% title('injected vector example');
% subplot(n,1,3);
% plot(template);
% title('template');
% subplot(n,1,4);
% plot(inject_vec_ph(:,1));
% title('without inject');

end