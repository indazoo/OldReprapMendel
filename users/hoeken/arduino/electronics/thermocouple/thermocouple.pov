//POVRay-File created by 3d41.ulp v1.05
///home/hoeken/Desktop/reprap/trunk/users/hoeken/arduino/electronics/thermocouple/thermocouple.brd
// 1/08/2008 14:33:17 

#version 3.5;

//Set to on if the file should be used as .inc
#local use_file_as_inc = off;
#if(use_file_as_inc=off)


//changes the apperance of resistors (1 Blob / 0 real)
#declare global_res_shape = 1;
//randomize color of resistors 1=random 0=same color
#declare global_res_colselect = 0;
//Number of the color for the resistors
//0=Green, 1="normal color" 2=Blue 3=Brown
#declare global_res_col = 1;
//Set to on if you want to render the PCB upside-down
#declare pcb_upsidedown = off;
//Set to x or z to rotate around the corresponding axis (referring to pcb_upsidedown)
#declare pcb_rotdir = x;
//Set the length off short pins over the PCB
#declare pin_length = 2.5;
#declare global_diode_bend_radius = 1;
#declare global_res_bend_radius = 1;
#declare global_solder = on;

#declare global_show_screws = on;
#declare global_show_washers = on;
#declare global_show_nuts = on;

//Animation
#declare global_anim = off;
#local global_anim_showcampath = no;

#declare global_fast_mode = off;

#declare col_preset = 2;
#declare pin_short = on;

#declare environment = on;

#local cam_x = 0;
#local cam_y = 139;
#local cam_z = -28;
#local cam_a = 20;
#local cam_look_x = 0;
#local cam_look_y = -1;
#local cam_look_z = 0;

#local pcb_rotate_x = 0;
#local pcb_rotate_y = 0;
#local pcb_rotate_z = 0;

#local pcb_board = on;
#local pcb_parts = on;
#if(global_fast_mode=off)
	#local pcb_polygons = on;
	#local pcb_silkscreen = on;
	#local pcb_wires = on;
	#local pcb_pads_smds = on;
#else
	#local pcb_polygons = off;
	#local pcb_silkscreen = off;
	#local pcb_wires = off;
	#local pcb_pads_smds = off;
#end

#local lgt1_pos_x = 16;
#local lgt1_pos_y = 24;
#local lgt1_pos_z = 6;
#local lgt1_intense = 0.707768;
#local lgt2_pos_x = -16;
#local lgt2_pos_y = 24;
#local lgt2_pos_z = 6;
#local lgt2_intense = 0.707768;
#local lgt3_pos_x = 16;
#local lgt3_pos_y = 24;
#local lgt3_pos_z = -4;
#local lgt3_intense = 0.707768;
#local lgt4_pos_x = -16;
#local lgt4_pos_y = 24;
#local lgt4_pos_z = -4;
#local lgt4_intense = 0.707768;

//Do not change these values
#declare pcb_height = 1.500000;
#declare pcb_cuheight = 0.035000;
#declare pcb_x_size = 43.688000;
#declare pcb_y_size = 12.446000;
#declare pcb_layer1_used = 1;
#declare pcb_layer16_used = 1;
#declare inc_testmode = off;
#declare global_seed=seed(4);
#declare global_pcb_layer_dis = array[16]
{
	0.000000,
	0.000000,
	0.000000,
	0.000000,
	0.000000,
	0.000000,
	0.000000,
	0.000000,
	0.000000,
	0.000000,
	0.000000,
	0.000000,
	0.000000,
	0.000000,
	0.000000,
	1.535000,
}
#declare global_pcb_real_hole = 2.000000;

#include "tools.inc"
#include "user.inc"

global_settings{charset utf8}

#if(environment=on)
sky_sphere {pigment {Navy}
pigment {bozo turbulence 0.65 octaves 7 omega 0.7 lambda 2
color_map {
[0.0 0.1 color rgb <0.85, 0.85, 0.85> color rgb <0.75, 0.75, 0.75>]
[0.1 0.5 color rgb <0.75, 0.75, 0.75> color rgbt <1, 1, 1, 1>]
[0.5 1.0 color rgbt <1, 1, 1, 1> color rgbt <1, 1, 1, 1>]}
scale <0.1, 0.5, 0.1>} rotate -90*x}
plane{y, -10.0-max(pcb_x_size,pcb_y_size)*abs(max(sin((pcb_rotate_x/180)*pi),sin((pcb_rotate_z/180)*pi)))
texture{T_Chrome_2D
normal{waves 0.1 frequency 3000.0 scale 3000.0}} translate<0,0,0>}
#end

//Animation data
#if(global_anim=on)
#declare global_anim_showcampath = no;
#end

#if((global_anim=on)|(global_anim_showcampath=yes))
#declare global_anim_npoints_cam_flight=0;
#warning "No/not enough Animation Data available (min. 3 points) (Flight path)"
#end

#if((global_anim=on)|(global_anim_showcampath=yes))
#declare global_anim_npoints_cam_view=0;
#warning "No/not enough Animation Data available (min. 3 points) (View path)"
#end

#if((global_anim=on)|(global_anim_showcampath=yes))
#end

#if((global_anim_showcampath=yes)&(global_anim=off))
#end
#if(global_anim=on)
camera
{
	location global_anim_spline_cam_flight(clock)
	#if(global_anim_npoints_cam_view>2)
		look_at global_anim_spline_cam_view(clock)
	#else
		look_at global_anim_spline_cam_flight(clock+0.01)-<0,-0.01,0>
	#end
	angle 45
}
light_source
{
	global_anim_spline_cam_flight(clock)
	color rgb <1,1,1>
	spotlight point_at 
	#if(global_anim_npoints_cam_view>2)
		global_anim_spline_cam_view(clock)
	#else
		global_anim_spline_cam_flight(clock+0.01)-<0,-0.01,0>
	#end
	radius 35 falloff  40
}
#else
camera
{
	location <cam_x,cam_y,cam_z>
	look_at <cam_look_x,cam_look_y,cam_look_z>
	angle cam_a
	//translates the camera that <0,0,0> is over the Eagle <0,0>
	//translate<-21.844000,0,-6.223000>
}
#end

background{col_bgr}


//Axis uncomment to activate
//object{TOOLS_AXIS_XYZ(100,100,100 //texture{ pigment{rgb<1,0,0>} finish{diffuse 0.8 phong 1}}, //texture{ pigment{rgb<1,1,1>} finish{diffuse 0.8 phong 1}})}

light_source{<lgt1_pos_x,lgt1_pos_y,lgt1_pos_z> White*lgt1_intense}
light_source{<lgt2_pos_x,lgt2_pos_y,lgt2_pos_z> White*lgt2_intense}
light_source{<lgt3_pos_x,lgt3_pos_y,lgt3_pos_z> White*lgt3_intense}
light_source{<lgt4_pos_x,lgt4_pos_y,lgt4_pos_z> White*lgt4_intense}
#end


