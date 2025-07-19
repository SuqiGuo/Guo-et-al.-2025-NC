load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/contrib/cd_string.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/shea_util.ncl"
begin
;......................................................................
myfilect = addfile("/work/bm1147/b380949/web-monitoring/CESM/cover/Lunit/div_Lunit_coverfrc_noWH.nc","r")

myfile = addfile("/work/bm1147/b380949/web-monitoring/CESM/cover/Lunit/Lunit_coverfrc_FRST_nourb_decimal.nc","r")

myfileh = addfile("/work/bm1147/b380949/web-monitoring/CESM/cover/Lunit/Lunit_coverfrc_HARV_nourb_decimal.nc","r")
myfilei = addfile("/work/bm1147/b380949/web-monitoring/CESM/cover/Lunit/Lunit_coverfrc_IRR_nourb_decimal.nc","r")

myfilec = addfile("/work/bm1147/b380949/web-monitoring/CESM/cover/Lunit/Lunit_coverfrc_CROP_nourb_decimal.nc","r")

myfile3 = addfile("/work/bm1147/b380949/CESM/crop/crop_TOTECOSYSC_yr_lunit_rs.nc", "r")
lunit_type=myfile3->lunit

PCT_NATVEG_ctl=myfilect->PCT_NATVEG
PCT_CROP_ctl=myfilect->PCT_CROP
PCT_GLACIER_ctl=myfilect->PCT_GLACIER
PCT_LAKE_ctl=myfilect->PCT_LAKE
PCT_URBAN_ctl=myfilect->PCT_URBAN
PCT_URBAN_ctl!0="lunit"


PCT_NATVEG_frst=myfile->PCT_NATVEG
PCT_CROP_frst=myfile->PCT_CROP
PCT_GLACIER_frst=myfile->PCT_GLACIER
PCT_LAKE_frst=myfile->PCT_LAKE
PCT_URBAN_frst=myfile->PCT_URBAN
PCT_URBAN_frst!0="lunit"

PCT_NATVEG_crop=myfilec->PCT_NATVEG
PCT_CROP_crop=myfilec->PCT_CROP
PCT_GLACIER_crop=myfilec->PCT_GLACIER
PCT_LAKE_crop=myfilec->PCT_LAKE
PCT_URBAN_crop=myfilec->PCT_URBAN
PCT_URBAN_crop!0="lunit"

PCT_NATVEG_harv=myfileh->PCT_NATVEG
PCT_CROP_harv=myfileh->PCT_CROP
PCT_GLACIER_harv=myfileh->PCT_GLACIER
PCT_LAKE_harv=myfileh->PCT_LAKE
PCT_URBAN_harv=myfileh->PCT_URBAN
PCT_URBAN_harv!0="lunit"

PCT_NATVEG_irr=myfilei->PCT_NATVEG
PCT_CROP_irr=myfilei->PCT_CROP
PCT_GLACIER_irr=myfilei->PCT_GLACIER
PCT_LAKE_irr=myfilei->PCT_LAKE
PCT_URBAN_irr=myfilei->PCT_URBAN
PCT_URBAN_irr!0="lunit"


comp_pft_frst=new((/7,192,288/),typeof(PCT_NATVEG_irr))
comp_pft_frst(0,:,:)=PCT_NATVEG_frst
comp_pft_frst(1,:,:)=PCT_CROP_frst
comp_pft_frst(2,:,:)=PCT_GLACIER_frst
comp_pft_frst(3,:,:)=PCT_LAKE_frst
comp_pft_frst(4,:,:)=PCT_URBAN_frst(0,:,:)
comp_pft_frst(5,:,:)=PCT_URBAN_frst(1,:,:)
comp_pft_frst(6,:,:)=PCT_URBAN_frst(2,:,:)

comp_pft_crop=new((/7,192,288/),typeof(PCT_NATVEG_irr))
comp_pft_crop(0,:,:)=PCT_NATVEG_crop
comp_pft_crop(1,:,:)=PCT_CROP_crop
comp_pft_crop(2,:,:)=PCT_GLACIER_crop
comp_pft_crop(3,:,:)=PCT_LAKE_crop
comp_pft_crop(4,:,:)=PCT_URBAN_crop(0,:,:)
comp_pft_crop(5,:,:)=PCT_URBAN_crop(1,:,:)
comp_pft_crop(6,:,:)=PCT_URBAN_crop(2,:,:)

comp_pft_harv=new((/7,192,288/),typeof(PCT_NATVEG_irr))
comp_pft_harv(0,:,:)=PCT_NATVEG_harv
comp_pft_harv(1,:,:)=PCT_CROP_harv
comp_pft_harv(2,:,:)=PCT_GLACIER_harv
comp_pft_harv(3,:,:)=PCT_LAKE_harv
comp_pft_harv(4,:,:)=PCT_URBAN_harv(0,:,:)
comp_pft_harv(5,:,:)=PCT_URBAN_harv(1,:,:)
comp_pft_harv(6,:,:)=PCT_URBAN_harv(2,:,:)

