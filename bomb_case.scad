include <variables.scad>

$fn = $preview ? 10 : 50;

module_hole_tolerance = 1;
back_plate_thickness = 4.5;
screw_hole_offset = 25;

wall_between_modules_thickness = 8; 
wall_between_modules_corner_radius = 1;
wall_between_modules_tolerance = 0.2;
vertical_wall_height = 25;
horizontal_wall_height = 22;

gap = size + module_hole_tolerance + wall_between_modules_thickness;
module_gap = size + module_hole_tolerance;

back_plate_length = (size + module_hole_tolerance) * 3 + wall_between_modules_thickness * 4;
back_plate_width = (size + module_hole_tolerance) * 2 + wall_between_modules_thickness * 3;

module back_plate() {
    connector_tolerance = 0.15;
    connector_width = 4.05;
    connector_length = 12.05;
    connector_height = 3.06;
    connector_bottom_length = 9.85;
    connector_position = 30;

    module connector() {
        translate([0, 0, back_plate_thickness - connector_height / 2]) cube([connector_length + connector_tolerance, connector_width + connector_tolerance, connector_height], center = true);
        cube([connector_bottom_length + connector_tolerance, connector_width + connector_tolerance, total_height], center = true);
    }

    module screw_hole() {
        hull() {
            translate([0, 0, 0.01 + back_plate_thickness - (screw_head_hole_radius - screw_body_hole_radius)]) cylinder(screw_head_hole_radius - screw_body_hole_radius, screw_head_hole_radius, screw_body_hole_radius);
            cylinder(1, screw_head_hole_radius, screw_head_hole_radius);
        }
    }

    difference() {
        cube([back_plate_length, back_plate_width, back_plate_thickness]);
        for (i = [0:2]) {
            for (j = [0:1]) {
                translate([wall_between_modules_thickness + (size + module_hole_tolerance) / 2 + i * (gap), wall_between_modules_thickness + module_hole_tolerance / 2 + connector_position + j * (gap)]) connector();
            }
        }
        for (i = [0:3]) {
            for (j = [0:1]) {
                translate([i * gap, j * gap + wall_between_modules_thickness + (size + module_hole_tolerance) / 2, 0]) {
                    translate([wall_between_modules_thickness / 2, screw_hole_offset, 0]) screw_hole();
                    translate([wall_between_modules_thickness / 2, -screw_hole_offset, 0]) screw_hole();
                }
            }
        }
        for (i = [0:2]) {
            for (j = [0:2]) {
                translate([i * gap + wall_between_modules_thickness + (size + module_hole_tolerance) / 2, j * gap, 0]) {
                    translate([screw_hole_offset, wall_between_modules_thickness / 2, 0]) screw_hole();
                    translate([-screw_hole_offset, wall_between_modules_thickness / 2, 0]) screw_hole();
                }
            }
        }
        for (i = [0:1]) {
            for (j = [0:1]) {
                translate([i * back_plate_length, j * back_plate_width]) rotate([0, 0, 45]) cube([wall_between_modules_thickness, wall_between_modules_thickness, 4 * wall_between_modules_thickness], center = true);
            }
        }
    }
}

module vertical_wall(tolerance = wall_between_modules_tolerance) {
    union() {
        difference() {
            translate([wall_between_modules_corner_radius, wall_between_modules_corner_radius]) minkowski() {
                translate([0, tolerance / 2, 0]) cube([wall_between_modules_thickness - 2 * wall_between_modules_corner_radius, back_plate_width - 2 * wall_between_modules_corner_radius - tolerance, vertical_wall_height - wall_between_modules_corner_radius]);
                difference() {
                    rotate([90, 0, 0]) cylinder(2 * wall_between_modules_corner_radius, wall_between_modules_corner_radius, wall_between_modules_corner_radius, center = true);
                    translate([0, 0, - wall_between_modules_corner_radius]) cube([2 * wall_between_modules_corner_radius, 2 * wall_between_modules_corner_radius, 2 * wall_between_modules_corner_radius], center = true);
                }
            }
            for (j = [0:1]) {
                translate([0, j * gap + wall_between_modules_thickness + (size + module_hole_tolerance) / 2, 0]) {
                    translate([wall_between_modules_thickness / 2, screw_hole_offset, 0]) screw_insert_hole();
                    translate([wall_between_modules_thickness / 2, -screw_hole_offset, 0]) screw_insert_hole();
                }
            }
            for (i = [0:2]) {
                translate([0, i * gap - wall_between_modules_tolerance / 2, 0]) cube([wall_between_modules_thickness, wall_between_modules_thickness + wall_between_modules_tolerance, horizontal_wall_height + wall_between_modules_tolerance]);
            }
            for (i = [0:1]) {
                for (j = [-1:2:1]) {
                    translate([0, i * gap + j * peg_position + wall_between_modules_thickness + module_gap / 2, peg_position_height]) rotate([j * 90, 0, 0]) peg_hole(2 * wall_between_modules_thickness);
                    translate([0, i * gap + j * peg_position + wall_between_modules_thickness + module_gap / 2, peg_position_height]) rotate([j * 90, 0, 0]) peg_hole(2 * wall_between_modules_thickness);
                }
            }
        }
        for (k = [0:1]) {
            for (i = [0:1]) {
                for (j = [-1:2:1]) {
                    translate([(1 - k) * (wall_between_modules_thickness), i * gap + j * peg_position + wall_between_modules_thickness + module_gap / 2, peg_position_height]) rotate([j * 90 + k * 180, 0, k * 180]) peg();
                    translate([(1 - k) * (wall_between_modules_thickness), i * gap + j * peg_position + wall_between_modules_thickness + module_gap / 2, peg_position_height]) rotate([j * 90 + k * 180, 0, k * 180]) peg();
                }
            }
        }
    }
}

