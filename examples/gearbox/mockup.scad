// This is an example of a simple planetary gearbox, with a motor mount and
// a housing.
use <../../planetary.scad>;
use <../../PolyGear/PolyGear.scad>;
use <catchnhole/catchnhole.scad>;

$fn = 75;

explode = true;
e = explode ? 10 : 0;
// 8.6
// 11.5

housing = true;
carriers = true;
ring = true;

ring_teeth = 46;
sun_teeth = 16;
planets = 5;
planet_carrier_h = 4.4;
planet_carrier_planet_r = 4;
planet_carrier_nut_height_clearance = 1.4;
height = 8;
ring_housing_thickness = 10;
standoff_d = 5;
output_gear_h = 20;
bolt = "M3";

press_fit = 0.05;
gearbox_housing_fit = 0.1;

planet_bearing_h = 5;
planet_bearing_od = 9;
planet_bolt_l = planet_carrier_h * 2 + height + gearbox_housing_fit;

housing_output_h = 2;
housing_input_h = 6;
housing_carrier_clearance = 0.25;

engine_shaft_d = 1.5;
engine_bolt = "M2";
engine_bolt_d = 10;

mount_bolt_l = height + gearbox_housing_fit + housing_input_h + housing_output_h;

module housing_base (ring_teeth, sun_teeth, height, ring_housing_thickness, planets, planet_carrier_planet_r, housing_carrier_clerance, housing_h, bolt, length) {
  planet_teeth = planetary_planet_teeth(ring_teeth, sun_teeth);

  difference () {
    union () {
      cylinder(d = ring_teeth + ring_housing_thickness, h = housing_h);
      to_mounts(ring_teeth, ring_housing_thickness) {
        cylinder(d = standoff_d, h = housing_h);
      }
    }

    translate([0, 0, housing_h])
      rotate([180,0,0])
        cylinder(d = sun_teeth + planet_teeth + planet_carrier_planet_r * 2 + housing_carrier_clearance, h = planet_carrier_h + housing_carrier_clerance);

    mounting_bolts(ring_teeth, height, ring_housing_thickness, bolt, mount_bolt_l);
  }

}

module housing_input (ring_teeth, sun_teeth, height, ring_housing_thickness, planets, planet_carrier_planet_r, housing_carrier_clerance, bolt, length) {
  housing_base(ring_teeth, sun_teeth, height, ring_housing_thickness, planets, planet_carrier_planet_r, housing_carrier_clerance, housing_input_h, bolt, length);
}

module housing_output (ring_teeth, sun_teeth, height, ring_housing_thickness, planets, planet_carrier_planet_r, housing_carrier_clerance, bolt, length) {
  rotate([180, 0, 0]) {
    difference () {
      housing_base(ring_teeth, sun_teeth, height, ring_housing_thickness, planets, planet_carrier_planet_r, housing_carrier_clerance, housing_output_h, bolt, length);
    }
  }
}

module carrier_bolts (ring_teeth, sun_teeth, height, planets, bolt, length) {
  planetary_for_each_planet(ring_teeth, sun_teeth, height, planets) {
    bolt(bolt, length, kind = "socket_head", countersink = 0.75);
  }
}

module carrier_nuts (ring_teeth, sun_teeth, height, planets, bolt, height_clearance = 0) {
  planetary_for_each_planet(ring_teeth, sun_teeth, height, planets) {
    nutcatch_parallel(bolt, height_clearance = height_clearance);
  }
}

module planetary_carrier_input (ring_teeth, sun_teeth, height, planets, planet_carrier_h, planet_carrier_planet_r, input_clearance) {
  difference () {
    planetary_carrier_base(ring_teeth, sun_teeth, height, planets, planet_carrier_h, planet_carrier_planet_r);
    carrier_bolts(ring_teeth, sun_teeth, height, planets, bolt, planet_bolt_l);
    carrier_nuts(ring_teeth, sun_teeth, height, planets, bolt, planet_carrier_nut_height_clearance);
    cylinder(d = input_clearance, h = planet_carrier_h);
  }
}