#macro THERMOCOUPLE(mac_x_ver,mac_y_ver,mac_z_ver,mac_x_rot,mac_y_rot,mac_z_rot)
union{
#if(pcb_board = on)
difference{
union{
//Board
prism{-1.500000,0.000000,8
<-0.508000,25.908000><43.180000,25.908000>
<43.180000,25.908000><43.180000,38.354000>
<43.180000,38.354000><-0.508000,38.354000>
<-0.508000,38.354000><-0.508000,25.908000>
texture{col_brd}}
}//End union(Platine)
//Holes(real)/Parts
//Holes(real)/Board
//Holes(real)/Vias
}//End difference(reale Bohrungen/Durchbrüche)
#end
#if(pcb_parts=on)//Parts
union{
#ifndef(pack_IC1) #declare global_pack_IC1=yes; object {IC_DIS_DIP14("","",)translate<0,0,0> rotate<0,0.000000,0>rotate<0,-0.000000,0> rotate<0,0,0> translate<18.330000,-0.000000,32.160000>translate<0,3.000000,0> }#end		//DIP14 IC1  DIL14
#ifndef(pack_IC1) object{SOCKET_DIP14()rotate<0,-0.000000,0> rotate<0,0,0> translate<18.330000,-0.000000,32.160000>}#end					//IC-Sockel 14Pin IC1 
#ifndef(pack_JP1) #declare global_pack_JP1=yes; object {PH_1X3()translate<0,0,0> rotate<0,0.000000,0>rotate<0,-270.000000,0> rotate<0,0,0> translate<37.352000,-0.000000,30.560000>}#end		//Header 2,54mm Grid 3Pin 1Row (jumper.lib) JP1  1X03
#ifndef(pack_LED1) #declare global_pack_LED1=yes; object {DIODE_DIS_LED_5MM(Red,0.500000,0.000000,)translate<0,0,0> rotate<0,0.000000,0>rotate<0,-270.000000,0> rotate<0,0,0> translate<31.970000,-0.000000,30.920000>}#end		//Diskrete 5MM LED LED1  LED5MM
#ifndef(pack_R1) #declare global_pack_R1=yes; object {RES_DIS_0207_075MM(texture{pigment{Red*0.7}finish{phong 0.2}},texture{pigment{Red*0.7}finish{phong 0.2}},texture{pigment{DarkBrown}finish{phong 0.2}},texture {T_Gold_5C finish{reflection 0.1}},)translate<0,0,0> rotate<0,0.000000,0>rotate<0,-0.000000,0> rotate<0,0,0> translate<32.572000,-0.000000,36.540000>}#end		//Discrete Resistor 0,3W 7,5MM Grid R1 220 0207/7
#ifndef(pack_X1) #declare global_pack_X1=yes; object {CON_PHOENIX_508_MSTBV_2()translate<0,0,0> rotate<0,0.000000,0>rotate<0,-270.000000,0> rotate<0,0,0> translate<3.798000,-0.000000,32.138000>}#end		//Connector PHOENIX type MSTBV vertical 2 pins X1 MST2V MSTBV2
}//End union
#end
#if(pcb_pads_smds=on)
//Pads&SMD/Parts
#ifndef(global_pack_IC1) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.320800,0.812800,1,16,3+global_tmp,100) rotate<0,-90.000000,0>translate<10.710000,0,28.350000> texture{col_thl}}
#ifndef(global_pack_IC1) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.320800,0.812800,1,16,3+global_tmp,100) rotate<0,-90.000000,0>translate<13.250000,0,28.350000> texture{col_thl}}
#ifndef(global_pack_IC1) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.320800,0.812800,1,16,3+global_tmp,100) rotate<0,-90.000000,0>translate<15.790000,0,28.350000> texture{col_thl}}
#ifndef(global_pack_IC1) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.320800,0.812800,1,16,3+global_tmp,100) rotate<0,-90.000000,0>translate<18.330000,0,28.350000> texture{col_thl}}
#ifndef(global_pack_IC1) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.320800,0.812800,1,16,3+global_tmp,100) rotate<0,-90.000000,0>translate<20.870000,0,28.350000> texture{col_thl}}
#ifndef(global_pack_IC1) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.320800,0.812800,1,16,3+global_tmp,100) rotate<0,-90.000000,0>translate<23.410000,0,28.350000> texture{col_thl}}
#ifndef(global_pack_IC1) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.320800,0.812800,1,16,3+global_tmp,100) rotate<0,-90.000000,0>translate<25.950000,0,28.350000> texture{col_thl}}
#ifndef(global_pack_IC1) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.320800,0.812800,1,16,3+global_tmp,100) rotate<0,-90.000000,0>translate<25.950000,0,35.970000> texture{col_thl}}
#ifndef(global_pack_IC1) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.320800,0.812800,1,16,3+global_tmp,100) rotate<0,-90.000000,0>translate<23.410000,0,35.970000> texture{col_thl}}
#ifndef(global_pack_IC1) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.320800,0.812800,1,16,3+global_tmp,100) rotate<0,-90.000000,0>translate<20.870000,0,35.970000> texture{col_thl}}
#ifndef(global_pack_IC1) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.320800,0.812800,1,16,3+global_tmp,100) rotate<0,-90.000000,0>translate<18.330000,0,35.970000> texture{col_thl}}
#ifndef(global_pack_IC1) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.320800,0.812800,1,16,3+global_tmp,100) rotate<0,-90.000000,0>translate<15.790000,0,35.970000> texture{col_thl}}
#ifndef(global_pack_IC1) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.320800,0.812800,1,16,3+global_tmp,100) rotate<0,-90.000000,0>translate<13.250000,0,35.970000> texture{col_thl}}
#ifndef(global_pack_IC1) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.320800,0.812800,1,16,3+global_tmp,100) rotate<0,-90.000000,0>translate<10.710000,0,35.970000> texture{col_thl}}
#ifndef(global_pack_JP1) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.524000,1.016000,1,16,3+global_tmp,100) rotate<0,-0.000000,0>translate<37.352000,0,33.100000> texture{col_thl}}
#ifndef(global_pack_JP1) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.524000,1.016000,1,16,3+global_tmp,100) rotate<0,-0.000000,0>translate<37.352000,0,30.560000> texture{col_thl}}
#ifndef(global_pack_JP1) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.524000,1.016000,1,16,3+global_tmp,100) rotate<0,-0.000000,0>translate<37.352000,0,28.020000> texture{col_thl}}
#ifndef(global_pack_LED1) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.320800,0.812800,1,16,2+global_tmp,0) rotate<0,-270.000000,0>translate<31.970000,0,32.190000> texture{col_thl}}
#ifndef(global_pack_LED1) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.320800,0.812800,1,16,2+global_tmp,0) rotate<0,-270.000000,0>translate<31.970000,0,29.650000> texture{col_thl}}
#ifndef(global_pack_R1) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.320800,0.812800,1,16,2+global_tmp,0) rotate<0,-0.000000,0>translate<28.762000,0,36.540000> texture{col_thl}}
#ifndef(global_pack_R1) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.320800,0.812800,1,16,2+global_tmp,0) rotate<0,-0.000000,0>translate<36.382000,0,36.540000> texture{col_thl}}
#ifndef(global_pack_X1) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(2.095600,1.397000,1,16,3+global_tmp,100) rotate<0,-0.000000,0>translate<3.798000,0,34.678000> texture{col_thl}}
#ifndef(global_pack_X1) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(2.095600,1.397000,1,16,3+global_tmp,100) rotate<0,-0.000000,0>translate<3.798000,0,29.598000> texture{col_thl}}
//Pads/Vias
object{TOOLS_PCB_VIA(1.016000,0.609600,1,16,1,0) translate<27.178000,0,32.639000> texture{col_thl}}
#end
#if(pcb_wires=on)
union{
//Signals
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<3.798000,-0.000000,34.678000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<5.842000,-0.000000,35.052000>}
box{<0,0,-0.127000><2.077935,0.035000,0.127000> rotate<0,-10.368284,0> translate<3.798000,-0.000000,34.678000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<5.842000,-0.000000,35.052000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<10.160000,-0.000000,35.052000>}
box{<0,0,-0.127000><4.318000,0.035000,0.127000> rotate<0,0.000000,0> translate<5.842000,-0.000000,35.052000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<10.160000,-0.000000,35.052000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<10.710000,-0.000000,35.970000>}
box{<0,0,-0.127000><1.070151,0.035000,0.127000> rotate<0,-59.069073,0> translate<10.160000,-0.000000,35.052000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<15.790000,-0.000000,35.970000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<16.383000,-0.000000,35.052000>}
box{<0,0,-0.127000><1.092874,0.035000,0.127000> rotate<0,57.135002,0> translate<15.790000,-0.000000,35.970000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<16.383000,-0.000000,35.052000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<17.018000,-0.000000,35.052000>}
box{<0,0,-0.127000><0.635000,0.035000,0.127000> rotate<0,0.000000,0> translate<16.383000,-0.000000,35.052000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<18.330000,-0.000000,35.970000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<18.923000,-0.000000,35.052000>}
box{<0,0,-0.127000><1.092874,0.035000,0.127000> rotate<0,57.135002,0> translate<18.330000,-0.000000,35.970000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<18.923000,-0.000000,35.052000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<19.558000,-0.000000,35.052000>}
box{<0,0,-0.127000><0.635000,0.035000,0.127000> rotate<0,0.000000,0> translate<18.923000,-0.000000,35.052000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<19.558000,-0.000000,35.052000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<21.082000,-0.000000,33.528000>}
box{<0,0,-0.127000><2.155261,0.035000,0.127000> rotate<0,44.997030,0> translate<19.558000,-0.000000,35.052000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<17.018000,-0.000000,35.052000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<21.971000,-0.000000,30.099000>}
box{<0,0,-0.127000><7.004600,0.035000,0.127000> rotate<0,44.997030,0> translate<17.018000,-0.000000,35.052000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<23.410000,-0.000000,35.970000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<24.003000,-0.000000,36.068000>}
box{<0,0,-0.127000><0.601043,0.035000,0.127000> rotate<0,-9.383344,0> translate<23.410000,-0.000000,35.970000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<24.003000,-0.000000,36.068000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<25.400000,-0.000000,36.068000>}
box{<0,0,-0.127000><1.397000,0.035000,0.127000> rotate<0,0.000000,0> translate<24.003000,-0.000000,36.068000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<25.400000,-0.000000,36.068000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<25.950000,-0.000000,35.970000>}
box{<0,0,-0.127000><0.558663,0.035000,0.127000> rotate<0,10.102370,0> translate<25.400000,-0.000000,36.068000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<25.950000,-1.535000,35.970000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<26.162000,-1.535000,34.671000>}
box{<0,0,-0.127000><1.316186,0.035000,0.127000> rotate<0,80.725577,0> translate<25.950000,-1.535000,35.970000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<26.162000,-1.535000,33.655000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<26.162000,-1.535000,34.671000>}
box{<0,0,-0.127000><1.016000,0.035000,0.127000> rotate<0,90.000000,0> translate<26.162000,-1.535000,34.671000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<26.162000,-1.535000,33.655000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<27.178000,-1.535000,32.639000>}
box{<0,0,-0.127000><1.436841,0.035000,0.127000> rotate<0,44.997030,0> translate<26.162000,-1.535000,33.655000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<27.178000,-0.000000,32.639000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<28.829000,-0.000000,30.988000>}
box{<0,0,-0.127000><2.334867,0.035000,0.127000> rotate<0,44.997030,0> translate<27.178000,-0.000000,32.639000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<28.762000,-1.535000,36.540000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<29.083000,-1.535000,35.941000>}
box{<0,0,-0.127000><0.679590,0.035000,0.127000> rotate<0,61.809368,0> translate<28.762000,-1.535000,36.540000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<29.083000,-1.535000,33.782000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<29.083000,-1.535000,35.941000>}
box{<0,0,-0.127000><2.159000,0.035000,0.127000> rotate<0,90.000000,0> translate<29.083000,-1.535000,35.941000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<29.083000,-1.535000,33.782000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<30.353000,-1.535000,32.512000>}
box{<0,0,-0.127000><1.796051,0.035000,0.127000> rotate<0,44.997030,0> translate<29.083000,-1.535000,33.782000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<30.353000,-1.535000,32.512000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<31.369000,-1.535000,32.512000>}
box{<0,0,-0.127000><1.016000,0.035000,0.127000> rotate<0,0.000000,0> translate<30.353000,-1.535000,32.512000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<21.971000,-0.000000,30.099000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<31.496000,-0.000000,30.099000>}
box{<0,0,-0.127000><9.525000,0.035000,0.127000> rotate<0,0.000000,0> translate<21.971000,-0.000000,30.099000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<31.496000,-0.000000,30.099000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<31.970000,-0.000000,29.650000>}
box{<0,0,-0.127000><0.652899,0.035000,0.127000> rotate<0,43.445622,0> translate<31.496000,-0.000000,30.099000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<31.369000,-1.535000,32.512000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<31.970000,-1.535000,32.190000>}
box{<0,0,-0.127000><0.681825,0.035000,0.127000> rotate<0,28.179376,0> translate<31.369000,-1.535000,32.512000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<28.829000,-0.000000,30.988000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<35.941000,-0.000000,30.988000>}
box{<0,0,-0.127000><7.112000,0.035000,0.127000> rotate<0,0.000000,0> translate<28.829000,-0.000000,30.988000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<21.082000,-0.000000,33.528000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<35.941000,-0.000000,33.528000>}
box{<0,0,-0.127000><14.859000,0.035000,0.127000> rotate<0,0.000000,0> translate<21.082000,-0.000000,33.528000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<36.382000,-0.000000,36.540000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<36.449000,-0.000000,35.941000>}
box{<0,0,-0.127000><0.602735,0.035000,0.127000> rotate<0,83.612300,0> translate<36.382000,-0.000000,36.540000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<36.449000,-0.000000,33.782000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<36.449000,-0.000000,35.941000>}
box{<0,0,-0.127000><2.159000,0.035000,0.127000> rotate<0,90.000000,0> translate<36.449000,-0.000000,35.941000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<35.941000,-0.000000,30.988000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<37.352000,-0.000000,30.560000>}
box{<0,0,-0.127000><1.474485,0.035000,0.127000> rotate<0,16.873062,0> translate<35.941000,-0.000000,30.988000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<35.941000,-0.000000,33.528000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<37.352000,-0.000000,33.100000>}
box{<0,0,-0.127000><1.474485,0.035000,0.127000> rotate<0,16.873062,0> translate<35.941000,-0.000000,33.528000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<36.449000,-0.000000,33.782000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<37.352000,-0.000000,33.100000>}
box{<0,0,-0.127000><1.131606,0.035000,0.127000> rotate<0,37.059855,0> translate<36.449000,-0.000000,33.782000> }
//Text
//Rect
union{
texture{col_pds}
}
texture{col_wrs}
}
#end
#if(pcb_polygons=on)
union{
//Polygons
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<-1.778000,-1.535000,24.130000>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<-1.778000,-1.535000,39.624000>}
box{<0,0,-0.203200><15.494000,0.035000,0.203200> rotate<0,90.000000,0> translate<-1.778000,-1.535000,39.624000> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<-1.778000,-1.535000,24.130000>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<44.450000,-1.535000,24.130000>}
box{<0,0,-0.203200><46.228000,0.035000,0.203200> rotate<0,0.000000,0> translate<-1.778000,-1.535000,24.130000> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<-1.778000,-1.535000,39.624000>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<44.450000,-1.535000,39.624000>}
box{<0,0,-0.203200><46.228000,0.035000,0.203200> rotate<0,0.000000,0> translate<-1.778000,-1.535000,39.624000> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<44.450000,-1.535000,39.624000>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<44.450000,-1.535000,24.130000>}
box{<0,0,-0.203200><15.494000,0.035000,0.203200> rotate<0,-90.000000,0> translate<44.450000,-1.535000,24.130000> }
texture{col_pol}
}
#end
union{
cylinder{<10.710000,0.038000,28.350000><10.710000,-1.538000,28.350000>0.406400}
cylinder{<13.250000,0.038000,28.350000><13.250000,-1.538000,28.350000>0.406400}
cylinder{<15.790000,0.038000,28.350000><15.790000,-1.538000,28.350000>0.406400}
cylinder{<18.330000,0.038000,28.350000><18.330000,-1.538000,28.350000>0.406400}
cylinder{<20.870000,0.038000,28.350000><20.870000,-1.538000,28.350000>0.406400}
cylinder{<23.410000,0.038000,28.350000><23.410000,-1.538000,28.350000>0.406400}
cylinder{<25.950000,0.038000,28.350000><25.950000,-1.538000,28.350000>0.406400}
cylinder{<25.950000,0.038000,35.970000><25.950000,-1.538000,35.970000>0.406400}
cylinder{<23.410000,0.038000,35.970000><23.410000,-1.538000,35.970000>0.406400}
cylinder{<20.870000,0.038000,35.970000><20.870000,-1.538000,35.970000>0.406400}
cylinder{<18.330000,0.038000,35.970000><18.330000,-1.538000,35.970000>0.406400}
cylinder{<15.790000,0.038000,35.970000><15.790000,-1.538000,35.970000>0.406400}
cylinder{<13.250000,0.038000,35.970000><13.250000,-1.538000,35.970000>0.406400}
cylinder{<10.710000,0.038000,35.970000><10.710000,-1.538000,35.970000>0.406400}
cylinder{<37.352000,0.038000,33.100000><37.352000,-1.538000,33.100000>0.508000}
cylinder{<37.352000,0.038000,30.560000><37.352000,-1.538000,30.560000>0.508000}
cylinder{<37.352000,0.038000,28.020000><37.352000,-1.538000,28.020000>0.508000}
cylinder{<31.970000,0.038000,32.190000><31.970000,-1.538000,32.190000>0.406400}
cylinder{<31.970000,0.038000,29.650000><31.970000,-1.538000,29.650000>0.406400}
cylinder{<28.762000,0.038000,36.540000><28.762000,-1.538000,36.540000>0.406400}
cylinder{<36.382000,0.038000,36.540000><36.382000,-1.538000,36.540000>0.406400}
cylinder{<3.798000,0.038000,34.678000><3.798000,-1.538000,34.678000>0.698500}
cylinder{<3.798000,0.038000,29.598000><3.798000,-1.538000,29.598000>0.698500}
//Holes(fast)/Vias
cylinder{<27.178000,0.038000,32.639000><27.178000,-1.538000,32.639000>0.304800 }
//Holes(fast)/Board
texture{col_hls}
}
#if(pcb_silkscreen=on)
//Silk Screen
union{
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<28.752800,0.000000,26.466800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<28.752800,0.000000,27.348000>}
box{<0,0,-0.050800><0.881200,0.036000,0.050800> rotate<0,90.000000,0> translate<28.752800,0.000000,27.348000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<28.752800,0.000000,27.348000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<29.193400,0.000000,27.788700>}
box{<0,0,-0.050800><0.623173,0.036000,0.050800> rotate<0,-45.003531,0> translate<28.752800,0.000000,27.348000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<29.193400,0.000000,27.788700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<29.634000,0.000000,27.348000>}
box{<0,0,-0.050800><0.623173,0.036000,0.050800> rotate<0,45.003531,0> translate<29.193400,0.000000,27.788700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<29.634000,0.000000,27.348000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<29.634000,0.000000,26.466800>}
box{<0,0,-0.050800><0.881200,0.036000,0.050800> rotate<0,-90.000000,0> translate<29.634000,0.000000,26.466800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<28.752800,0.000000,27.127700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<29.634000,0.000000,27.127700>}
box{<0,0,-0.050800><0.881200,0.036000,0.050800> rotate<0,0.000000,0> translate<28.752800,0.000000,27.127700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<30.062500,0.000000,27.788700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<30.062500,0.000000,26.466800>}
box{<0,0,-0.050800><1.321900,0.036000,0.050800> rotate<0,-90.000000,0> translate<30.062500,0.000000,26.466800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<30.062500,0.000000,26.466800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<30.943700,0.000000,26.466800>}
box{<0,0,-0.050800><0.881200,0.036000,0.050800> rotate<0,0.000000,0> translate<30.062500,0.000000,26.466800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<31.372200,0.000000,26.466800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<31.372200,0.000000,27.348000>}
box{<0,0,-0.050800><0.881200,0.036000,0.050800> rotate<0,90.000000,0> translate<31.372200,0.000000,27.348000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<31.372200,0.000000,27.348000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<31.812800,0.000000,27.788700>}
box{<0,0,-0.050800><0.623173,0.036000,0.050800> rotate<0,-45.003531,0> translate<31.372200,0.000000,27.348000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<31.812800,0.000000,27.788700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<32.253400,0.000000,27.348000>}
box{<0,0,-0.050800><0.623173,0.036000,0.050800> rotate<0,45.003531,0> translate<31.812800,0.000000,27.788700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<32.253400,0.000000,27.348000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<32.253400,0.000000,26.466800>}
box{<0,0,-0.050800><0.881200,0.036000,0.050800> rotate<0,-90.000000,0> translate<32.253400,0.000000,26.466800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<31.372200,0.000000,27.127700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<32.253400,0.000000,27.127700>}
box{<0,0,-0.050800><0.881200,0.036000,0.050800> rotate<0,0.000000,0> translate<31.372200,0.000000,27.127700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<32.681900,0.000000,26.466800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<32.681900,0.000000,27.788700>}
box{<0,0,-0.050800><1.321900,0.036000,0.050800> rotate<0,90.000000,0> translate<32.681900,0.000000,27.788700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<32.681900,0.000000,27.788700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<33.342800,0.000000,27.788700>}
box{<0,0,-0.050800><0.660900,0.036000,0.050800> rotate<0,0.000000,0> translate<32.681900,0.000000,27.788700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<33.342800,0.000000,27.788700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<33.563100,0.000000,27.568400>}
box{<0,0,-0.050800><0.311551,0.036000,0.050800> rotate<0,44.997030,0> translate<33.342800,0.000000,27.788700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<33.563100,0.000000,27.568400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<33.563100,0.000000,27.127700>}
box{<0,0,-0.050800><0.440700,0.036000,0.050800> rotate<0,-90.000000,0> translate<33.563100,0.000000,27.127700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<33.563100,0.000000,27.127700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<33.342800,0.000000,26.907400>}
box{<0,0,-0.050800><0.311551,0.036000,0.050800> rotate<0,-44.997030,0> translate<33.342800,0.000000,26.907400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<33.342800,0.000000,26.907400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<32.681900,0.000000,26.907400>}
box{<0,0,-0.050800><0.660900,0.036000,0.050800> rotate<0,0.000000,0> translate<32.681900,0.000000,26.907400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<33.122500,0.000000,26.907400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<33.563100,0.000000,26.466800>}
box{<0,0,-0.050800><0.623102,0.036000,0.050800> rotate<0,44.997030,0> translate<33.122500,0.000000,26.907400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<33.991600,0.000000,26.466800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<33.991600,0.000000,27.788700>}
box{<0,0,-0.050800><1.321900,0.036000,0.050800> rotate<0,90.000000,0> translate<33.991600,0.000000,27.788700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<33.991600,0.000000,27.788700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<34.432200,0.000000,27.348000>}
box{<0,0,-0.050800><0.623173,0.036000,0.050800> rotate<0,45.003531,0> translate<33.991600,0.000000,27.788700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<34.432200,0.000000,27.348000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<34.872800,0.000000,27.788700>}
box{<0,0,-0.050800><0.623173,0.036000,0.050800> rotate<0,-45.003531,0> translate<34.432200,0.000000,27.348000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<34.872800,0.000000,27.788700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<34.872800,0.000000,26.466800>}
box{<0,0,-0.050800><1.321900,0.036000,0.050800> rotate<0,-90.000000,0> translate<34.872800,0.000000,26.466800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<40.200300,0.000000,28.203200>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<40.005400,0.000000,28.398100>}
box{<0,0,-0.050800><0.275630,0.036000,0.050800> rotate<0,44.997030,0> translate<40.005400,0.000000,28.398100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<40.005400,0.000000,28.398100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<39.615600,0.000000,28.398100>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,0.000000,0> translate<39.615600,0.000000,28.398100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<39.615600,0.000000,28.398100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<39.420800,0.000000,28.203200>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,-45.011732,0> translate<39.420800,0.000000,28.203200> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<39.420800,0.000000,28.203200>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<39.420800,0.000000,27.423600>}
box{<0,0,-0.050800><0.779600,0.036000,0.050800> rotate<0,-90.000000,0> translate<39.420800,0.000000,27.423600> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<39.420800,0.000000,27.423600>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<39.615600,0.000000,27.228800>}
box{<0,0,-0.050800><0.275489,0.036000,0.050800> rotate<0,44.997030,0> translate<39.420800,0.000000,27.423600> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<39.615600,0.000000,27.228800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<40.005400,0.000000,27.228800>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,0.000000,0> translate<39.615600,0.000000,27.228800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<40.005400,0.000000,27.228800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<40.200300,0.000000,27.423600>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,-44.982329,0> translate<40.005400,0.000000,27.228800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<40.200300,0.000000,27.423600>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<40.200300,0.000000,27.813400>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,90.000000,0> translate<40.200300,0.000000,27.813400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<40.200300,0.000000,27.813400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<39.810500,0.000000,27.813400>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,0.000000,0> translate<39.810500,0.000000,27.813400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<40.590100,0.000000,27.228800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<40.590100,0.000000,28.398100>}
box{<0,0,-0.050800><1.169300,0.036000,0.050800> rotate<0,90.000000,0> translate<40.590100,0.000000,28.398100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<40.590100,0.000000,28.398100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<41.369600,0.000000,27.228800>}
box{<0,0,-0.050800><1.405305,0.036000,0.050800> rotate<0,56.307347,0> translate<40.590100,0.000000,28.398100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<41.369600,0.000000,27.228800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<41.369600,0.000000,28.398100>}
box{<0,0,-0.050800><1.169300,0.036000,0.050800> rotate<0,90.000000,0> translate<41.369600,0.000000,28.398100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<41.759400,0.000000,28.398100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<41.759400,0.000000,27.228800>}
box{<0,0,-0.050800><1.169300,0.036000,0.050800> rotate<0,-90.000000,0> translate<41.759400,0.000000,27.228800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<41.759400,0.000000,27.228800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<42.344000,0.000000,27.228800>}
box{<0,0,-0.050800><0.584600,0.036000,0.050800> rotate<0,0.000000,0> translate<41.759400,0.000000,27.228800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<42.344000,0.000000,27.228800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<42.538900,0.000000,27.423600>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,-44.982329,0> translate<42.344000,0.000000,27.228800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<42.538900,0.000000,27.423600>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<42.538900,0.000000,28.203200>}
box{<0,0,-0.050800><0.779600,0.036000,0.050800> rotate<0,90.000000,0> translate<42.538900,0.000000,28.203200> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<42.538900,0.000000,28.203200>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<42.344000,0.000000,28.398100>}
box{<0,0,-0.050800><0.275630,0.036000,0.050800> rotate<0,44.997030,0> translate<42.344000,0.000000,28.398100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<42.344000,0.000000,28.398100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<41.759400,0.000000,28.398100>}
box{<0,0,-0.050800><0.584600,0.036000,0.050800> rotate<0,0.000000,0> translate<41.759400,0.000000,28.398100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<40.454300,0.000000,30.997200>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<40.259400,0.000000,31.192100>}
box{<0,0,-0.050800><0.275630,0.036000,0.050800> rotate<0,44.997030,0> translate<40.259400,0.000000,31.192100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<40.259400,0.000000,31.192100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<39.869600,0.000000,31.192100>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,0.000000,0> translate<39.869600,0.000000,31.192100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<39.869600,0.000000,31.192100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<39.674800,0.000000,30.997200>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,-45.011732,0> translate<39.674800,0.000000,30.997200> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<39.674800,0.000000,30.997200>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<39.674800,0.000000,30.802300>}
box{<0,0,-0.050800><0.194900,0.036000,0.050800> rotate<0,-90.000000,0> translate<39.674800,0.000000,30.802300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<39.674800,0.000000,30.802300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<39.869600,0.000000,30.607400>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,45.011732,0> translate<39.674800,0.000000,30.802300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<39.869600,0.000000,30.607400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<40.259400,0.000000,30.607400>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,0.000000,0> translate<39.869600,0.000000,30.607400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<40.259400,0.000000,30.607400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<40.454300,0.000000,30.412500>}
box{<0,0,-0.050800><0.275630,0.036000,0.050800> rotate<0,44.997030,0> translate<40.259400,0.000000,30.607400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<40.454300,0.000000,30.412500>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<40.454300,0.000000,30.217600>}
box{<0,0,-0.050800><0.194900,0.036000,0.050800> rotate<0,-90.000000,0> translate<40.454300,0.000000,30.217600> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<40.454300,0.000000,30.217600>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<40.259400,0.000000,30.022800>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,-44.982329,0> translate<40.259400,0.000000,30.022800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<40.259400,0.000000,30.022800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<39.869600,0.000000,30.022800>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,0.000000,0> translate<39.869600,0.000000,30.022800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<39.869600,0.000000,30.022800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<39.674800,0.000000,30.217600>}
box{<0,0,-0.050800><0.275489,0.036000,0.050800> rotate<0,44.997030,0> translate<39.674800,0.000000,30.217600> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<40.844100,0.000000,30.022800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<41.233800,0.000000,30.022800>}
box{<0,0,-0.050800><0.389700,0.036000,0.050800> rotate<0,0.000000,0> translate<40.844100,0.000000,30.022800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<41.038900,0.000000,30.022800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<41.038900,0.000000,31.192100>}
box{<0,0,-0.050800><1.169300,0.036000,0.050800> rotate<0,90.000000,0> translate<41.038900,0.000000,31.192100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<40.844100,0.000000,31.192100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<41.233800,0.000000,31.192100>}
box{<0,0,-0.050800><0.389700,0.036000,0.050800> rotate<0,0.000000,0> translate<40.844100,0.000000,31.192100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<42.403100,0.000000,30.997200>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<42.208200,0.000000,31.192100>}
box{<0,0,-0.050800><0.275630,0.036000,0.050800> rotate<0,44.997030,0> translate<42.208200,0.000000,31.192100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<42.208200,0.000000,31.192100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<41.818400,0.000000,31.192100>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,0.000000,0> translate<41.818400,0.000000,31.192100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<41.818400,0.000000,31.192100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<41.623600,0.000000,30.997200>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,-45.011732,0> translate<41.623600,0.000000,30.997200> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<41.623600,0.000000,30.997200>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<41.623600,0.000000,30.217600>}
box{<0,0,-0.050800><0.779600,0.036000,0.050800> rotate<0,-90.000000,0> translate<41.623600,0.000000,30.217600> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<41.623600,0.000000,30.217600>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<41.818400,0.000000,30.022800>}
box{<0,0,-0.050800><0.275489,0.036000,0.050800> rotate<0,44.997030,0> translate<41.623600,0.000000,30.217600> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<41.818400,0.000000,30.022800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<42.208200,0.000000,30.022800>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,0.000000,0> translate<41.818400,0.000000,30.022800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<42.208200,0.000000,30.022800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<42.403100,0.000000,30.217600>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,-44.982329,0> translate<42.208200,0.000000,30.022800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<42.403100,0.000000,30.217600>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<42.403100,0.000000,30.607400>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,90.000000,0> translate<42.403100,0.000000,30.607400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<42.403100,0.000000,30.607400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<42.013300,0.000000,30.607400>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,0.000000,0> translate<42.013300,0.000000,30.607400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<39.420800,0.000000,32.893400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<40.200300,0.000000,32.893400>}
box{<0,0,-0.050800><0.779500,0.036000,0.050800> rotate<0,0.000000,0> translate<39.420800,0.000000,32.893400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<39.810500,0.000000,33.283200>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<39.810500,0.000000,32.503600>}
box{<0,0,-0.050800><0.779600,0.036000,0.050800> rotate<0,-90.000000,0> translate<39.810500,0.000000,32.503600> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<41.369600,0.000000,33.478100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<40.590100,0.000000,33.478100>}
box{<0,0,-0.050800><0.779500,0.036000,0.050800> rotate<0,0.000000,0> translate<40.590100,0.000000,33.478100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<40.590100,0.000000,33.478100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<40.590100,0.000000,32.893400>}
box{<0,0,-0.050800><0.584700,0.036000,0.050800> rotate<0,-90.000000,0> translate<40.590100,0.000000,32.893400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<40.590100,0.000000,32.893400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<40.979800,0.000000,33.088300>}
box{<0,0,-0.050800><0.435720,0.036000,0.050800> rotate<0,-26.569178,0> translate<40.590100,0.000000,32.893400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<40.979800,0.000000,33.088300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<41.174700,0.000000,33.088300>}
box{<0,0,-0.050800><0.194900,0.036000,0.050800> rotate<0,0.000000,0> translate<40.979800,0.000000,33.088300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<41.174700,0.000000,33.088300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<41.369600,0.000000,32.893400>}
box{<0,0,-0.050800><0.275630,0.036000,0.050800> rotate<0,44.997030,0> translate<41.174700,0.000000,33.088300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<41.369600,0.000000,32.893400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<41.369600,0.000000,32.503600>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,-90.000000,0> translate<41.369600,0.000000,32.503600> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<41.369600,0.000000,32.503600>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<41.174700,0.000000,32.308800>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,-44.982329,0> translate<41.174700,0.000000,32.308800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<41.174700,0.000000,32.308800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<40.784900,0.000000,32.308800>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,0.000000,0> translate<40.784900,0.000000,32.308800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<40.784900,0.000000,32.308800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<40.590100,0.000000,32.503600>}
box{<0,0,-0.050800><0.275489,0.036000,0.050800> rotate<0,44.997030,0> translate<40.590100,0.000000,32.503600> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<41.759400,0.000000,33.478100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<41.759400,0.000000,32.698500>}
box{<0,0,-0.050800><0.779600,0.036000,0.050800> rotate<0,-90.000000,0> translate<41.759400,0.000000,32.698500> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<41.759400,0.000000,32.698500>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<42.149100,0.000000,32.308800>}
box{<0,0,-0.050800><0.551119,0.036000,0.050800> rotate<0,44.997030,0> translate<41.759400,0.000000,32.698500> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<42.149100,0.000000,32.308800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<42.538900,0.000000,32.698500>}
box{<0,0,-0.050800><0.551190,0.036000,0.050800> rotate<0,-44.989680,0> translate<42.149100,0.000000,32.308800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<42.538900,0.000000,32.698500>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<42.538900,0.000000,33.478100>}
box{<0,0,-0.050800><0.779600,0.036000,0.050800> rotate<0,90.000000,0> translate<42.538900,0.000000,33.478100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<18.592800,0.000000,31.800800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<18.592800,0.000000,32.580300>}
box{<0,0,-0.050800><0.779500,0.036000,0.050800> rotate<0,90.000000,0> translate<18.592800,0.000000,32.580300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<18.592800,0.000000,32.580300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<18.982500,0.000000,32.970100>}
box{<0,0,-0.050800><0.551190,0.036000,0.050800> rotate<0,-45.004380,0> translate<18.592800,0.000000,32.580300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<18.982500,0.000000,32.970100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<19.372300,0.000000,32.580300>}
box{<0,0,-0.050800><0.551260,0.036000,0.050800> rotate<0,44.997030,0> translate<18.982500,0.000000,32.970100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<19.372300,0.000000,32.580300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<19.372300,0.000000,31.800800>}
box{<0,0,-0.050800><0.779500,0.036000,0.050800> rotate<0,-90.000000,0> translate<19.372300,0.000000,31.800800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<18.592800,0.000000,32.385400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<19.372300,0.000000,32.385400>}
box{<0,0,-0.050800><0.779500,0.036000,0.050800> rotate<0,0.000000,0> translate<18.592800,0.000000,32.385400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<19.762100,0.000000,32.970100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<19.762100,0.000000,31.800800>}
box{<0,0,-0.050800><1.169300,0.036000,0.050800> rotate<0,-90.000000,0> translate<19.762100,0.000000,31.800800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<19.762100,0.000000,31.800800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<20.346700,0.000000,31.800800>}
box{<0,0,-0.050800><0.584600,0.036000,0.050800> rotate<0,0.000000,0> translate<19.762100,0.000000,31.800800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<20.346700,0.000000,31.800800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<20.541600,0.000000,31.995600>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,-44.982329,0> translate<20.346700,0.000000,31.800800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<20.541600,0.000000,31.995600>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<20.541600,0.000000,32.775200>}
box{<0,0,-0.050800><0.779600,0.036000,0.050800> rotate<0,90.000000,0> translate<20.541600,0.000000,32.775200> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<20.541600,0.000000,32.775200>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<20.346700,0.000000,32.970100>}
box{<0,0,-0.050800><0.275630,0.036000,0.050800> rotate<0,44.997030,0> translate<20.346700,0.000000,32.970100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<20.346700,0.000000,32.970100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<19.762100,0.000000,32.970100>}
box{<0,0,-0.050800><0.584600,0.036000,0.050800> rotate<0,0.000000,0> translate<19.762100,0.000000,32.970100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<21.710900,0.000000,32.970100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<20.931400,0.000000,32.970100>}
box{<0,0,-0.050800><0.779500,0.036000,0.050800> rotate<0,0.000000,0> translate<20.931400,0.000000,32.970100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<20.931400,0.000000,32.970100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<20.931400,0.000000,32.385400>}
box{<0,0,-0.050800><0.584700,0.036000,0.050800> rotate<0,-90.000000,0> translate<20.931400,0.000000,32.385400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<20.931400,0.000000,32.385400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<21.321100,0.000000,32.580300>}
box{<0,0,-0.050800><0.435720,0.036000,0.050800> rotate<0,-26.569178,0> translate<20.931400,0.000000,32.385400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<21.321100,0.000000,32.580300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<21.516000,0.000000,32.580300>}
box{<0,0,-0.050800><0.194900,0.036000,0.050800> rotate<0,0.000000,0> translate<21.321100,0.000000,32.580300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<21.516000,0.000000,32.580300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<21.710900,0.000000,32.385400>}
box{<0,0,-0.050800><0.275630,0.036000,0.050800> rotate<0,44.997030,0> translate<21.516000,0.000000,32.580300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<21.710900,0.000000,32.385400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<21.710900,0.000000,31.995600>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,-90.000000,0> translate<21.710900,0.000000,31.995600> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<21.710900,0.000000,31.995600>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<21.516000,0.000000,31.800800>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,-44.982329,0> translate<21.516000,0.000000,31.800800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<21.516000,0.000000,31.800800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<21.126200,0.000000,31.800800>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,0.000000,0> translate<21.126200,0.000000,31.800800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<21.126200,0.000000,31.800800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<20.931400,0.000000,31.995600>}
box{<0,0,-0.050800><0.275489,0.036000,0.050800> rotate<0,44.997030,0> translate<20.931400,0.000000,31.995600> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<22.100700,0.000000,31.995600>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<22.295500,0.000000,31.800800>}
box{<0,0,-0.050800><0.275489,0.036000,0.050800> rotate<0,44.997030,0> translate<22.100700,0.000000,31.995600> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<22.295500,0.000000,31.800800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<22.685300,0.000000,31.800800>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,0.000000,0> translate<22.295500,0.000000,31.800800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<22.685300,0.000000,31.800800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<22.880200,0.000000,31.995600>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,-44.982329,0> translate<22.685300,0.000000,31.800800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<22.880200,0.000000,31.995600>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<22.880200,0.000000,32.775200>}
box{<0,0,-0.050800><0.779600,0.036000,0.050800> rotate<0,90.000000,0> translate<22.880200,0.000000,32.775200> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<22.880200,0.000000,32.775200>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<22.685300,0.000000,32.970100>}
box{<0,0,-0.050800><0.275630,0.036000,0.050800> rotate<0,44.997030,0> translate<22.685300,0.000000,32.970100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<22.685300,0.000000,32.970100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<22.295500,0.000000,32.970100>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,0.000000,0> translate<22.295500,0.000000,32.970100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<22.295500,0.000000,32.970100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<22.100700,0.000000,32.775200>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,-45.011732,0> translate<22.100700,0.000000,32.775200> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<22.100700,0.000000,32.775200>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<22.100700,0.000000,32.580300>}
box{<0,0,-0.050800><0.194900,0.036000,0.050800> rotate<0,-90.000000,0> translate<22.100700,0.000000,32.580300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<22.100700,0.000000,32.580300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<22.295500,0.000000,32.385400>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,45.011732,0> translate<22.100700,0.000000,32.580300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<22.295500,0.000000,32.385400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<22.880200,0.000000,32.385400>}
box{<0,0,-0.050800><0.584700,0.036000,0.050800> rotate<0,0.000000,0> translate<22.295500,0.000000,32.385400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<24.049500,0.000000,32.970100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<23.270000,0.000000,32.970100>}
box{<0,0,-0.050800><0.779500,0.036000,0.050800> rotate<0,0.000000,0> translate<23.270000,0.000000,32.970100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<23.270000,0.000000,32.970100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<23.270000,0.000000,32.385400>}
box{<0,0,-0.050800><0.584700,0.036000,0.050800> rotate<0,-90.000000,0> translate<23.270000,0.000000,32.385400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<23.270000,0.000000,32.385400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<23.659700,0.000000,32.580300>}
box{<0,0,-0.050800><0.435720,0.036000,0.050800> rotate<0,-26.569178,0> translate<23.270000,0.000000,32.385400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<23.659700,0.000000,32.580300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<23.854600,0.000000,32.580300>}
box{<0,0,-0.050800><0.194900,0.036000,0.050800> rotate<0,0.000000,0> translate<23.659700,0.000000,32.580300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<23.854600,0.000000,32.580300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<24.049500,0.000000,32.385400>}
box{<0,0,-0.050800><0.275630,0.036000,0.050800> rotate<0,44.997030,0> translate<23.854600,0.000000,32.580300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<24.049500,0.000000,32.385400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<24.049500,0.000000,31.995600>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,-90.000000,0> translate<24.049500,0.000000,31.995600> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<24.049500,0.000000,31.995600>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<23.854600,0.000000,31.800800>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,-44.982329,0> translate<23.854600,0.000000,31.800800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<23.854600,0.000000,31.800800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<23.464800,0.000000,31.800800>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,0.000000,0> translate<23.464800,0.000000,31.800800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<23.464800,0.000000,31.800800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<23.270000,0.000000,31.995600>}
box{<0,0,-0.050800><0.275489,0.036000,0.050800> rotate<0,44.997030,0> translate<23.270000,0.000000,31.995600> }
//IC1 silk screen
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<27.220000,0.000000,35.081000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<9.440000,0.000000,35.081000>}
box{<0,0,-0.076200><17.780000,0.036000,0.076200> rotate<0,0.000000,0> translate<9.440000,0.000000,35.081000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<9.440000,0.000000,29.239000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<27.220000,0.000000,29.239000>}
box{<0,0,-0.076200><17.780000,0.036000,0.076200> rotate<0,0.000000,0> translate<9.440000,0.000000,29.239000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<27.220000,0.000000,35.081000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<27.220000,0.000000,29.239000>}
box{<0,0,-0.076200><5.842000,0.036000,0.076200> rotate<0,-90.000000,0> translate<27.220000,0.000000,29.239000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<9.440000,0.000000,35.081000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<9.440000,0.000000,33.176000>}
box{<0,0,-0.076200><1.905000,0.036000,0.076200> rotate<0,-90.000000,0> translate<9.440000,0.000000,33.176000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<9.440000,0.000000,29.239000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<9.440000,0.000000,31.144000>}
box{<0,0,-0.076200><1.905000,0.036000,0.076200> rotate<0,90.000000,0> translate<9.440000,0.000000,31.144000> }
object{ARC(1.016000,0.152400,270.000000,450.000000,0.036000) translate<9.440000,0.000000,32.160000>}
//JP1 silk screen
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<38.622000,0.000000,33.735000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<38.622000,0.000000,32.465000>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,-90.000000,0> translate<38.622000,0.000000,32.465000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<38.622000,0.000000,32.465000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<37.987000,0.000000,31.830000>}
box{<0,0,-0.076200><0.898026,0.036000,0.076200> rotate<0,-44.997030,0> translate<37.987000,0.000000,31.830000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<37.987000,0.000000,31.830000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<36.717000,0.000000,31.830000>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,0.000000,0> translate<36.717000,0.000000,31.830000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<36.717000,0.000000,31.830000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<36.082000,0.000000,32.465000>}
box{<0,0,-0.076200><0.898026,0.036000,0.076200> rotate<0,44.997030,0> translate<36.082000,0.000000,32.465000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<37.987000,0.000000,31.830000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<38.622000,0.000000,31.195000>}
box{<0,0,-0.076200><0.898026,0.036000,0.076200> rotate<0,44.997030,0> translate<37.987000,0.000000,31.830000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<38.622000,0.000000,31.195000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<38.622000,0.000000,29.925000>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,-90.000000,0> translate<38.622000,0.000000,29.925000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<38.622000,0.000000,29.925000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<37.987000,0.000000,29.290000>}
box{<0,0,-0.076200><0.898026,0.036000,0.076200> rotate<0,-44.997030,0> translate<37.987000,0.000000,29.290000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<37.987000,0.000000,29.290000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<36.717000,0.000000,29.290000>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,0.000000,0> translate<36.717000,0.000000,29.290000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<36.717000,0.000000,29.290000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<36.082000,0.000000,29.925000>}
box{<0,0,-0.076200><0.898026,0.036000,0.076200> rotate<0,44.997030,0> translate<36.082000,0.000000,29.925000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<36.082000,0.000000,29.925000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<36.082000,0.000000,31.195000>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,90.000000,0> translate<36.082000,0.000000,31.195000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<36.082000,0.000000,31.195000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<36.717000,0.000000,31.830000>}
box{<0,0,-0.076200><0.898026,0.036000,0.076200> rotate<0,-44.997030,0> translate<36.082000,0.000000,31.195000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<37.987000,0.000000,34.370000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<36.717000,0.000000,34.370000>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,0.000000,0> translate<36.717000,0.000000,34.370000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<38.622000,0.000000,33.735000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<37.987000,0.000000,34.370000>}
box{<0,0,-0.076200><0.898026,0.036000,0.076200> rotate<0,44.997030,0> translate<37.987000,0.000000,34.370000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<36.717000,0.000000,34.370000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<36.082000,0.000000,33.735000>}
box{<0,0,-0.076200><0.898026,0.036000,0.076200> rotate<0,-44.997030,0> translate<36.082000,0.000000,33.735000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<36.082000,0.000000,32.465000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<36.082000,0.000000,33.735000>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,90.000000,0> translate<36.082000,0.000000,33.735000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<37.987000,0.000000,29.290000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<38.622000,0.000000,28.655000>}
box{<0,0,-0.076200><0.898026,0.036000,0.076200> rotate<0,44.997030,0> translate<37.987000,0.000000,29.290000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<38.622000,0.000000,28.655000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<38.622000,0.000000,27.385000>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,-90.000000,0> translate<38.622000,0.000000,27.385000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<38.622000,0.000000,27.385000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<37.987000,0.000000,26.750000>}
box{<0,0,-0.076200><0.898026,0.036000,0.076200> rotate<0,-44.997030,0> translate<37.987000,0.000000,26.750000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<37.987000,0.000000,26.750000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<36.717000,0.000000,26.750000>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,0.000000,0> translate<36.717000,0.000000,26.750000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<36.717000,0.000000,26.750000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<36.082000,0.000000,27.385000>}
box{<0,0,-0.076200><0.898026,0.036000,0.076200> rotate<0,44.997030,0> translate<36.082000,0.000000,27.385000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<36.082000,0.000000,27.385000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<36.082000,0.000000,28.655000>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,90.000000,0> translate<36.082000,0.000000,28.655000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<36.082000,0.000000,28.655000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<36.717000,0.000000,29.290000>}
box{<0,0,-0.076200><0.898026,0.036000,0.076200> rotate<0,-44.997030,0> translate<36.082000,0.000000,28.655000> }
box{<-0.254000,0,-0.254000><0.254000,0.036000,0.254000> rotate<0,-270.000000,0> translate<37.352000,0.000000,30.560000>}
box{<-0.254000,0,-0.254000><0.254000,0.036000,0.254000> rotate<0,-270.000000,0> translate<37.352000,0.000000,33.100000>}
box{<-0.254000,0,-0.254000><0.254000,0.036000,0.254000> rotate<0,-270.000000,0> translate<37.352000,0.000000,28.020000>}
//LED1 silk screen
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<30.065000,0.000000,28.380000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<33.875000,0.000000,28.380000>}
box{<0,0,-0.101600><3.810000,0.036000,0.101600> rotate<0,0.000000,0> translate<30.065000,0.000000,28.380000> }
object{ARC(3.175000,0.254000,306.869898,593.130102,0.036000) translate<31.970000,0.000000,30.920000>}
object{ARC(1.143000,0.152400,0.000000,90.000000,0.036000) translate<31.970000,0.000000,30.920000>}
object{ARC(1.143000,0.152400,180.000000,270.000000,0.036000) translate<31.970000,0.000000,30.920000>}
object{ARC(1.651000,0.152400,0.000000,90.000000,0.036000) translate<31.970000,0.000000,30.920000>}
object{ARC(1.651000,0.152400,180.000000,270.000000,0.036000) translate<31.970000,0.000000,30.920000>}
object{ARC(2.159000,0.152400,0.000000,90.000000,0.036000) translate<31.970000,0.000000,30.920000>}
object{ARC(2.159000,0.152400,180.000000,270.000000,0.036000) translate<31.970000,0.000000,30.920000>}
difference{
cylinder{<31.970000,0,30.920000><31.970000,0.036000,30.920000>2.616200 translate<0,0.000000,0>}
cylinder{<31.970000,-0.1,30.920000><31.970000,0.135000,30.920000>2.463800 translate<0,0.000000,0>}}
//R1 silk screen
cylinder{<0,0,0><0,0.036000,0>0.304800 translate<28.762000,0.000000,36.540000>}
cylinder{<0,0,0><0,0.036000,0>0.304800 translate<29.143000,0.000000,36.540000>}
box{<0,0,-0.304800><0.381000,0.036000,0.304800> rotate<0,0.000000,0> translate<28.762000,0.000000,36.540000> }
object{ARC(0.254000,0.152400,90.000000,180.000000,0.036000) translate<29.651000,0.000000,37.429000>}
object{ARC(0.254000,0.152400,180.000000,270.000000,0.036000) translate<29.651000,0.000000,35.651000>}
object{ARC(0.254000,0.152400,270.000000,360.000000,0.036000) translate<35.493000,0.000000,35.651000>}
object{ARC(0.254000,0.152400,0.000000,90.000000,0.036000) translate<35.493000,0.000000,37.429000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<29.397000,0.000000,35.651000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<29.397000,0.000000,37.429000>}
box{<0,0,-0.076200><1.778000,0.036000,0.076200> rotate<0,90.000000,0> translate<29.397000,0.000000,37.429000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<29.651000,0.000000,37.683000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<30.032000,0.000000,37.683000>}
box{<0,0,-0.076200><0.381000,0.036000,0.076200> rotate<0,0.000000,0> translate<29.651000,0.000000,37.683000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<30.159000,0.000000,37.556000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<30.032000,0.000000,37.683000>}
box{<0,0,-0.076200><0.179605,0.036000,0.076200> rotate<0,44.997030,0> translate<30.032000,0.000000,37.683000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<29.651000,0.000000,35.397000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<30.032000,0.000000,35.397000>}
box{<0,0,-0.076200><0.381000,0.036000,0.076200> rotate<0,0.000000,0> translate<29.651000,0.000000,35.397000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<30.159000,0.000000,35.524000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<30.032000,0.000000,35.397000>}
box{<0,0,-0.076200><0.179605,0.036000,0.076200> rotate<0,-44.997030,0> translate<30.032000,0.000000,35.397000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<34.985000,0.000000,37.556000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<35.112000,0.000000,37.683000>}
box{<0,0,-0.076200><0.179605,0.036000,0.076200> rotate<0,-44.997030,0> translate<34.985000,0.000000,37.556000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<34.985000,0.000000,37.556000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<30.159000,0.000000,37.556000>}
box{<0,0,-0.076200><4.826000,0.036000,0.076200> rotate<0,0.000000,0> translate<30.159000,0.000000,37.556000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<34.985000,0.000000,35.524000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<35.112000,0.000000,35.397000>}
box{<0,0,-0.076200><0.179605,0.036000,0.076200> rotate<0,44.997030,0> translate<34.985000,0.000000,35.524000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<34.985000,0.000000,35.524000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<30.159000,0.000000,35.524000>}
box{<0,0,-0.076200><4.826000,0.036000,0.076200> rotate<0,0.000000,0> translate<30.159000,0.000000,35.524000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<35.493000,0.000000,37.683000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<35.112000,0.000000,37.683000>}
box{<0,0,-0.076200><0.381000,0.036000,0.076200> rotate<0,0.000000,0> translate<35.112000,0.000000,37.683000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<35.493000,0.000000,35.397000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<35.112000,0.000000,35.397000>}
box{<0,0,-0.076200><0.381000,0.036000,0.076200> rotate<0,0.000000,0> translate<35.112000,0.000000,35.397000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<35.747000,0.000000,35.651000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<35.747000,0.000000,37.429000>}
box{<0,0,-0.076200><1.778000,0.036000,0.076200> rotate<0,90.000000,0> translate<35.747000,0.000000,37.429000> }
cylinder{<0,0,0><0,0.036000,0>0.304800 translate<36.001000,0.000000,36.540000>}
cylinder{<0,0,0><0,0.036000,0>0.304800 translate<36.382000,0.000000,36.540000>}
box{<0,0,-0.304800><0.381000,0.036000,0.304800> rotate<0,0.000000,0> translate<36.001000,0.000000,36.540000> }
box{<-0.127000,0,-0.304800><0.127000,0.036000,0.304800> rotate<0,-0.000000,0> translate<29.270000,0.000000,36.540000>}
box{<-0.127000,0,-0.304800><0.127000,0.036000,0.304800> rotate<0,-0.000000,0> translate<35.874000,0.000000,36.540000>}
//X1 silk screen
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<4.433000,0.000000,35.313000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<3.163000,0.000000,35.313000>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,0.000000,0> translate<3.163000,0.000000,35.313000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<3.163000,0.000000,35.313000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<3.163000,0.000000,34.043000>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,-90.000000,0> translate<3.163000,0.000000,34.043000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<3.163000,0.000000,34.043000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<4.433000,0.000000,34.043000>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,0.000000,0> translate<3.163000,0.000000,34.043000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<4.433000,0.000000,34.043000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<4.433000,0.000000,35.313000>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,90.000000,0> translate<4.433000,0.000000,35.313000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<4.433000,0.000000,35.313000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<3.163000,0.000000,34.043000>}
box{<0,0,-0.076200><1.796051,0.036000,0.076200> rotate<0,-44.997030,0> translate<3.163000,0.000000,34.043000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<3.163000,0.000000,35.313000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<4.433000,0.000000,34.043000>}
box{<0,0,-0.076200><1.796051,0.036000,0.076200> rotate<0,44.997030,0> translate<3.163000,0.000000,35.313000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<-0.012000,0.000000,37.853000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<-0.012000,0.000000,26.423000>}
box{<0,0,-0.076200><11.430000,0.036000,0.076200> rotate<0,-90.000000,0> translate<-0.012000,0.000000,26.423000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<-0.012000,0.000000,26.423000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<7.862000,0.000000,26.423000>}
box{<0,0,-0.076200><7.874000,0.036000,0.076200> rotate<0,0.000000,0> translate<-0.012000,0.000000,26.423000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<7.862000,0.000000,26.423000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<8.370000,0.000000,26.423000>}
box{<0,0,-0.076200><0.508000,0.036000,0.076200> rotate<0,0.000000,0> translate<7.862000,0.000000,26.423000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<8.370000,0.000000,37.853000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<7.862000,0.000000,37.853000>}
box{<0,0,-0.076200><0.508000,0.036000,0.076200> rotate<0,0.000000,0> translate<7.862000,0.000000,37.853000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<7.862000,0.000000,37.853000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<-0.012000,0.000000,37.853000>}
box{<0,0,-0.076200><7.874000,0.036000,0.076200> rotate<0,0.000000,0> translate<-0.012000,0.000000,37.853000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<1.258000,0.000000,37.218000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<6.592000,0.000000,37.218000>}
box{<0,0,-0.076200><5.334000,0.036000,0.076200> rotate<0,0.000000,0> translate<1.258000,0.000000,37.218000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<6.592000,0.000000,37.218000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<6.846000,0.000000,37.218000>}
box{<0,0,-0.076200><0.254000,0.036000,0.076200> rotate<0,0.000000,0> translate<6.592000,0.000000,37.218000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<6.846000,0.000000,27.058000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<6.592000,0.000000,27.058000>}
box{<0,0,-0.076200><0.254000,0.036000,0.076200> rotate<0,0.000000,0> translate<6.592000,0.000000,27.058000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<6.592000,0.000000,27.058000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<1.258000,0.000000,27.058000>}
box{<0,0,-0.076200><5.334000,0.036000,0.076200> rotate<0,0.000000,0> translate<1.258000,0.000000,27.058000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<4.433000,0.000000,30.233000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<3.163000,0.000000,30.233000>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,0.000000,0> translate<3.163000,0.000000,30.233000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<3.163000,0.000000,30.233000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<3.163000,0.000000,28.963000>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,-90.000000,0> translate<3.163000,0.000000,28.963000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<3.163000,0.000000,28.963000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<4.433000,0.000000,28.963000>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,0.000000,0> translate<3.163000,0.000000,28.963000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<4.433000,0.000000,28.963000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<4.433000,0.000000,30.233000>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,90.000000,0> translate<4.433000,0.000000,30.233000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<4.433000,0.000000,30.233000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<3.163000,0.000000,28.963000>}
box{<0,0,-0.076200><1.796051,0.036000,0.076200> rotate<0,-44.997030,0> translate<3.163000,0.000000,28.963000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<3.163000,0.000000,30.233000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<4.433000,0.000000,28.963000>}
box{<0,0,-0.076200><1.796051,0.036000,0.076200> rotate<0,44.997030,0> translate<3.163000,0.000000,30.233000> }
object{ARC(2.667000,0.152400,126.869898,180.000000,0.036000) translate<2.909000,0.000000,34.678000>}
object{ARC(2.667000,0.152400,180.000000,233.130102,0.036000) translate<2.909000,0.000000,34.678000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<1.258000,0.000000,32.519000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<1.258000,0.000000,31.757000>}
box{<0,0,-0.076200><0.762000,0.036000,0.076200> rotate<0,-90.000000,0> translate<1.258000,0.000000,31.757000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<1.258000,0.000000,37.218000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<1.258000,0.000000,36.786200>}
box{<0,0,-0.076200><0.431800,0.036000,0.076200> rotate<0,-90.000000,0> translate<1.258000,0.000000,36.786200> }
object{ARC(2.667000,0.152400,126.869898,180.000000,0.036000) translate<2.909000,0.000000,29.598000>}
object{ARC(2.667000,0.152400,180.000000,233.130102,0.036000) translate<2.909000,0.000000,29.598000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<1.258000,0.000000,27.489800>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<1.258000,0.000000,27.058000>}
box{<0,0,-0.076200><0.431800,0.036000,0.076200> rotate<0,-90.000000,0> translate<1.258000,0.000000,27.058000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<6.592000,0.000000,37.218000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<6.592000,0.000000,35.186000>}
box{<0,0,-0.076200><2.032000,0.036000,0.076200> rotate<0,-90.000000,0> translate<6.592000,0.000000,35.186000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<6.592000,0.000000,35.186000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<6.592000,0.000000,34.170000>}
box{<0,0,-0.076200><1.016000,0.036000,0.076200> rotate<0,-90.000000,0> translate<6.592000,0.000000,34.170000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<6.592000,0.000000,34.170000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<6.592000,0.000000,30.106000>}
box{<0,0,-0.076200><4.064000,0.036000,0.076200> rotate<0,-90.000000,0> translate<6.592000,0.000000,30.106000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<6.592000,0.000000,30.106000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<6.592000,0.000000,29.090000>}
box{<0,0,-0.076200><1.016000,0.036000,0.076200> rotate<0,-90.000000,0> translate<6.592000,0.000000,29.090000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<6.592000,0.000000,29.090000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<6.592000,0.000000,27.058000>}
box{<0,0,-0.076200><2.032000,0.036000,0.076200> rotate<0,-90.000000,0> translate<6.592000,0.000000,27.058000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<8.370000,0.000000,37.853000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<8.370000,0.000000,35.186000>}
box{<0,0,-0.076200><2.667000,0.036000,0.076200> rotate<0,-90.000000,0> translate<8.370000,0.000000,35.186000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<8.370000,0.000000,35.186000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<8.370000,0.000000,34.170000>}
box{<0,0,-0.076200><1.016000,0.036000,0.076200> rotate<0,-90.000000,0> translate<8.370000,0.000000,34.170000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<8.370000,0.000000,34.170000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<8.370000,0.000000,30.106000>}
box{<0,0,-0.076200><4.064000,0.036000,0.076200> rotate<0,-90.000000,0> translate<8.370000,0.000000,30.106000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<8.370000,0.000000,30.106000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<8.370000,0.000000,29.090000>}
box{<0,0,-0.076200><1.016000,0.036000,0.076200> rotate<0,-90.000000,0> translate<8.370000,0.000000,29.090000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<8.370000,0.000000,29.090000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<8.370000,0.000000,26.423000>}
box{<0,0,-0.076200><2.667000,0.036000,0.076200> rotate<0,-90.000000,0> translate<8.370000,0.000000,26.423000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<6.592000,0.000000,30.106000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<8.370000,0.000000,30.106000>}
box{<0,0,-0.076200><1.778000,0.036000,0.076200> rotate<0,0.000000,0> translate<6.592000,0.000000,30.106000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<6.592000,0.000000,29.090000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<8.370000,0.000000,29.090000>}
box{<0,0,-0.076200><1.778000,0.036000,0.076200> rotate<0,0.000000,0> translate<6.592000,0.000000,29.090000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<7.862000,0.000000,37.853000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<7.862000,0.000000,35.440000>}
box{<0,0,-0.076200><2.413000,0.036000,0.076200> rotate<0,-90.000000,0> translate<7.862000,0.000000,35.440000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<7.862000,0.000000,33.916000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<7.862000,0.000000,30.360000>}
box{<0,0,-0.076200><3.556000,0.036000,0.076200> rotate<0,-90.000000,0> translate<7.862000,0.000000,30.360000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<7.862000,0.000000,30.360000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<8.370000,0.000000,30.106000>}
box{<0,0,-0.076200><0.567961,0.036000,0.076200> rotate<0,26.563298,0> translate<7.862000,0.000000,30.360000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<7.862000,0.000000,30.360000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<6.846000,0.000000,30.360000>}
box{<0,0,-0.076200><1.016000,0.036000,0.076200> rotate<0,0.000000,0> translate<6.846000,0.000000,30.360000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<6.846000,0.000000,30.360000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<6.592000,0.000000,30.106000>}
box{<0,0,-0.076200><0.359210,0.036000,0.076200> rotate<0,-44.997030,0> translate<6.592000,0.000000,30.106000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<6.846000,0.000000,30.360000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<6.846000,0.000000,33.916000>}
box{<0,0,-0.076200><3.556000,0.036000,0.076200> rotate<0,90.000000,0> translate<6.846000,0.000000,33.916000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<6.846000,0.000000,35.440000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<6.846000,0.000000,37.218000>}
box{<0,0,-0.076200><1.778000,0.036000,0.076200> rotate<0,90.000000,0> translate<6.846000,0.000000,37.218000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<8.370000,0.000000,29.090000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<7.862000,0.000000,28.836000>}
box{<0,0,-0.076200><0.567961,0.036000,0.076200> rotate<0,-26.563298,0> translate<7.862000,0.000000,28.836000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<7.862000,0.000000,28.836000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<7.862000,0.000000,26.423000>}
box{<0,0,-0.076200><2.413000,0.036000,0.076200> rotate<0,-90.000000,0> translate<7.862000,0.000000,26.423000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<7.862000,0.000000,28.836000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<6.846000,0.000000,28.836000>}
box{<0,0,-0.076200><1.016000,0.036000,0.076200> rotate<0,0.000000,0> translate<6.846000,0.000000,28.836000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<6.846000,0.000000,28.836000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<6.592000,0.000000,29.090000>}
box{<0,0,-0.076200><0.359210,0.036000,0.076200> rotate<0,44.997030,0> translate<6.592000,0.000000,29.090000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<6.846000,0.000000,28.836000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<6.846000,0.000000,27.058000>}
box{<0,0,-0.076200><1.778000,0.036000,0.076200> rotate<0,-90.000000,0> translate<6.846000,0.000000,27.058000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<6.592000,0.000000,34.170000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<8.370000,0.000000,34.170000>}
box{<0,0,-0.076200><1.778000,0.036000,0.076200> rotate<0,0.000000,0> translate<6.592000,0.000000,34.170000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<6.592000,0.000000,35.186000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<8.370000,0.000000,35.186000>}
box{<0,0,-0.076200><1.778000,0.036000,0.076200> rotate<0,0.000000,0> translate<6.592000,0.000000,35.186000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<7.862000,0.000000,35.440000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<6.846000,0.000000,35.440000>}
box{<0,0,-0.076200><1.016000,0.036000,0.076200> rotate<0,0.000000,0> translate<6.846000,0.000000,35.440000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<7.862000,0.000000,33.916000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<6.846000,0.000000,33.916000>}
box{<0,0,-0.076200><1.016000,0.036000,0.076200> rotate<0,0.000000,0> translate<6.846000,0.000000,33.916000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<8.370000,0.000000,34.170000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<7.862000,0.000000,33.916000>}
box{<0,0,-0.076200><0.567961,0.036000,0.076200> rotate<0,-26.563298,0> translate<7.862000,0.000000,33.916000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<7.862000,0.000000,35.440000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<8.370000,0.000000,35.186000>}
box{<0,0,-0.076200><0.567961,0.036000,0.076200> rotate<0,26.563298,0> translate<7.862000,0.000000,35.440000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<6.846000,0.000000,35.440000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<6.592000,0.000000,35.186000>}
box{<0,0,-0.076200><0.359210,0.036000,0.076200> rotate<0,-44.997030,0> translate<6.592000,0.000000,35.186000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<6.846000,0.000000,33.916000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<6.592000,0.000000,34.170000>}
box{<0,0,-0.076200><0.359210,0.036000,0.076200> rotate<0,44.997030,0> translate<6.592000,0.000000,34.170000> }
texture{col_slk}
}
#end
translate<mac_x_ver,mac_y_ver,mac_z_ver>
rotate<mac_x_rot,mac_y_rot,mac_z_rot>
}//End union
#end

#if(use_file_as_inc=off)
object{  THERMOCOUPLE(-21.336000,0,-32.131000,pcb_rotate_x,pcb_rotate_y,pcb_rotate_z)
#if(pcb_upsidedown=on)
rotate pcb_rotdir*180
#end
}
#end


//Parts not found in 3dpack.dat or 3dusrpac.dat are:
