/*
 Female socket for Bullard Hoods.
*/

$fs=0.1;
$fa=3;
inch=25.4; // file units are mm

ID=1.455*inch;// male side fits in here
OD=41.0; // OD of main outside
OD_track=43.5; // OD along bottom of peg track
TD=OD+2*2;

bottom_shorten=4.5;
new_bottom=TD+17*2;

module fit_test_male() {
	translate([0,0,72.7])
	scale([1,1,-1])
		import("../PAPR_adapter/Old_Mask_to_New_Hose_rev3_upright.stl",convexity=4);
}

module connector() {
	rotate([0,0,20])
	translate([-76.2/2,76.2/2,39.37])
	rotate([180,0,0])
	import("Bullard Hood Connector_threaded.STL",convexity=8);
}

module thread_split(offset=0) {
	translate([0,0,-100+14.1+offset])
		cube([200,200,200],center=true);
}

module reinforced_connector() {
	// Outer lug supports (permanent)
	intersection() {
		rotate([0,0,-14])
		cube([16,100,100],center=true);
		difference() {
			translate([0,0,10])
				cylinder(d=TD,h=20);
			
			// Thru hole in middle
			translate([0,0,-1])
			cylinder(d=OD,h=32);
			
			// Extra-deep tracks
			difference() {
				translate([0,0,20])
				cylinder(d=OD_track,h=12);
			
				intersection() {
					s=OD_track/OD;
					translate([0,0,0.01])
					scale([s,s,1])
						connector();
					
					translate([0,0,25])
					cube([30,100,10],center=true);
				}
			}

		}
	}
	
	// Inner lug start support (temporary, removed after printing)
	rotate([0,0,-4]) {
		for (side=[-1,+1]) scale([1,side,1])
			translate([0,ID/2,24.6])
				cube([5,1,4.6],center=true);
	}
	
	
	difference() {
		union() {
			scale([-1,1,1]) 
			intersection() {
				connector();
				thread_split();
			}
			difference() {
				connector();
				thread_split(-0.01);
			}
		}
		
		// Clearance inside for male plug
		translate([0,0,15])
			cylinder(d=ID,h=100);
	}
}

module shortened_connector() {
	difference() {
		translate([0,0,-bottom_shorten])
			reinforced_connector();

		// Cut off bottom flush
		translate([0,0,-100+0.001])
			cube([200,200,200],center=true);
		
	}
	
	difference() {
		union() {
			cylinder(d=new_bottom,h=0.7);
			translate([0,0,0.8-0.01])
				cylinder(d1=new_bottom,d2=42,h=1.5);
			
			translate([0,0,0.1])
				cylinder(d1=OD+2*5,d2=OD,h=5);
		}
		cylinder(d=OD,h=100,center=true);
	}
}

difference() {
	union() {
		shortened_connector();
		// fit_test_male();
	}
	// cube([100,100,100]); // cutaway
}

