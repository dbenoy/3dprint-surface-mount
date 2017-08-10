$fn=60;

module clip(width, height, thickness, tooth_size) {
    cube([thickness, width, height + tooth_size]);
    translate([thickness, 0, 0]) translate([0, 0, height]) intersection() {
        cube([tooth_size, width, tooth_size]);
        translate([0, 0, tooth_size]) rotate([0, 135, 0]) cube([tooth_size * sqrt(2), width, tooth_size * sqrt(2)]);
    }
}

module fh_screw_hole(diameter, head_diameter, countersink_angle, length) {
    cylinder(d1=head_diameter, d2=0, h=head_diameter/2);
    cylinder(d=diameter, h=length);
}

module surface_mount_corner(
    tolerence=0.1,
    bracket_width=50,
    height=25,
    base_thickness=3,
    clip_thickness=2,
    tooth_size=5,
    screw_diameter=3.45,
    screw_head_diameter=6.90,
    screw_countersink_angle=90
) {
    rotate([90, 0, 0]) translate([-clip_thickness, -clip_thickness, -base_thickness]) difference() {
        intersection() {
            cube([clip_thickness + bracket_width, clip_thickness + bracket_width, height + tooth_size + base_thickness]);
            cylinder(h=height + tooth_size + base_thickness, r=bracket_width + clip_thickness);
            union() {
                cube([bracket_width + clip_thickness, bracket_width + clip_thickness, base_thickness]);
                translate([0, 0, base_thickness]) clip(width=bracket_width + clip_thickness, height=height, thickness=clip_thickness, tooth_size=tooth_size);
                translate([clip_thickness + tooth_size + tolerence, 0, 0]) mirror([1, 0, 0]) rotate([0, 0, 90]) clip(width=bracket_width + clip_thickness, height=height, thickness=clip_thickness, tooth_size=tooth_size);
            }
        }
        translate([bracket_width/2.5, bracket_width/2.5, base_thickness + 0.1]) rotate([180, 0, 0]) fh_screw_hole(diameter=screw_diameter, head_diameter=screw_head_diameter, countersink_angle=screw_countersink_angle, length=base_thickness+0.2);
    }
}

module surface_mount_side(
    bracket_width=50,
    height=25,
    base_thickness=3,
    clip_thickness=2,
    tooth_size=5,
    screw_diameter=3.45,
    screw_head_diameter=6.90,
    screw_countersink_angle=90
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
        translate([clip_thickness + bracket_width/2.5, bracket_width/2, base_thickness + 0.1]) rotate([180, 0, 0]) fh_screw_hole(diameter=screw_diameter, head_diameter=screw_head_diameter, countersink_angle=screw_countersink_angle, length=base_thickness+0.2);
    }
}

surface_mount_side();