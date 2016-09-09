# author: Thomas Ogilvie
# sample tcl script showing the use of GPSR and HLS (hierarchical location service)
Mac/802_11Ext set CWMin_            15
Mac/802_11Ext set CWMax_            1023
Mac/802_11Ext set SlotTime_         0.000009
Mac/802_11Ext set SIFS_             0.000016
Mac/802_11Ext set ShortRetryLimit_  7
Mac/802_11Ext set LongRetryLimit_   4
Mac/802_11Ext set HeaderDuration_   0.000020 
Mac/802_11Ext set SymbolDuration_   0.000004
Mac/802_11Ext set BasicModulationScheme_ 0
Mac/802_11Ext set use_802_11a_flag_ true
Mac/802_11Ext set RTSThreshold_     2000
Mac/802_11Ext set MAC_DBG           0


#Phy/WirelessPhy set RXThresh_       3.652e-10
#Phy/WirelessPhy set bandwidth_      20e6
#Phy/WirelessPhy set CPThresh_       10.0

Phy/WirelessPhyExt set CSThresh_           6.30957e-12
Phy/WirelessPhyExt set Pt_                 0.08
Phy/WirelessPhyExt set freq_               5.18e9
Phy/WirelessPhyExt set noise_floor_        2.51189e-13
Phy/WirelessPhyExt set L_                  1.0
Phy/WirelessPhyExt set PowerMonitorThresh_ 2.10319e-12
Phy/WirelessPhyExt set HeaderDuration_     0.000020
Phy/WirelessPhyExt set BasicModulationScheme_ 0
Phy/WirelessPhyExt set PreambleCaptureSwitch_ 1
Phy/WirelessPhyExt set DataCaptureSwitch_  0
Phy/WirelessPhyExt set SINR_PreambleCapture_ 2.5118
Phy/WirelessPhyExt set SINR_DataCapture_   100.0
Phy/WirelessPhyExt set trace_dist_         1e6
Phy/WirelessPhyExt set PHY_DBG_            0
Phy/WirelessPhyExt set CPThresh_           0 ;# not used at the moment
Phy/WirelessPhyExt set RXThresh_           0 ;# not used at the moment

## GPSR Options
Agent/GPSR set bdesync_                0.5 ;# beacon desync random component
Agent/GPSR set bexp_                   [expr 3*([Agent/GPSR set bint_]+[Agent/GPSR set bdesync_]*[Agent/GPSR set bint_])] ;# beacon timeout interval
Agent/GPSR set pint_                   1.5 ;# peri probe interval
Agent/GPSR set pdesync_                0.5 ;# peri probe desync random component
Agent/GPSR set lpexp_                  8.0 ;# peris unused timeout interval
Agent/GPSR set drop_debug_             1   ;#
Agent/GPSR set peri_proact_            1 	 ;# proactively generate peri probes
Agent/GPSR set use_implicit_beacon_    1   ;# all packets act as beacons; promisc.
Agent/GPSR set use_timed_plnrz_        0   ;# replanarize periodically
Agent/GPSR set use_congestion_control_ 0
Agent/GPSR set use_mobility_aware_     1
Agent/GPSR set use_reactive_beacon_    0   ;# only use reactive beaconing
Agent/GPSR set cc_alpha_ 5
set val(bint)           2  ;# beacon interval
set val(use_mac)        1    ;# use link breakage feedback from MAC
set val(use_peri)       1    ;# probe and use perimeters
set val(use_planar)     1    ;# planarize graph
set val(verbose)        1    ;#
set val(use_beacon)     1    ;# use beacons at all
set val(use_reactive)   0    ;# use reactive beaconing
set val(locs)           0    ;# default to OmniLS
set val(use_loop)       0    ;# look for unexpected loops in peris

set val(agg_mac)          1 ;# Aggregate MAC Traces
set val(agg_rtr)          0 ;# Aggregate RTR Traces
set val(agg_trc)          0 ;# Shorten Trace File


set val(chan)		Channel/WirelessChannel
set val(prop)		Propagation/TwoRayGround
set val(netif)		Phy/WirelessPhyExt	
set val(mac)		Mac/802_11Ext
set val(ifq)		Queue/DropTail/PriQueue
set val(ll)		LL
set val(ant)		Antenna/OmniAntenna
set val(x)		2000      ;# X dimension of the topography
set val(y)		2000      ;# Y dimension of the topography
set val(ifqlen)		512       ;# max packet in ifq
set val(seed)		1.0
set val(adhocRouting)	GPSR      ;# AdHoc Routing Protocol
set val(nn)		40       ;# how many nodes are simulated
set val(stop)		60.0     ;# simulation time
set val(use_gk)		0	  ;# > 0: use GridKeeper with this radius
set val(zip)		0         ;# should trace files be zipped

