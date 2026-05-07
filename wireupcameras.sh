SENSOR="ov13858 1-0010"

# Tell each pad in the path what format to expect
sudo media-ctl -V "\"$SENSOR\":0[fmt:SGRBG10_1X10/4224x3136]"
sudo media-ctl -V '"msm_csiphy0":0[fmt:SGRBG10_1X10/4224x3136]'
sudo media-ctl -V '"msm_csiphy0":1[fmt:SGRBG10_1X10/4224x3136]'
sudo media-ctl -V '"msm_csid0":0[fmt:SGRBG10_1X10/4224x3136]'
sudo media-ctl -V '"msm_csid0":1[fmt:SGRBG10_1X10/4224x3136]'
sudo media-ctl -V '"msm_vfe0_rdi0":0[fmt:SGRBG10_1X10/4224x3136]'

# Disable the OV02C10 path so it doesn't fight for csid0
sudo media-ctl -l '"msm_csiphy4":1->"msm_csid0":0[0]'

# Enable the rear path
sudo media-ctl -l '"msm_csiphy0":1->"msm_csid0":0[1]'
