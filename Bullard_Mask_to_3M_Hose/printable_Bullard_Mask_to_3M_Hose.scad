/*
  Support material for Bullard_Mask_to_3M_Hose,
  tilted over sideways, and supported.
  
  OpenSCAD by Dr. Orion Lawlor <lawlor@alaska.edu>
*/

spacing=0.4; // distance between support material and part
height=53; // original upright distance to pegs
tiltover=45; // angle of tilt (0==upright)
support_height=47.5; // post-rotate distance to pegs
support_width=0.7;

// Comes out upright and centered
module main_part()
{
	translate([18.8,-21.25])
	rotate([0,-90,0])
		import("Bullard_Mask_to_3M_Hose.stl",convexity=6);
}

// Main part, with inside filled in solid (to cut support material)
module main_part_solid() {
	main_part();
	cylinder(d=28,h=45);
	translate([0,0,43]) cylinder(d=34,h=30);
}

// Tilt part over to printable orientation
module part_tilt() {
	translate([0,0,+support_height])
	rotate([0,tiltover,0])
	translate([0,0,-height])
		children();
}

// Tapered stick down
module stickdown() {
	cylinder(d1=8,d2=4,h=2);
}


// Support-type rings are defined relative to un-tilted part
module support_ring(z,OD,wall,topclip,flare=1)
{
	color([1,0,0]) union() {
		difference() {
			// Project down to support each ridgeline
			linear_extrude(height=30,convexity=4)
			projection(cut=false)
			part_tilt()
			translate([0,0,z])
			{
				linear_extrude(height=1)
				difference() {
					circle(d=OD);
					circle(d=OD-2*wall);
					translate([topclip-100,0,0]) square([200,200],center=true);
				}
			}
		
			// Trim those supports along (tilted) z
			part_tilt()
			translate([0,0,z+1+100])
				cube([200,200,200],center=true);
		}
		
		if (flare) { // flare out object contact surface
			part_tilt() {
				intersection() {
				translate([0,0,z-1.5]) {
					cylinder(d1=OD+3,d2=OD-1,h=4.5);
					/*
					scale([1,1,-1])
					cylinder(d1=OD+5,d2=OD-2,h=1);
					*/
				}
				translate([OD/2,0,z])
					cube([30,35,100],center=true);
				}
			}
		}
	}
}

// Support towers over pegs
module support_towers()
{
	for (side=[-1,+1]) scale([1,side,1])
		translate([-0.5,20.0,0])
		union() {
			translate([0,0,support_height/2]) union() {
				cube([4,support_width,support_height],center=true);
				cube([support_width,2,support_height],center=true);
			}
			
			stickdown();
		}
}

module all_support_material() {
	difference() {
		union() {
			spine_length=38;
			spine_width=support_width;
			translate([-27,0,0]) 
			{
				difference() {
					translate([0,-spine_width/2,0])
					cube([spine_length,spine_width,50]);
					translate([0,0,0.5]) rotate([0,-90+tiltover+2,0]) 
						translate([0,0,100]) cube([200,200,200],center=true);
				}
				
				// Support the part base
				translate([-1.5,0,2]) cube([5,20,4],center=true);
				
				// Keep tip from coming up
				translate([spine_length,0,0])
					stickdown();
			}
			
			ring_width=support_width*0.5;
			support_ring(-0.8,28.2,ring_width,-50,0);
			support_ring(8.2,39,ring_width,5);
			support_ring(18.0,39,ring_width,10);
			support_ring(31,37,ring_width,10);
			
			support_towers();
		}
		
		// Leave space around the main part
		for (shift=[[0,0,-spacing],[0,+spacing,0],[0,-spacing,0],[spacing,0,0],[0,0,+spacing]])
			translate(shift)
				part_tilt() main_part_solid();
	}
}

intersection() {
	union() {
		part_tilt() main_part();

		all_support_material();
	}
	
	// Trim bottom flat
	color([0,1,0])
	translate([0,0,100]) cube([200,200,200],center=true);
}

if (0) difference() {
	main_part_solid();
	cube([100,100,100]);
}
