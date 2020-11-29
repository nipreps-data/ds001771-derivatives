

#---------------------------------
# New invocation of recon-all Wed Jan 15 18:19:52 UTC 2020 

 mri_convert /data/sub-36/anat/sub-36_T1w.nii.gz /out/freesurfer/sub-36/mri/orig/001.mgz 

#--------------------------------------------
#@# T2/FLAIR Input Wed Jan 15 18:20:04 UTC 2020

 mri_convert --no_scale 1 /data/sub-36/anat/sub-36_T2w.nii.gz /out/freesurfer/sub-36/mri/orig/T2raw.mgz 

#--------------------------------------------
#@# MotionCor Wed Jan 15 18:20:10 UTC 2020

 cp /out/freesurfer/sub-36/mri/orig/001.mgz /out/freesurfer/sub-36/mri/rawavg.mgz 


 mri_convert /out/freesurfer/sub-36/mri/rawavg.mgz /out/freesurfer/sub-36/mri/orig.mgz --conform_min 


 mri_add_xform_to_header -c /out/freesurfer/sub-36/mri/transforms/talairach.xfm /out/freesurfer/sub-36/mri/orig.mgz /out/freesurfer/sub-36/mri/orig.mgz 

#--------------------------------------------
#@# Talairach Wed Jan 15 18:20:28 UTC 2020

 mri_nu_correct.mni --no-rescale --i orig.mgz --o orig_nu.mgz --n 1 --proto-iters 1000 --distance 50 


 talairach_avi --i orig_nu.mgz --xfm transforms/talairach.auto.xfm 

talairach_avi log file is transforms/talairach_avi.log...

 cp transforms/talairach.auto.xfm transforms/talairach.xfm 

#--------------------------------------------
#@# Talairach Failure Detection Wed Jan 15 18:24:30 UTC 2020

 talairach_afd -T 0.005 -xfm transforms/talairach.xfm 


 awk -f /opt/freesurfer/bin/extract_talairach_avi_QA.awk /out/freesurfer/sub-36/mri/transforms/talairach_avi.log 


 tal_QC_AZS /out/freesurfer/sub-36/mri/transforms/talairach_avi.log 

#--------------------------------------------
#@# Nu Intensity Correction Wed Jan 15 18:24:30 UTC 2020

 mri_nu_correct.mni --i orig.mgz --o nu.mgz --uchar transforms/talairach.xfm --cm --n 2 


 mri_add_xform_to_header -c /out/freesurfer/sub-36/mri/transforms/talairach.xfm nu.mgz nu.mgz 

#--------------------------------------------
#@# Intensity Normalization Wed Jan 15 18:30:30 UTC 2020

 mri_normalize -g 1 -mprage -noconform nu.mgz T1.mgz 



#---------------------------------
# New invocation of recon-all Wed Jan 15 18:49:42 UTC 2020 
#-------------------------------------
#@# EM Registration Wed Jan 15 18:49:48 UTC 2020

 mri_em_register -rusage /out/freesurfer/sub-36/touch/rusage.mri_em_register.dat -uns 3 -mask brainmask.mgz nu.mgz /opt/freesurfer/average/RB_all_2016-05-10.vc700.gca transforms/talairach.lta 

#--------------------------------------
#@# CA Normalize Wed Jan 15 18:55:25 UTC 2020

 mri_ca_normalize -c ctrl_pts.mgz -mask brainmask.mgz nu.mgz /opt/freesurfer/average/RB_all_2016-05-10.vc700.gca transforms/talairach.lta norm.mgz 

#--------------------------------------
#@# CA Reg Wed Jan 15 18:58:37 UTC 2020

 mri_ca_register -rusage /out/freesurfer/sub-36/touch/rusage.mri_ca_register.dat -nobigventricles -T transforms/talairach.lta -align-after -mask brainmask.mgz norm.mgz /opt/freesurfer/average/RB_all_2016-05-10.vc700.gca transforms/talairach.m3z 