module horizontal_wall(tolerance = wall_between_modules_tolerance) {
    union() {
        difference() {
            translate([wall_between_modules_corner_radius, wall_between_modules_corner_radius]) minkowski() {
                translate([tolerance / 2, 0, 0]) cube([back_plate_length - 2 * wall_between_modules_corner_radius - tolerance, wall_between_modules_thickness - 2 * wall_between_modules_corner_radius, horizontal_wall_height - wall_between_modules_corner_radius]);
                difference() {
                    rotate([0, 90, 0]) cylinder(2 * wall_between_modules_corner_radius, wall_between_modules_corner_radius, wall_between_modules_corner_radius, center = true);
                    translate([0, 0, - wall_between_modules_corner_radius]) cube([2 * wall_between_modules_corner_radius, 2 * wall_between_modules_corner_radius, 2 * wall_between_modules_corner_radius], center = true);
                }
            }
            for (i = [0:2]) {
                translate([i * gap + wall_between_modules_thickness + (size + wall_between_modules_tolerance) / 2, 0]) {
                    translate([screw_hole_offset, wall_between_modules_thickness / 2, 0]) screw_insert_hole();
                    translate([-screw_hole_offset, wall_between_modules_thickness / 2, 0]) screw_insert_hole();
                }
            }
        }
    }
}

module outside_wall() {
    outer_wall_thickness = 4;

    height_below_back_plate = 10;
    height_above_inner_wall = 5;

    outer_wall_corner_radius_side = 10;
    outer_wall_corner_radius_top = 1.5;

    outer_wall_length = back_plate_length + 2 * outer_wall_thickness;
    outer_wall_width = back_plate_width + 2 * outer_wall_thickness;
    outer_wall_height = height_below_back_plate + back_plate_thickness + height_above_inner_wall + vertical_wall_height;

    outer_wall_screw_hole_distance_bottom = 27.5;
    outer_wall_screw_hole_distance = 13.5;
    outer_wall_screw_hole_distance_corner = 40;

    difference() {
        union() {
            translate([0, 0, outer_wall_height / 2 - back_plate_thickness - height_below_back_plate]) minkowski() {
                difference() {
                    minkowski() {
                        cube([outer_wall_length - 2 * outer_wall_corner_radius_side - 2 * outer_wall_corner_radius_top, outer_wall_width - 2 * outer_wall_corner_radius_side - 2 * outer_wall_corner_radius_top, outer_wall_height - 2 * outer_wall_corner_radius_top], center = true);
                        cylinder(0.0001, outer_wall_corner_radius_side, outer_wall_corner_radius_side);
                    }
                    minkowski() {
                        cube([outer_wall_length - 2 * outer_wall_corner_radius_side - 2 * outer_wall_thickness + 2 * outer_wall_corner_radius_top, outer_wall_width - 2 * outer_wall_corner_radius_side - 2 * outer_wall_thickness + 2 * outer_wall_corner_radius_top, outer_wall_height], center = true);
                        cylinder(0.0001, outer_wall_corner_radius_side, outer_wall_corner_radius_side);
                    }
                }
                sphere(outer_wall_corner_radius_top);
            }
            for (i = [-1:2:1]) {
                translate([- back_plate_length / 2, - wall_between_modules_thickness / 2 - i * gap]) horizontal_wall(0);
            }
            translate([- back_plate_length / 2, -back_plate_width / 2]) vertical_wall(0);
        }
        translate([outer_wall_length, 0]) cube([2 * outer_wall_length, 2 * outer_wall_width, 2 * outer_wall_height], center = true);
        for (i = [-1:2:1]) {
            for (j = [-1:2:1]) {
                translate([- outer_wall_length / 2 + outer_wall_screw_hole_distance_corner + outer_wall_screw_hole_distance / 2, i * outer_wall_width / 2, - height_below_back_plate - back_plate_thickness + outer_wall_screw_hole_distance_bottom]) rotate([i * 90, 0, 0]) screw_insert_hole();
                translate([- outer_wall_length / 2 + outer_wall_screw_hole_distance_corner - outer_wall_screw_hole_distance / 2, i * outer_wall_width / 2, - height_below_back_plate - back_plate_thickness + outer_wall_screw_hole_distance_bottom]) rotate([i * 90, 0, 0]) screw_insert_hole();
            }
        }
        for (i = [-1:2:1]) {
            for (j = [-1:2:1]) {
                translate([- outer_wall_length / 2, i * outer_wall_width / 2 - i * outer_wall_screw_hole_distance_corner + j * outer_wall_screw_hole_distance / 2, - height_below_back_plate - back_plate_thickness + outer_wall_screw_hole_distance_bottom]) rotate([0, 90, 0]) screw_insert_hole();
            }
        }
    }
}

%back_plate();
*vertical_wall();
*horizontal_wall();
outside_wall();