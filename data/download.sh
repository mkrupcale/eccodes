#!/bin/sh

DATA_DIR=$1
VERBOSE=0

# Check if all downloads are already done
DOWNLOADED=${DATA_DIR}/.downloaded
if [ -f $DOWNLOADED ]; then
   exit 0
fi

files="
    bad.grib
    in_copy.grib
    budg
    constant_field.grib1
    constant_width_bitmap.grib
    constant_width_boust_bitmap.grib
    gen.grib
    gen_bitmap.grib
    gen_ext_bitmap.grib
    gen_ext_boust_bitmap.grib
    gen_ext_boust.grib
    gen_ext.grib
    gen_ext_spd_2_bitmap.grib
    gen_ext_spd_2_boust_bitmap.grib
    gen_ext_spd_2.grib
    gen_ext_spd_3_boust_bitmap.grib
    gen_ext_spd_3.grib
    gfs.c255.grib2
    gts.grib
    index.grib
    grid_ieee.grib
    jpeg.grib2
    lfpw.grib1
    missing_field.grib1
    missing.grib2
    mixed.grib
    multi_created.grib2
    multi.grib2
    pad.grib
    reduced_gaussian_lsm.grib1
    reduced_gaussian_model_level.grib1
    reduced_gaussian_model_level.grib2
    reduced_gaussian_pressure_level_constant.grib1
    reduced_gaussian_pressure_level_constant.grib2
    reduced_gaussian_pressure_level.grib1
    reduced_gaussian_pressure_level.grib2
    reduced_gaussian_sub_area.grib1
    reduced_gaussian_sub_area.grib2
    reduced_gaussian_surface.grib1
    reduced_gaussian_surface.grib2
    reduced_gaussian_surface_jpeg.grib2
    reduced_latlon_surface_constant.grib1
    reduced_latlon_surface_constant.grib2
    reduced_latlon_surface.grib1
    reduced_latlon_surface.grib2
    reference_ensemble_mean.grib1
    reference_stdev.grib1
    regular_gaussian_model_level.grib1
    regular_gaussian_model_level.grib2
    regular_gaussian_pressure_level_constant.grib1
    regular_gaussian_pressure_level_constant.grib2
    regular_gaussian_pressure_level.grib1
    regular_gaussian_pressure_level.grib2
    regular_gaussian_surface.grib1
    regular_gaussian_surface.grib2
    regular_latlon_surface_constant.grib1
    regular_latlon_surface_constant.grib2
    regular_latlon_surface.grib1
    regular_latlon_surface.grib2
    row.grib
    sample.grib2
    satellite.grib
    second_ord_rbr.grib1
    simple_bitmap.grib
    simple.grib
    small_ensemble.grib1
    spectral_compex.grib1
    spectral_complex.grib1
    spherical_model_level.grib1
    spherical_pressure_level.grib1
    sst_globus0083.grib
    test.grib1
    test_uuid.grib2
    tigge_af_ecmwf.grib2
    tigge_cf_ecmwf.grib2
    tigge_ecmwf.grib2
    tigge_pf_ecmwf.grib2
    timeRangeIndicator_0.grib
    timeRangeIndicator_10.grib
    timeRangeIndicator_5.grib
    tp_ecmwf.grib
    v.grib2
    tigge/tigge_ammc_pl_gh.grib
    tigge/tigge_ammc_pl_q.grib
    tigge/tigge_ammc_pl_t.grib
    tigge/tigge_ammc_pl_u.grib
    tigge/tigge_ammc_pl_v.grib
    tigge/tigge_ammc_sfc_10u.grib
    tigge/tigge_ammc_sfc_10v.grib
    tigge/tigge_ammc_sfc_2t.grib
    tigge/tigge_ammc_sfc_lsm.grib
    tigge/tigge_ammc_sfc_mn2t6.grib
    tigge/tigge_ammc_sfc_msl.grib
    tigge/tigge_ammc_sfc_mx2t6.grib
    tigge/tigge_ammc_sfc_orog.grib
    tigge/tigge_ammc_sfc_sf.grib
    tigge/tigge_ammc_sfc_sp.grib
    tigge/tigge_ammc_sfc_st.grib
    tigge/tigge_ammc_sfc_tcc.grib
    tigge/tigge_ammc_sfc_tcw.grib
    tigge/tigge_ammc_sfc_tp.grib
    tigge/tigge_babj_pl_gh.grib
    tigge/tigge_babj_pl_q.grib
    tigge/tigge_babj_pl_t.grib
    tigge/tigge_babj_pl_u.grib
    tigge/tigge_babj_pl_v.grib
    tigge/tigge_babj_sfc_10u.grib
    tigge/tigge_babj_sfc_10v.grib
    tigge/tigge_babj_sfc_2d.grib
    tigge/tigge_babj_sfc_2t.grib
    tigge/tigge_babj_sfc_lsm.grib
    tigge/tigge_babj_sfc_mn2t6.grib
    tigge/tigge_babj_sfc_msl.grib
    tigge/tigge_babj_sfc_mx2t6.grib
    tigge/tigge_babj_sfc_orog.grib
    tigge/tigge_babj_sfc_sd.grib
    tigge/tigge_babj_sfc_sf.grib
    tigge/tigge_babj_sfc_slhf.grib
    tigge/tigge_babj_sfc_sp.grib
    tigge/tigge_babj_sfc_sshf.grib
    tigge/tigge_babj_sfc_ssr.grib
    tigge/tigge_babj_sfc_str.grib
    tigge/tigge_babj_sfc_tcc.grib
    tigge/tigge_babj_sfc_tcw.grib
    tigge/tigge_babj_sfc_tp.grib
    tigge/tigge_cwao_pl_gh.grib
    tigge/tigge_cwao_pl_q.grib
    tigge/tigge_cwao_pl_t.grib
    tigge/tigge_cwao_pl_u.grib
    tigge/tigge_cwao_pl_v.grib
    tigge/tigge_cwao_sfc_10u.grib
    tigge/tigge_cwao_sfc_10v.grib
    tigge/tigge_cwao_sfc_2d.grib
    tigge/tigge_cwao_sfc_2t.grib
    tigge/tigge_cwao_sfc_mn2t6.grib
    tigge/tigge_cwao_sfc_msl.grib
    tigge/tigge_cwao_sfc_mx2t6.grib
    tigge/tigge_cwao_sfc_orog.grib
    tigge/tigge_cwao_sfc_sd.grib
    tigge/tigge_cwao_sfc_skt.grib
    tigge/tigge_cwao_sfc_sp.grib
    tigge/tigge_cwao_sfc_st.grib
    tigge/tigge_cwao_sfc_tcc.grib
    tigge/tigge_cwao_sfc_tcw.grib
    tigge/tigge_cwao_sfc_tp.grib
    tigge/tigge_ecmf_pl_gh.grib
    tigge/tigge_ecmf_pl_q.grib
    tigge/tigge_ecmf_pl_t.grib
    tigge/tigge_ecmf_pl_u.grib
    tigge/tigge_ecmf_pl_v.grib
    tigge/tigge_ecmf_pt_pv.grib
    tigge/tigge_ecmf_pv_pt.grib
    tigge/tigge_ecmf_pv_u.grib
    tigge/tigge_ecmf_pv_v.grib
    tigge/tigge_ecmf_sfc_10u.grib
    tigge/tigge_ecmf_sfc_10v.grib
    tigge/tigge_ecmf_sfc_2d.grib
    tigge/tigge_ecmf_sfc_2t.grib
    tigge/tigge_ecmf_sfc_cap.grib
    tigge/tigge_ecmf_sfc_cape.grib
    tigge/tigge_ecmf_sfc_mn2t6.grib
    tigge/tigge_ecmf_sfc_msl.grib
    tigge/tigge_ecmf_sfc_mx2t6.grib
    tigge/tigge_ecmf_sfc_sd.grib
    tigge/tigge_ecmf_sfc_sf.grib
    tigge/tigge_ecmf_sfc_skt.grib
    tigge/tigge_ecmf_sfc_slhf.grib
    tigge/tigge_ecmf_sfc_sm.grib
    tigge/tigge_ecmf_sfc_sp.grib
    tigge/tigge_ecmf_sfc_sshf.grib
    tigge/tigge_ecmf_sfc_ssr.grib
    tigge/tigge_ecmf_sfc_st.grib
    tigge/tigge_ecmf_sfc_str.grib
    tigge/tigge_ecmf_sfc_sund.grib
    tigge/tigge_ecmf_sfc_tcc.grib
    tigge/tigge_ecmf_sfc_tcw.grib
    tigge/tigge_ecmf_sfc_tp.grib
    tigge/tigge_ecmf_sfc_ttr.grib
    tigge/tigge_egrr_pl_gh.grib
    tigge/tigge_egrr_pl_q.grib
    tigge/tigge_egrr_pl_t.grib
    tigge/tigge_egrr_pl_u.grib
    tigge/tigge_egrr_pl_v.grib
    tigge/tigge_egrr_pt_pv.grib
    tigge/tigge_egrr_pv_pt.grib
    tigge/tigge_egrr_pv_u.grib
    tigge/tigge_egrr_pv_v.grib
    tigge/tigge_egrr_sfc_10u.grib
    tigge/tigge_egrr_sfc_10v.grib
    tigge/tigge_egrr_sfc_2d.grib
    tigge/tigge_egrr_sfc_2t.grib
    tigge/tigge_egrr_sfc_mn2t6.grib
    tigge/tigge_egrr_sfc_msl.grib
    tigge/tigge_egrr_sfc_mx2t6.grib
    tigge/tigge_egrr_sfc_sd.grib
    tigge/tigge_egrr_sfc_sf.grib
    tigge/tigge_egrr_sfc_skt.grib
    tigge/tigge_egrr_sfc_slhf.grib
    tigge/tigge_egrr_sfc_sm.grib
    tigge/tigge_egrr_sfc_sp.grib
    tigge/tigge_egrr_sfc_sshf.grib
    tigge/tigge_egrr_sfc_ssr.grib
    tigge/tigge_egrr_sfc_st.grib
    tigge/tigge_egrr_sfc_str.grib
    tigge/tigge_egrr_sfc_tcc.grib
    tigge/tigge_egrr_sfc_tcw.grib
    tigge/tigge_egrr_sfc_tp.grib
    tigge/tigge_egrr_sfc_ttr.grib
    tigge/tigge_kwbc_pl_gh.grib
    tigge/tigge_kwbc_pl_q.grib
    tigge/tigge_kwbc_pl_t.grib
    tigge/tigge_kwbc_pl_u.grib
    tigge/tigge_kwbc_pl_v.grib
    tigge/tigge_kwbc_pt_pv.grib
    tigge/tigge_kwbc_pv_pt.grib
    tigge/tigge_kwbc_pv_u.grib
    tigge/tigge_kwbc_pv_v.grib
    tigge/tigge_kwbc_sfc_10u.grib
    tigge/tigge_kwbc_sfc_10v.grib
    tigge/tigge_kwbc_sfc_2d.grib
    tigge/tigge_kwbc_sfc_2t.grib
    tigge/tigge_kwbc_sfc_cap.grib
    tigge/tigge_kwbc_sfc_cape.grib
    tigge/tigge_kwbc_sfc_ci.grib
    tigge/tigge_kwbc_sfc_lsm.grib
    tigge/tigge_kwbc_sfc_mn2t6.grib
    tigge/tigge_kwbc_sfc_msl.grib
    tigge/tigge_kwbc_sfc_mx2t6.grib
    tigge/tigge_kwbc_sfc_sd.grib
    tigge/tigge_kwbc_sfc_sf.grib
    tigge/tigge_kwbc_sfc_skt.grib
    tigge/tigge_kwbc_sfc_slhf.grib
    tigge/tigge_kwbc_sfc_sm.grib
    tigge/tigge_kwbc_sfc_sp.grib
    tigge/tigge_kwbc_sfc_sshf.grib
    tigge/tigge_kwbc_sfc_ssr.grib
    tigge/tigge_kwbc_sfc_st.grib
    tigge/tigge_kwbc_sfc_str.grib
    tigge/tigge_kwbc_sfc_tcw.grib
    tigge/tigge_kwbc_sfc_tp.grib
    tigge/tigge_kwbc_sfc_ttr.grib
    tigge/tigge_lfpw_pl_gh.grib
    tigge/tigge_lfpw_pl_q.grib
    tigge/tigge_lfpw_pl_t.grib
    tigge/tigge_lfpw_pl_u.grib
    tigge/tigge_lfpw_pl_v.grib
    tigge/tigge_lfpw_pv_pt.grib
    tigge/tigge_lfpw_pv_u.grib
    tigge/tigge_lfpw_pv_v.grib
    tigge/tigge_lfpw_sfc_10u.grib
    tigge/tigge_lfpw_sfc_10v.grib
    tigge/tigge_lfpw_sfc_2d.grib
    tigge/tigge_lfpw_sfc_2t.grib
    tigge/tigge_lfpw_sfc_cap.grib
    tigge/tigge_lfpw_sfc_cape.grib
    tigge/tigge_lfpw_sfc_mn2t6.grib
    tigge/tigge_lfpw_sfc_msl.grib
    tigge/tigge_lfpw_sfc_mx2t6.grib
    tigge/tigge_lfpw_sfc_sd.grib
    tigge/tigge_lfpw_sfc_sf.grib
    tigge/tigge_lfpw_sfc_skt.grib
    tigge/tigge_lfpw_sfc_slhf.grib
    tigge/tigge_lfpw_sfc_sp.grib
    tigge/tigge_lfpw_sfc_sshf.grib
    tigge/tigge_lfpw_sfc_ssr.grib
    tigge/tigge_lfpw_sfc_st.grib
    tigge/tigge_lfpw_sfc_str.grib
    tigge/tigge_lfpw_sfc_tcc.grib
    tigge/tigge_lfpw_sfc_tcw.grib
    tigge/tigge_lfpw_sfc_tp.grib
    tigge/tigge_lfpw_sfc_ttr.grib
    tigge/tigge_rjtd_pl_gh.grib
    tigge/tigge_rjtd_pl_q.grib
    tigge/tigge_rjtd_pl_t.grib
    tigge/tigge_rjtd_pl_u.grib
    tigge/tigge_rjtd_pl_v.grib
    tigge/tigge_rjtd_sfc_10u.grib
    tigge/tigge_rjtd_sfc_10v.grib
    tigge/tigge_rjtd_sfc_2d.grib
    tigge/tigge_rjtd_sfc_2t.grib
    tigge/tigge_rjtd_sfc_mn2t6.grib
    tigge/tigge_rjtd_sfc_msl.grib
    tigge/tigge_rjtd_sfc_mx2t6.grib
    tigge/tigge_rjtd_sfc_sd.grib
    tigge/tigge_rjtd_sfc_skt.grib
    tigge/tigge_rjtd_sfc_slhf.grib
    tigge/tigge_rjtd_sfc_sm.grib
    tigge/tigge_rjtd_sfc_sp.grib
    tigge/tigge_rjtd_sfc_sshf.grib
    tigge/tigge_rjtd_sfc_ssr.grib
    tigge/tigge_rjtd_sfc_str.grib
    tigge/tigge_rjtd_sfc_tcc.grib
    tigge/tigge_rjtd_sfc_tcw.grib
    tigge/tigge_rjtd_sfc_tp.grib
    tigge/tigge_rjtd_sfc_ttr.grib
    tigge/tigge_rksl_pl_gh.grib
    tigge/tigge_rksl_pl_q.grib
    tigge/tigge_rksl_pl_t.grib
    tigge/tigge_rksl_pl_u.grib
    tigge/tigge_rksl_pl_v.grib
    tigge/tigge_rksl_sfc_10u.grib
    tigge/tigge_rksl_sfc_10v.grib
    tigge/tigge_rksl_sfc_2t.grib
    tigge/tigge_rksl_sfc_msl.grib
    tigge/tigge_rksl_sfc_sp.grib
    tigge/tigge_sbsj_pl_gh.grib
    tigge/tigge_sbsj_pl_q.grib
    tigge/tigge_sbsj_pl_t.grib
    tigge/tigge_sbsj_pl_u.grib
    tigge/tigge_sbsj_pl_v.grib
    tigge/tigge_sbsj_sfc_10u.grib
    tigge/tigge_sbsj_sfc_10v.grib
    tigge/tigge_sbsj_sfc_2t.grib
    tigge/tigge_sbsj_sfc_msl.grib
    tigge/tigge_sbsj_sfc_sf.grib
    tigge/tigge_sbsj_sfc_skt.grib
    tigge/tigge_sbsj_sfc_sp.grib
    tigge/tigge_sbsj_sfc_ssr.grib
    tigge/tigge_sbsj_sfc_st.grib
    tigge/tigge_sbsj_sfc_tcc.grib
    tigge/tigge_sbsj_sfc_tcw.grib
    tigge/tigge_sbsj_sfc_tp.grib
    tigge/tiggelam_cnmc_sfc.grib
    bufr/aaen_55.bufr
    bufr/aben_55.bufr
    bufr/ahws_139.bufr
    bufr/airc_142.bufr
    bufr/airc_144.bufr
    bufr/airs_57.bufr
    bufr/alws_139.bufr
    bufr/amda_144.bufr
    bufr/amsa_55.bufr
    bufr/amsb_55.bufr
    bufr/amse_55.bufr
    bufr/amsu_55.bufr
    bufr/amv2_87.bufr
    bufr/amv3_87.bufr
    bufr/asbh_139.bufr
    bufr/asbl_139.bufr
    bufr/asca_139.bufr
    bufr/asch_139.bufr
    bufr/ascs_139.bufr
    bufr/aseh_139.bufr
    bufr/asel_139.bufr
    bufr/ashs_139.bufr
    bufr/atap_55.bufr
    bufr/ateu_155.bufr
    bufr/atms_201.bufr
    bufr/atov_55.bufr
    bufr/avhm_87.bufr
    bufr/avhn_87.bufr
    bufr/avhr_58.bufr
    bufr/b002_95.bufr
    bufr/b002_96.bufr
    bufr/b003_56.bufr
    bufr/b004_145.bufr
    bufr/b005_87.bufr
    bufr/b005_89.bufr
    bufr/b006_96.bufr
    bufr/b007_31.bufr
    bufr/bssh_170.bufr
    bufr/bssh_176.bufr
    bufr/bssh_178.bufr
    bufr/bssh_180.bufr
    bufr/btem_109.bufr
    bufr/buoy_27.bufr
    bufr/cmwi_87.bufr
    bufr/cmwn_87.bufr
    bufr/cnow_28.bufr
    bufr/cori_156.bufr
    bufr/crit_202.bufr
    bufr/csrh_189.bufr
    bufr/emsg_189.bufr
    bufr/emsg_87.bufr
    bufr/euwv_87.bufr
    bufr/fy3a_154.bufr
    bufr/fy3b_154.bufr
    bufr/g2nd_208.bufr
    bufr/g2to_206.bufr
    bufr/go15_87.bufr
    bufr/goee_87.bufr
    bufr/goes_87.bufr
    bufr/goga_89.bufr
    bufr/gosat.bufr
    bufr/grst_26.bufr
    bufr/gsd1_208.bufr
    bufr/gsd2_208.bufr
    bufr/gsd3_208.bufr
    bufr/gst4_26.bufr
    bufr/hirb_55.bufr
    bufr/hirs_55.bufr
    bufr/ias1_240.bufr
    bufr/iasi_241.bufr
    bufr/ifco_208.bufr
    bufr/ikco_217.bufr
    bufr/itrg_208.bufr
    bufr/itwt_233.bufr
    bufr/j2eo_216.bufr
    bufr/j2nb_216.bufr
    bufr/jaso_214.bufr
    bufr/kond_209.bufr
    bufr/maer_207.bufr
    bufr/meta_140.bufr
    bufr/mhen_55.bufr
    bufr/mhsa_55.bufr
    bufr/mhsb_55.bufr
    bufr/mhse_55.bufr
    bufr/mloz_206.bufr
    bufr/modi_87.bufr
    bufr/modw_87.bufr
    bufr/monw_87.bufr
    bufr/nomi_206.bufr
    bufr/nos1_208.bufr
    bufr/nos2_208.bufr
    bufr/nos3_208.bufr
    bufr/nos4_208.bufr
    bufr/nos5_208.bufr
    bufr/nos6_208.bufr
    bufr/nos7_208.bufr
    bufr/nos8_208.bufr
    bufr/ocea_131.bufr
    bufr/ocea_132.bufr
    bufr/ocea_133.bufr
    bufr/ocea_21.bufr
    bufr/pgps_110.bufr
    bufr/pilo_91.bufr
    bufr/rada_250.bufr
    bufr/rado_250.bufr
    bufr/s4kn_165.bufr
    bufr/sb19_206.bufr
    bufr/sbu8_206.bufr
    bufr/ship_11.bufr
    bufr/ship_12.bufr
    bufr/ship_13.bufr
    bufr/ship_14.bufr
    bufr/ship_19.bufr
    bufr/ship_9.bufr
    bufr/smin_49.bufr
    bufr/smis_49.bufr
    bufr/smiu_49.bufr
    bufr/smos_203.bufr
    bufr/sn4k_165.bufr
    bufr/soil_7.bufr
    bufr/ssbt_127.bufr
    bufr/stuk_7.bufr
    bufr/syno_1.bufr
    bufr/syno_2.bufr
    bufr/syno_3.bufr
    bufr/syno_4.bufr
    bufr/temp_101.bufr
    bufr/temp_102.bufr
    bufr/temp_106.bufr
    bufr/tmr7_129.bufr
    bufr/tros_31.bufr
    bufr/wavb_134.bufr
  "

