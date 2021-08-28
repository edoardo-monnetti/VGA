set_param project.enableReportConfiguration 0
load_feature core
current_fileset
xsim {display_tb} -wdb {display_tb.wdb} -autoloadwcfg -tclbatch {/home/edoardo/Desktop/VGA_project/work/sim/../../scripts/sim/run.tcl} -onerror stop -stats
