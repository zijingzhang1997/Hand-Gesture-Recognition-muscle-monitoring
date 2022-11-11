---
title: "Hand gesture recognition system by non-invasive muscle monitoring sensor "

---
Code note: For matlab_code_new:
1. CreatFolder.m: create folders to save figures, mat files 

2. Feature_case_gen_Air_draw_RMG.m: main script for reading data from
labview. Filer, segment, visualize data, read in sequence of different cases

3. gen_featureAll.m: combine all results in the same Routine 

4.gen_feat_comb: combine all different routines into one final result,
will further be uploaded to coLAB for ML ALGORIHTM


<img src='/images/RMG/RMG_HGR.gif'><br/>
<img src='/images/RMG/setup.png'>  <br/>
[SLIDES FOR MORE DETAILS](http://zijingzhang1997.github.io/files/RMG/RMG_HGR_intro.pdf)

Conventional electromyography (EMG) measures the continuous neural activity during muscle contraction, but lacks explicit quantification of the actual contraction. Here we propose a novel radiomyography (RMG) for continuous muscle actuation sensing that can be wearable and touchless, capturing both superficial and deep muscle groups. 
<img src='/images/RMG/ges23.png'> 
We verified RMG experimentally by a forearm wearable sensor for 23 hand gesture recognition. 

<img src='/images/RMG/sigProc.png'><br/>  
We first converted the radio sensing outputs to the time-frequency spectrogram, and then employed the vision transformer (ViT) deep learning network as the classification model, which can recognize 23 gestures with an average accuracy up to 99% on 8 subjects. By transfer learning, high adaptivity to user difference and sensor variation were achieved at an average accuracy up to 97%. 

**For Vision Tranformer, here is the [link](https://github.com/lucidrains/vit-pytorch)**

<img src='/images/RMG/timeLag.png'><br/> 
Waveforms recorded from RMG, sEMG for fast finger motion of 150 beats/minute.
RMG has ultra-low latency with the sampling rate readily over 100,000 samples per second (Sps), which is important for dynamic HGR. 

<img src='/images/RMG/RMG_EMG.png'>
Benchmark: RMG and sEMG waveforms for various gestures by DTW averaging on all samples with the same gesture.   

<img src='/images/RMG/extension.png'> 
To validate the general applicability of RMG to different skeletal muscles, we further extended the setup to wearable radiooculogram (ROG) on eyes and RMG on legs. 
<img src='/images/nonContact.gif'> <br/> 
**Applications**:
RMG has the unique advantage to monitor internal muscles non-invasively. In the future, RMG and EMG can be fused together to derive the full information of stimulation and actuation. RMG can lead to new methods for assessment of muscle functions, monitoring of muscle fatigue, and diagnosis of neuromuscular disorders. RMG is also promising for future HCI applications including exoskeleton robotic control, virtual reality interface, and in-air gesture capture. 

