include <parameters.scad>;
use <library.scad>;

module accessories(holes=false, angle=270)
{
	translate([-3,15,-62])
	{
		for(i=[-1,1])
		{
			if(!holes)
			translate([0, i*x_bar_gap/2 , 0])
				rotate([0,90,0])
					rod(100);

			if(!holes)
			translate([0, i*40 , 0])
				cube([100,2,6], center=true);
		}

		translate([7, x_bar_gap/2, 0])
			rotate([-90,180,90])
				if(holes)
					adjustable_bearing(true,angle);
				else
					adjustable_bearing(true,-1);
		translate([-35, x_bar_gap/2, 0])
			rotate([-90,180,90])
				if(holes)
					adjustable_bearing(true,angle);
				else
					adjustable_bearing(true,-1);

		if(holes)
		translate([14, 25-4 , 0])
			rotate([0,0,angle])
				if(huxley)
					teardrop(h=40,r=screwsize/2,truncateMM=0.5);
				else
					teardrop(h=40,r=2,truncateMM=0.5);

		if(holes && mendel)
		translate([14, -25-4 , 0])
			rotate([0,0,angle])
				teardrop(h=40,r=2,truncateMM=0.5);

		if(holes && huxley)
		translate([14, 25-12 , 0])
			rotate([0,0,angle])
					teardrop(h=40,r=screwsize/2,truncateMM=0.5);

		translate([15, -x_bar_gap/2 + 3, 0])
			rotate([-90,180,-90])
				if(holes)
					adjustable_bearing(false,360-angle);
				else
					adjustable_bearing(false,-1);

	}

/*translate([-42+32*cos(-60),16,32*sin(-60)])
	translate([7,0,-50+12.5])		
		cylinder(h=25,r=4,center=true, $fn=15);*/
}

module filament()
{
	union()
	{
		cylinder(h=100,r=1,center=true, $fn=15);
		translate([0,0,-10])
			cylinder(h=10,r1=1, r2=2,center=true, $fn=15);
	}
}

module idler_holes(screws=true, bearing=true)
{
	translate([1,0,0])
	union()
	{
		if(screws)
		{
			for(i=[-1,1])
			for(j=[-1,1])
			translate([0,i*4,j*5])
				rotate([0,90,0])
				{
					cylinder(h=60,r=screwsize/2,center=true, $fn=10);
					translate([0,0,30])
						cylinder(h=20,r=nutsize,center=true, $fn=6);
				}
		}

		if(bearing)
		{
			rotate([90,0,0])
			{
				translate([0,0,-15])
					rotate([0,0,180])
					{
						teardrop(h=30,r=screwsize/2,truncateMM=0.5);
						translate([0,0,-19])
						{
							teardrop(h=30,r=screwsize,truncateMM=0.5);
							translate([0,0,59])
								pentanut(height=20);
						}
					}
				cylinder(h=4.2,r=6,center=true, $fn=20);
				translate([5,0,0])
					cube([10,12,4.2],center=true);
			}
		}



	}
}


module idler(body=true)
{
	if(body)
	{
		difference()
		{
			union()
			{
				translate([-2,0,0])
					cube([12,15,16], center = true);
				translate([1,0,10])
					cube([18,10,5], center = true);
			}
			idler_holes();
			translate([7,0,0])
				filament();
		}
	} else
		idler_holes(screws=true, bearing=false, filament=true);
}

module retaining_block_holes(teardrop=false)
{
	translate([24,30,0])
		rotate([90,180,0])
			if(teardrop)
				teardrop(h = 60, r = screwsize/2, truncateMM=0.5);
			else
				translate([0,0,30])
				{
					cylinder(h = 60, r = screwsize/2, center=true,$fn=10);
					translate([0,0,23])
						cylinder(h = 20, r = screwsize, center=true,$fn=10);
				}

	if(!teardrop)
			translate([21,0,0])
				for(i=[-1,1])
					translate([0,i*8,0])
						rotate([0,0,45])
							cube([5,5,18], center = true);		
}

module retaining_block(body=true)
{
	if(body)
	{
		difference()
		{
			translate([21,0,0])
				union()
				{
					cube([14,16,18], center = true);
					for(i=[-1,1])
						translate([0,i*8,0])
							rotate([0,0,45])
								cube([5,5,18], center = true);	
				}
			idler_holes(screws=true, bearing=false,filament=true);
			retaining_block_holes(teardrop=true);
		}
	} else
		retaining_block_holes(teardrop=false);
}

module nozzle_block_holes(teardrop=false, filament=true)
{
	translate([7,0,0])
		union()
		{
			filament();

			translate([0,0,-50])
				rotate([0,0,90])
					teardrop(h=30,r=4.2,truncateMM=0.5);
			for(i=[-1,1])
				rotate([0,0,90])
					translate([0,i*19/2,-35])
						teardrop(h=50,r=screwsize/2,truncateMM=0.5);
		
			for(i=[-1,1])
				translate([i*6,30,-20])
					rotate([90,-90,0])
						translate([0,0,30])
						{
							cylinder(h = 60, r = screwsize/2, center=true,$fn=10);
							translate([0,0,23])
								cylinder(h = 20, r = screwsize, center=true,$fn=10);
							translate([0,0,-23])
								cylinder(h = 20, r = screwsize, center=true,$fn=6);
						}
		}
}