[ -d "${DATA_DIR}/bufr" ]  || mkdir "${DATA_DIR}/bufr"
[ -d "${DATA_DIR}/tigge" ] || mkdir "${DATA_DIR}/tigge"

# Decide what tool to use to download data
DNLD_PROG=""
if command -v wget >/dev/null 2>&1; then
   DNLD_PROG="wget --tries=1 --timeout=3 -nv -q -O"
fi
if command -v curl >/dev/null 2>&1; then
   DNLD_PROG="curl --silent --show-error --fail --output"
fi
if test "x$DNLD_PROG" = "x"; then
   echo "Cannot find tool to transfer data from download server. Aborting." 1>&2
   exit 1
fi

download_URL="http://download.ecmwf.org"
cd ${DATA_DIR}
echo "Downloading data files for testing..."
for f in $files; do
    # If we haven't already got the file, download it
    if [ ! -f "$f" ]; then
        $DNLD_PROG $f ${download_URL}/test-data/grib_api/data/$f
        if [ $? -ne 0 ]; then
            echo "Failed to download file: $f"
            exit 1
        fi
        #chmod 444 $f
        if [ $VERBOSE -eq 1 ]; then
            echo "Downloaded $f ..."
        fi
    fi
done

# Add a file to indicate we've done the download
touch ${DOWNLOADED}