#--------------------------------------
#@# SubCort Seg Wed Jan 15 20:51:19 UTC 2020

 mri_ca_label -relabel_unlikely 9 .3 -prior 0.5 -align norm.mgz transforms/talairach.m3z /opt/freesurfer/average/RB_all_2016-05-10.vc700.gca aseg.auto_noCCseg.mgz 


 mri_cc -aseg aseg.auto_noCCseg.mgz -o aseg.auto.mgz -lta /out/freesurfer/sub-36/mri/transforms/cc_up.lta sub-36 

#--------------------------------------
#@# Merge ASeg Wed Jan 15 22:17:53 UTC 2020

 cp aseg.auto.mgz aseg.presurf.mgz 

#--------------------------------------------
#@# Intensity Normalization2 Wed Jan 15 22:17:54 UTC 2020

 mri_normalize -mprage -aseg aseg.presurf.mgz -mask brainmask.mgz norm.mgz brain.mgz 

#--------------------------------------------
#@# Mask BFS Wed Jan 15 22:23:57 UTC 2020

 mri_mask -T 5 brain.mgz brainmask.mgz brain.finalsurfs.mgz 

#--------------------------------------------
#@# WM Segmentation Wed Jan 15 22:24:06 UTC 2020

 mri_segment -mprage brain.mgz wm.seg.mgz 


 mri_edit_wm_with_aseg -keep-in wm.seg.mgz brain.mgz aseg.presurf.mgz wm.asegedit.mgz 


 mri_pretess wm.asegedit.mgz wm norm.mgz wm.mgz 

#--------------------------------------------
#@# Fill Wed Jan 15 22:27:34 UTC 2020

 mri_fill -a ../scripts/ponscc.cut.log -xform transforms/talairach.lta -segmentation aseg.auto_noCCseg.mgz wm.mgz filled.mgz 



#---------------------------------
# New invocation of recon-all Thu Jan 16 00:29:03 UTC 2020 
#--------------------------------------------
#@# Refine Pial Surfs w/ T2/FLAIR Thu Jan 16 00:29:10 UTC 2020

 bbregister --s sub-36 --mov /out/freesurfer/sub-36/mri/orig/T2raw.mgz --lta /out/freesurfer/sub-36/mri/transforms/T2raw.auto.lta --init-coreg --T2 


 cp /out/freesurfer/sub-36/mri/transforms/T2raw.auto.lta /out/freesurfer/sub-36/mri/transforms/T2raw.lta 


 mri_convert -odt float -at /out/freesurfer/sub-36/mri/transforms/T2raw.lta -rl /out/freesurfer/sub-36/mri/orig.mgz /out/freesurfer/sub-36/mri/orig/T2raw.mgz /out/freesurfer/sub-36/mri/T2.prenorm.mgz 


 mri_normalize -sigma 0.5 -nonmax_suppress 0 -min_dist 1 -aseg /out/freesurfer/sub-36/mri/aseg.presurf.mgz -surface /out/freesurfer/sub-36/surf/rh.white identity.nofile -surface /out/freesurfer/sub-36/surf/lh.white identity.nofile /out/freesurfer/sub-36/mri/T2.prenorm.mgz /out/freesurfer/sub-36/mri/T2.norm.mgz 


 mri_mask /out/freesurfer/sub-36/mri/T2.norm.mgz /out/freesurfer/sub-36/mri/brainmask.mgz /out/freesurfer/sub-36/mri/T2.mgz 


 cp -v /out/freesurfer/sub-36/surf/lh.pial /out/freesurfer/sub-36/surf/lh.woT2.pial 


 mris_make_surfaces -orig_white white -orig_pial woT2.pial -aseg ../mri/aseg.presurf -nowhite -mgz -T1 brain.finalsurfs -T2 ../mri/T2 -nsigma_above 2 -nsigma_below 5 sub-36 lh 


 cp -v /out/freesurfer/sub-36/surf/rh.pial /out/freesurfer/sub-36/surf/rh.woT2.pial 


 mris_make_surfaces -orig_white white -orig_pial woT2.pial -aseg ../mri/aseg.presurf -nowhite -mgz -T1 brain.finalsurfs -T2 ../mri/T2 -nsigma_above 2 -nsigma_below 5 sub-36 rh 