set val(agttrc)         ON ;# Trace Agent
set val(rtrtrc)         ON ;# Trace Routing Agent
set val(mactrc)         ON ;# Trace MAC Layer
set val(movtrc)         ON ;# Trace Movement


set val(lt)		""
set val(cp)		"cp-n40-a40-t40-c4-m0"
#set val(sc)		"sc-x1000-y1000-n5-s25-t40"
set val(sc)		"sc-para"

set val(out)            "hls_gpsrload.tr"

Agent/GPSR set locservice_type_ 3

add-all-packet-headers
remove-all-packet-headers
add-packet-header Common Flags IP LL Mac Message GPSR  LOCS SR RTP Ping HLS

Agent/GPSR set bint_                  $val(bint)
# Recalculating bexp_ here
Agent/GPSR set bexp_                 [expr 3*([Agent/GPSR set bint_]+[Agent/GPSR set bdesync_]*[Agent/GPSR set bint_])] ;# beacon timeout interval
Agent/GPSR set use_peri_              $val(use_peri)
Agent/GPSR set use_planar_            $val(use_planar)
Agent/GPSR set use_mac_               $val(use_mac)
Agent/GPSR set use_beacon_            $val(use_beacon)
Agent/GPSR set verbose_               $val(verbose)
Agent/GPSR set use_reactive_beacon_   $val(use_reactive)
Agent/GPSR set use_loop_detect_       $val(use_loop)

CMUTrace set aggregate_mac_           $val(agg_mac)
CMUTrace set aggregate_rtr_           $val(agg_rtr)

# seeding RNG
ns-random $val(seed)

# create simulator instance
set ns_		[new Simulator]

set loadTrace  $val(lt)



set topo	[new Topography]
$topo load_flatgrid $val(x) $val(y)

set tracefd	[open $val(out) w]
set nam [open gpsrload.nam w]

$ns_ trace-all $tracefd
$ns_ namtrace-all-wireless $nam 2000 2000
#set f0 [open packets_received.tr w]
#set f1 [open packets_lost.tr w]
#set f2 [open packets.tr w]
set chanl [new $val(chan)]

# Create God
set god_ [create-god $val(nn)]

# Attach Trace to God
set T [new Trace/Generic]
$T attach $tracefd
$T set src_ -5
$god_ tracetarget $T

#
# Define Nodes
#
puts "Configuring Nodes ($val(nn))"
$ns_ node-config -adhocRouting $val(adhocRouting) \
                 -llType $val(ll) \
                 -macType $val(mac) \
                 -ifqType $val(ifq) \
                 -ifqLen $val(ifqlen) \
                 -antType $val(ant) \
                 -propType $val(prop) \
                 -phyType $val(netif) \
                 -channel $chanl \
		 -topoInstance $topo \
                 -wiredRouting OFF \
		 -mobileIP OFF \
		 -agentTrace $val(agttrc) \
                 -routerTrace $val(rtrtrc) \
                 -macTrace $val(mactrc) \
                 -movementTrace $val(movtrc)

#
#  Create the specified number of nodes [$val(nn)] and "attach" them
#  to the channel. 
for {set i 0} {$i < $val(nn) } {incr i} {
    set node_($i) [$ns_ node]
    $node_($i) random-motion 0		;# disable random motion
	set ragent [$node_($i) set ragent_]
	$ragent install-tap [$node_($i) set mac_(0)]

    if { $val(mac) == "Mac/802_11" } {      
	# bind MAC load trace file
	[$node_($i) set mac_(0)] load-trace $loadTrace
    }

    # Bring Nodes to God's Attention
    $god_ new_node $node_($i)
}

source $val(sc)

#source $val(cp)


proc finish {} {
    global ns_ nam 
    $ns_ flush-trace
    
    close $nam
    #Call xgraph to display the results
    
	
  #  exec nam queue.nam &
#	exec awk -f Matgoi.awk hls_gpsrload.tr > Lostgpsrload.tr
#	exec xgraph packets.tr -t "Ty le mat goi 123" -geometry 800x400 -x "s" -y "%" &
#	exec xgraph packets_received.tr packets_lost.tr &
#	exec xgraph Lost.tr -t "Ty le mat goi " -geometry 800x400 -x "s" -y "%" &
    exit 0
}
#
# Tell nodes when the simulation ends
#
#for {set i 0} {$i < $val(nn) } {incr i} {
 #   $ns_ at 43 "$node_($i) reset";