module planetary_carrier_output (ring_teeth, sun_teeth, height, planets, planet_carrier_h, planet_carrier_planet_r) {
  difference () {
    planetary_carrier_base(ring_teeth, sun_teeth, height, planets, planet_carrier_h, planet_carrier_planet_r);

    translate([0, 0, -planet_bolt_l+planet_carrier_h ]) {
      carrier_bolts(ring_teeth, sun_teeth, height, planets, bolt, planet_bolt_l);
    }
  }

  translate([0, 0, planet_carrier_h + height / 2]) {
    spur_gear(n=sun_teeth, z=height);
  }
}

module planetary_carrier_base (ring_teeth, sun_teeth, height, planets, planet_carrier_h, planet_carrier_planet_r) {
  planet_teeth = planetary_planet_teeth(ring_teeth, sun_teeth);
  d = sun_teeth + planet_teeth / 2;
  planet_angle = 360/planets;

  linear_extrude(planet_carrier_h) {
    hull () {
      planetary_for_each_planet(ring_teeth, sun_teeth, height, planets) {
        circle(r = planet_carrier_planet_r);
      }
    }
  }
}

module to_mounts (ring_teeth, ring_housing_thickness) {
  angle = 360 / 4;
  for (i = [0 : 3]) {
    rotate([0, 0, 45 + angle * i]) {
      translate([(ring_teeth + ring_housing_thickness) / 2, 0])
        children();
    }
  }
}

module mounting_bolts (ring_teeth, height, ring_housing_thickness, bolt, bolt_length) {
  to_mounts(ring_teeth, ring_housing_thickness) {
    bolt(bolt, length = bolt_length);
  }
}

module planetary_ring_with_mounts (ring_teeth, sun_teeth, height, ring_housing_thickness, planets, bolt, standoff_d) {
  difference () {
    union () {
      planetary_ring(ring_teeth, sun_teeth, height, ring_housing_thickness, planets);

      translate([0, 0, -height / 2]) {
        to_mounts(ring_teeth, ring_housing_thickness) {
          cylinder(d = standoff_d, h = height);
        }
      }
    }


    translate([0, 0, -height / 2])
      mounting_bolts(ring_teeth, height, ring_housing_thickness, bolt, mount_bolt_l);
  }
}

planetary_sun(ring_teeth, sun_teeth, height, planets);

if (ring) {
  planetary_ring_with_mounts(ring_teeth, sun_teeth, height + gearbox_housing_fit, ring_housing_thickness, planets, bolt, standoff_d);
}

if (housing) {
  translate([0, 0, -height / 2 - housing_input_h - 2 * e]) {
    housing_input(ring_teeth, sun_teeth, height, ring_housing_thickness, planets, planet_carrier_planet_r, housing_carrier_clearance, bolt, 20);
  }

  translate([0, 0, (height + gearbox_housing_fit) / 2 + 2 * e]) {
    housing_output(ring_teeth, sun_teeth, height, ring_housing_thickness, planets, planet_carrier_planet_r, housing_carrier_clearance, bolt, 20);
  }
}

translate([0, 0, gearbox_housing_fit / 2]) {
  planetary_planets(ring_teeth, sun_teeth, height, planets) {
    union(){};
    translate([0, 0, -height / 2])
      cylinder(d = planet_bearing_od, h = planet_bearing_h);
  }
}

if (carriers) {
  translate([0, 0, -height / 2 - planet_carrier_h - e]) {
    planetary_carrier_input(ring_teeth, sun_teeth, output_gear_h, planets, planet_carrier_h, planet_carrier_planet_r, sun_teeth);
  }

  translate([0, 0, height / 2 + gearbox_housing_fit + e]) {
    planetary_carrier_output(ring_teeth, sun_teeth, output_gear_h, planets, planet_carrier_h, planet_carrier_planet_r);
  }
}

translate([0, 0, gearbox_housing_fit / 2]) {
  planetary_planets(ring_teeth, sun_teeth, height, planets) {
    union(){};
    translate([0, 0, -height / 2])
      cylinder(d = planet_bearing_od, h = planet_bearing_h);
  }
}