#--------------------------------------------
#@# Surf Volume lh Thu Jan 16 01:40:38 UTC 2020

 vertexvol --s sub-36 --lh --th3 

#--------------------------------------------
#@# Surf Volume rh Thu Jan 16 01:40:44 UTC 2020

 vertexvol --s sub-36 --rh --th3 

#--------------------------------------------
#@# Surf Volume lh Thu Jan 16 01:40:50 UTC 2020
#--------------------------------------------
#@# Surf Volume rh Thu Jan 16 01:40:57 UTC 2020
#--------------------------------------------
#@# Cortical ribbon mask Thu Jan 16 01:41:04 UTC 2020

 mris_volmask --aseg_name aseg.presurf --label_left_white 2 --label_left_ribbon 3 --label_right_white 41 --label_right_ribbon 42 --save_ribbon sub-36 



#---------------------------------
# New invocation of recon-all Thu Jan 16 02:06:53 UTC 2020 
#-----------------------------------------
#@# Relabel Hypointensities Thu Jan 16 02:07:00 UTC 2020

 mri_relabel_hypointensities aseg.presurf.mgz ../surf aseg.presurf.hypos.mgz 

#-----------------------------------------
#@# AParc-to-ASeg aparc Thu Jan 16 02:07:43 UTC 2020

 mri_aparc2aseg --s sub-36 --volmask --aseg aseg.presurf.hypos --relabel mri/norm.mgz mri/transforms/talairach.m3z /opt/freesurfer/average/RB_all_2016-05-10.vc700.gca mri/aseg.auto_noCCseg.label_intensities.txt 

#-----------------------------------------
#@# AParc-to-ASeg a2009s Thu Jan 16 02:17:29 UTC 2020

 mri_aparc2aseg --s sub-36 --volmask --aseg aseg.presurf.hypos --relabel mri/norm.mgz mri/transforms/talairach.m3z /opt/freesurfer/average/RB_all_2016-05-10.vc700.gca mri/aseg.auto_noCCseg.label_intensities.txt --a2009s 

#-----------------------------------------
#@# AParc-to-ASeg DKTatlas Thu Jan 16 02:27:17 UTC 2020

 mri_aparc2aseg --s sub-36 --volmask --aseg aseg.presurf.hypos --relabel mri/norm.mgz mri/transforms/talairach.m3z /opt/freesurfer/average/RB_all_2016-05-10.vc700.gca mri/aseg.auto_noCCseg.label_intensities.txt --annot aparc.DKTatlas --o mri/aparc.DKTatlas+aseg.mgz 

#-----------------------------------------
#@# APas-to-ASeg Thu Jan 16 02:37:00 UTC 2020

 apas2aseg --i aparc+aseg.mgz --o aseg.mgz 

#--------------------------------------------
#@# ASeg Stats Thu Jan 16 02:37:11 UTC 2020

 mri_segstats --seg mri/aseg.mgz --sum stats/aseg.stats --pv mri/norm.mgz --empty --brainmask mri/brainmask.mgz --brain-vol-from-seg --excludeid 0 --excl-ctxgmwm --supratent --subcortgray --in mri/norm.mgz --in-intensity-name norm --in-intensity-units MR --etiv --surf-wm-vol --surf-ctx-vol --totalgray --euler --ctab /opt/freesurfer/ASegStatsLUT.txt --subject sub-36 

#-----------------------------------------
#@# WMParc Thu Jan 16 02:38:24 UTC 2020

 mri_aparc2aseg --s sub-36 --labelwm --hypo-as-wm --rip-unknown --volmask --o mri/wmparc.mgz --ctxseg aparc+aseg.mgz 


 mri_segstats --seg mri/wmparc.mgz --sum stats/wmparc.stats --pv mri/norm.mgz --excludeid 0 --brainmask mri/brainmask.mgz --in mri/norm.mgz --in-intensity-name norm --in-intensity-units MR --subject sub-36 --surf-wm-vol --ctab /opt/freesurfer/WMParcStatsLUT.txt --etiv 