#}
for {set i 0} {$i < $val(nn) } {incr i} {
set udp($i) [new Agent/UDP]
$ns_ attach-agent $node_($i) $udp($i)

}

set udp1 [new Agent/UDP]
$ns_ attach-agent $node_(0) $udp1
set sink2 [new Agent/LossMonitor]
$ns_ attach-agent $node_(33) $sink2
$ns_ connect $udp1 $sink2
#SET FLOWID = 2 CHO UDP (MAU DO)
$udp1 set fid_ 2

set udp0 [new Agent/UDP]
$ns_ attach-agent $node_(15) $udp0
set sink0 [new Agent/LossMonitor]
$ns_ attach-agent $node_(10) $sink0
$ns_ connect $udp0 $sink0
#SET FLOWID = 2 CHO UDP (MAU DO)
$udp1 set fid_ 2

set udp3 [new Agent/UDP]
$ns_ attach-agent $node_(8) $udp3
set sink3 [new Agent/LossMonitor]
$ns_ attach-agent $node_(19) $sink3
$ns_ connect $udp3 $sink3
#SET FLOWID = 2 CHO UDP (MAU DO)
$udp3 set fid_ 2


#Setup a CBR over UDP connection
set cbr [new Application/Traffic/CBR]
$cbr attach-agent $udp1
$cbr set type_ CBR
$cbr set packet_size_ 1024
#SET TOC DO GOI CBR = 1Mb KO THAY MAT GOI UDP O NODE 1 , 1.46 Mb DROP CA NODE 1 (TAI 12.49s) VA 2
#$cbr set rate_ 1.46Mb
$cbr set rate_ 0.4Mb
set cbr0 [new Application/Traffic/CBR]
$cbr0 attach-agent $udp0
$cbr0 set type_ CBR
$cbr0 set packet_size_ 1024
#SET TOC DO GOI CBR = 1Mb KO THAY MAT GOI UDP O NODE 1 , 1.46 Mb DROP CA NODE 1 (TAI 12.49s) VA 2
#$cbr set rate_ 1.46Mb
$cbr0 set rate_ 1.0Mb

#Setup a CBR over UDP connection
set cbr3 [new Application/Traffic/CBR]
$cbr3 attach-agent $udp3
$cbr3 set type_ CBR
$cbr3 set packet_size_ 1024
#SET TOC DO GOI CBR = 1Mb KO THAY MAT GOI UDP O NODE 1 , 1.46 Mb DROP CA NODE 1 (TAI 12.49s) VA 2
#$cbr set rate_ 1.46Mb
$cbr3 set rate_ 1.0 Mb

set udp2 [new Agent/UDP]
$ns_ attach-agent $node_(4) $udp2
set sink2 [new Agent/imageUdpSink]
$ns_ attach-agent $node_(37) $sink2
$sink2 set_filename gpsrloadanh2.7MB.JPG
$ns_ connect $udp2 $sink2
#SET FLOWID = 2 CHO UDP (MAU DO)
$udp2 set fid_ 2



#Setup a CBR over UDP connection
set cbr2 [new Application/Traffic/ImageApp]
$cbr2 attach-agent $udp2
$cbr2 get_file_name anh2.7MB.JPG
$cbr2 set type_ CBR
$cbr2 set packet_size_ 900
$cbr2 set rate_ 1.2Mb

#set cbr1 [attach-CBR-traffic $n(1) $sink2 1000 .015]
#set cbr2 [attach-CBR-traffic $n(2) $sink3 1000 .015]
#set cbr3 [attach-CBR-traffic $n(3) $sink0 1000 .015]
#set cbr4 [attach-CBR-traffic $n(4) $sink3 1000 .015]
#set cbr5 [attach-CBR-traffic $n(5) $sink0 1000 .015] 


#$ns at 0.5 "$cbr0 start"
#$ns at 0.5 "$cbr2 start"
#$ns at 2.0 "$cbr0 stop"
#$ns at 2.0 "$cbr2 stop"
#$ns at 1.0  "$cbr0 start"


$ns_ at 1.0  "$cbr start"
$ns_ at 2.0  "$cbr0 start"
$ns_ at 68 "$cbr0 stop"
$ns_ at 60 "$cbr stop"

$ns_ at 13.0  "$cbr3 start"
$ns_ at 60    "$cbr3 stop"

$ns_ at 20.0  "$cbr2 start"
$ns_ at 50.4  "$sink2 closefile"

$ns_ at $val(stop) "finish"
#$val(stop).0001
puts "Starting Simulation..."
$ns_ run
