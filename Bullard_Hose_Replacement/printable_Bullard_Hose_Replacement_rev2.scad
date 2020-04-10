/*
  Support material for Bullard Hose Replacement, standing upright.
  
  OpenSCAD code by Dr. Orion Lawlor, 2020-04-03
*/

spacing=0.5;

module main_part()
{
	translate([18.5,-21.3])
	rotate([0,-90,0])
		import("Bullard_Hose_Replacement_rev2.stl");
}

module support_material() 
{
	height=42;
	for (side=[-1,+1]) scale([1,side,1])
		translate([0,20.2,0])
		union() {
			translate([0,0,height/2])
				cube([4,2,height],center=true);
			
			cylinder(d1=8,d2=4,h=2);
		}
}

main_part();
difference() {
	support_material();
	
	// Leave space around the main part
	translate([0,0,-spacing])
		main_part();
}