module nozzle_block(body=true)
{
	if(body)
	{
		difference()
		{
			union()
			{
				translate([13,0,-20])
				difference()
				{
					cube([59,16,10], center = true);
					translate([59/2-16/2, 0, 5])
						cube([22,20,10], center = true);
					translate([-59/2+8/2, 0, 5])
						cube([13,20,10], center = true);
				}
				translate([7,0,-14])
					cube([10,16,10], center = true);
			}

			idler_holes(screws=true, bearing=false,filament=true);
			nozzle_block_holes(teardrop=true);
		}
	} else
		nozzle_block_holes(teardrop=false);
}


module m6_shaft(body=true, gearonly = false)
{
	rotate([-90,0,0])
	{
		union()
		{

			if(gearonly || body)
				translate([0,0,-33])
					rotate([0,0,2])
						difference()
						{
							union()
							{
								grub_gear(hub_height = 10, hub_radius = 10, shaft_radius = 3, height = 7, 
									number_of_teeth = 31, inner_radius = 22, outer_radius = 25, angle=15);
								difference()
								{
									strut(p1=[0,-13,-5], p2=[0,13,-5], wide = 10, deep = 15, round=2);
									cylinder(h=50,r=9, center=true,$fn=20);
								}
							}
							intersection()
							{
								translate([0,18,-14])
									rotate([-45,0,0])
										cube([4, 26, 20], center=true);
								cylinder(h=50,r=20, center=true,$fn=20);
							}
							intersection()
							{
								translate([0,-18,-14])
									rotate([45,0,0])
										cube([4, 26, 20], center=true);
								cylinder(h=50,r=20, center=true,$fn=20);
							}

						}
			if(!gearonly)
			{
				if(body)
					translate([0,0,-17])
						rod(55);
				else
					cylinder(h=80,r=7.5,center=true);
	
				translate([0,0,5])
					if(body)
						cylinder(h=6,r=9.5,center=true);
					else
						cylinder(h=6.2,r=10,center=true);
	
				translate([0,0,-23])
					if(body)
						cylinder(h=6,r=9.5,center=true);
					else
						cylinder(h=6.2,r=10,center=true);
			}
		}	
	}
}

module plate_holes()
{
	union()
	{
		rotate([0,-60,0])
			translate([-32, 25,0])
				m6_shaft(body=false,gearonly = false);
		
		translate([-42+32*cos(-60),16,32*sin(-60)])
			idler(body=false);
		
		translate([0, 11.5,0])
			rotate([-90,0,0])
		  		nema11(body=false, slots = 5, counterbore=8);
		
		translate([-42+32*cos(-60),16,32*sin(-60)])
		{
			retaining_block(body=false);
			nozzle_block(body=false);
			for(i=[-1,1])
			for(j=[0,1])
			translate([j*18,0,-34+i*6])
				rotate([90,0,0])
				{
					cylinder(h=200,r=screwsize/2, center=true, $fn=10);
					translate([0,0,-9])
						cylinder(h=50,r=screwsize, center=true, $fn=6);
				}
		}

		/*translate([-55,0,0])
			rotate([0, 30, 0])
				cube([50,80,100], center=true);

		translate([32,0,-40])
			rotate([0, 28, 0])
				cube([50,80,100], center=true);*/
	}
}

module motor_plate()
{
	difference()
	{
		translate([nema11_square/2+2-50, 0,nema11_square/2+2-69])
			union()
			{
				cube([50, 8, 69]);
				translate([38,-20,0])
					cube([12, 20, 5]);
			}
		plate_holes();
		accessories(holes=true, angle=90);
	}
}

module back_plate()
{
	difference()
	{	
		translate([-(50-nema11_square/2-2), 24,nema11_square/2 + 2 -  69])
			union()
			{
				cube([50-nema11_square/2, 8, 69-nema11_square - 4]);
				translate([30,0,0])
					cube([20, 20, 5]);
				translate([-8,0,0])
					cube([12, 20, 5]);
				if(huxley)
				{
					translate([17, 15, -1])
					intersection()
					{
						difference()
						{
							cube([28, 30, 35],center=true);
							difference()
							{
								translate([0,0,25])
									rotate([-25,0,0])
										cube([40, 60, 40],center=true);
								translate([0,0,-20])
										cube([42, 62, 42],center=true);
							}
					
						}
						union()
						{
							translate([0,0,15])
									rotate([-25,0,0])
										cube([40, 60, 40],center=true);
								translate([0,20,5])
										rotate([-45,0,0])
											cube([42, 62, 42],center=true);
						}
	
					}
				}
			}
		plate_holes();
		accessories(holes=true, angle=270);
	}
}


module belt_clamp()
{
	difference()
	{
		translate([-(50-nema11_square/2-2), 24,nema11_square/2 + 2 -  69])
			translate([26, 35, -9.5])
				cube([7,7,18.5], center=true);
		plate_holes();
	}
}




motor_plate();

back_plate();

belt_clamp();

rotate([0,-60,0])
	translate([-32, 25,0])
		m6_shaft(body=true, gearonly=true);

translate([-42+32*cos(-60),16,32*sin(-60)])
	idler(body=true);

translate([-42+32*cos(-60),16,32*sin(-60)])
	retaining_block(body=true);

difference()
{
translate([-42+32*cos(-60),16,32*sin(-60)])
	nozzle_block(body=true);
accessories(holes=true, angle=90);
}


rotate([90,0,0])
	grub_gear(hub_height = 7, hub_radius = 9.5, shaft_radius = 2.5, height = 8, number_of_teeth = 11, 
		inner_radius = 6.5, outer_radius = 9, angle=25);

translate([0, 8,0])
	rotate([-90,0,0])
 		nema11(body=true, slots = 5, counterbore=8);

accessories();