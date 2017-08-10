$fn=60;

//CUSTOMIZER VARIABLES

// Whether to place an edge holder on the side(s) of the stand
type = 0; // [0:Corner, 1:Side]

// The width of the entire bracket not counting the clip thickness
bracket_width=30;

// The thickness of the clips (the parts that grip on the object with the tooth on top)
clip_thickness=3;

// How deep and tall the teeth are
tooth_size=4;

// The height of the object that will be put in the bracket
height=25;

// The thickness of the base of the object (Make sure it's thick enough to accomodate your desired screw size)
base_thickness=5;

// The diameter of the screw hole
screw_diameter=3.45;

// The diameter of the head of the screw (For countersinking)
screw_head_diameter=6.90;

// The separation tolerance (This is to prevent things from fusing together that aren't supposed to, and will depend on your printer. You probably don't have to change this)
tolerence=0.1;

//CUSTOMIZER VARIABLES END


module clip(width, height, thickness, tooth_size) {
    cube([thickness, width, height + tooth_size]);
    translate([thickness, 0, 0]) translate([0, 0, height]) intersection() {
        cube([tooth_size, width, tooth_size]);
        translate([0, 0, tooth_size]) rotate([0, 135, 0]) cube([tooth_size * sqrt(2), width, tooth_size * sqrt(2)]);
    }
}

module fh_screw_hole(diameter, head_diameter, length) {
    cylinder(d1=head_diameter, d2=0, h=head_diameter/2);
    cylinder(d=diameter, h=length);
}

module surface_mount_corner(
    tolerence=tolerence,
    bracket_width=bracket_width,
    height=height,
    base_thickness=base_thickness,
    clip_thickness=clip_thickness,
    tooth_size=tooth_size,
    screw_diameter=screw_diameter,
    screw_head_diameter=screw_head_diameter
) {
    rotate([90, 0, 0]) translate([-clip_thickness, -clip_thickness, -base_thickness]) difference() {
        union() {
            intersection() {
                cube([clip_thickness + bracket_width, clip_thickness + bracket_width, height + tooth_size + base_thickness]);
                translate([clip_thickness, clip_thickness, 0]) cylinder(h=height + tooth_size + base_thickness, r=bracket_width);
                cube([bracket_width + clip_thickness, bracket_width + clip_thickness, base_thickness]);
            }
            clip(width=bracket_width + clip_thickness, height=height + base_thickness, thickness=clip_thickness, tooth_size=tooth_size);
            translate([clip_thickness + tooth_size + tolerence, 0, 0]) mirror([1, 0, 0]) rotate([0, 0, 90]) clip(width=bracket_width - tooth_size - tolerence, height=height + base_thickness, thickness=clip_thickness, tooth_size=tooth_size);
        }
        translate([bracket_width * cos(45) / 2 + clip_thickness, bracket_width * sin(45) / 2 + clip_thickness, base_thickness + 0.1]) rotate([180, 0, 0]) fh_screw_hole(diameter=screw_diameter, head_diameter=screw_head_diameter, length=base_thickness+0.2);
    }
}

module surface_mount_side(
    bracket_width=bracket_width,
    height=height,
    base_thickness=base_thickness,
    clip_thickness=clip_thickness,
    tooth_size=tooth_size,
    screw_diameter=screw_diameter,
    screw_head_diameter=screw_head_diameter
) {
    rotate([90, 0, 0]) translate([-clip_thickness, 0, -base_thickness]) difference() {
        intersection() {
            cube([bracket_width + clip_thickness, bracket_width + clip_thickness, height + tooth_size + base_thickness]);
            union() {
                cube([bracket_width/3 + clip_thickness, bracket_width, height + tooth_size + base_thickness]);
                translate([bracket_width/3 + clip_thickness, bracket_width/2, 0]) cylinder(h=height + tooth_size + base_thickness, d=bracket_width);
            }
            union() {
                cube([bracket_width + clip_thickness, bracket_width, base_thickness]);
                translate([0, 0, base_thickness]) clip(width=bracket_width, height=height, thickness=clip_thickness, tooth_size=tooth_size);
            }
        }
        translate([clip_thickness + bracket_width/2.5, bracket_width/2, base_thickness + 0.1]) rotate([180, 0, 0]) fh_screw_hole(diameter=screw_diameter, head_diameter=screw_head_diameter, length=base_thickness+0.2);
    }
}

if (type == 0) {
    surface_mount_corner();
} else {
    surface_mount_side();
}