comp_pft_irr=new((/7,192,288/),typeof(PCT_NATVEG_irr))
comp_pft_irr(0,:,:)=PCT_NATVEG_irr
comp_pft_irr(1,:,:)=PCT_CROP_irr
comp_pft_irr(2,:,:)=PCT_GLACIER_irr
comp_pft_irr(3,:,:)=PCT_LAKE_irr
comp_pft_irr(4,:,:)=PCT_URBAN_irr(0,:,:)
comp_pft_irr(5,:,:)=PCT_URBAN_irr(1,:,:)
comp_pft_irr(6,:,:)=PCT_URBAN_irr(2,:,:)

comp_pft_ctl=new((/7,192,288/),typeof(PCT_NATVEG_irr))
comp_pft_ctl(0,:,:)=PCT_NATVEG_ctl
comp_pft_ctl(1,:,:)=PCT_CROP_ctl
comp_pft_ctl(2,:,:)=PCT_GLACIER_ctl
comp_pft_ctl(3,:,:)=PCT_LAKE_ctl
comp_pft_ctl(4,:,:)=PCT_URBAN_ctl(0,:,:)
comp_pft_ctl(5,:,:)=PCT_URBAN_ctl(1,:,:)
comp_pft_ctl(6,:,:)=PCT_URBAN_ctl(2,:,:)

printVarSummary(comp_pft_frst)
printVarSummary(comp_pft_ctl)
printVarSummary(comp_pft_crop)
printVarSummary(comp_pft_harv)
;comp_pft_frst=new((/78,192,288/),typeof(nat_frst))
lunit=new((/7/),typeof(lunit_type))
lunit=ispan(0, 6, 1)
;pft(14:77)=cft(:)
;copy_VarMeta(natpft, pft)
lunit@units="index"
lunit@long_name = "indices of lunits"
lunit@axis = "Z"

comp_pft_harv!0= "lunit"
comp_pft_harv&lunit=lunit

comp_pft_ctl!0= "lunit"
comp_pft_ctl&lunit=lunit

comp_pft_irr!0= "lunit"
comp_pft_irr&lunit=lunit

comp_pft_crop!0= "lunit"
comp_pft_crop&lunit=lunit

comp_pft_frst!0= "lunit"
comp_pft_frst&lunit=lunit

diro = "/work/bm1147/b380949/web-monitoring/CESM/cover/Lunit/final/"                     ; Output directory
        filo = "fract_crop_7lunits.nc"             ; Output file
  system("/bin/rm -f " + diro + filo)    ; remove if exists
  fout  = addfile (diro + filo, "c")  ; open output file
   setfileoption(fout,"DefineMode",False)
      fout->fract_lunits  = (comp_pft_crop)   
     ; fout->PFTs  = (metadata_pft)
 diro1 = "/work/bm1147/b380949/web-monitoring/CESM/cover/Lunit/final/"                     ; Output directory
        filo1 = "fract_frst_7lunits.nc"             ; Output file
  system("/bin/rm -f " + diro1 + filo1)    ; remove if exists
  fout1  = addfile (diro1 + filo1, "c")  ; open output file
   setfileoption(fout1,"DefineMode",False)
      fout1->fract_lunits  = (comp_pft_frst)   

  diro2 = "/work/bm1147/b380949/web-monitoring/CESM/cover/Lunit/final/"                     ; Output directory
        filo2 = "div_fract_ctl_7lunits.nc"             ; Output file
  system("/bin/rm -f " + diro2 + filo2)    ; remove if exists
  fout2  = addfile (diro2 + filo2, "c")  ; open output file
   setfileoption(fout2,"DefineMode",False)
      fout2->fract_lunits  = (comp_pft_ctl)   

 diro3 = "/work/bm1147/b380949/web-monitoring/CESM/cover/Lunit/final/"                     ; Output directory
        filo3 = "fract_harv_7lunits.nc"             ; Output file
  system("/bin/rm -f " + diro3 + filo3)    ; remove if exists
  fout3  = addfile (diro3 + filo3, "c")  ; open output file
   setfileoption(fout3,"DefineMode",False)
      fout3->fract_lunits  = (comp_pft_harv)  

 diro4 = "/work/bm1147/b380949/web-monitoring/CESM/cover/Lunit/final/"                     ; Output directory
        filo4 = "fract_irr_7lunits.nc"             ; Output file
  system("/bin/rm -f " + diro4 + filo4)    ; remove if exists
  fout4  = addfile (diro4 + filo4, "c")  ; open output file
   setfileoption(fout4,"DefineMode",False)
      fout4->fract_lunits  = (comp_pft_irr)  

end


