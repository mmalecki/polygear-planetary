// This is an example of a simple planetary gearbox, with a motor mount and
// a housing.
use <../planetary.scad>;
use <../PolyGear/PolyGear.scad>;

$fn = 75;

ring_teeth = 40;
sun_teeth = 18;
planets = 5;
planet_carrier_height = 2;
planet_carrier_planet_r = 4;
height = 10;
ring_housing_thickness = 10;

module planetary_carrier_output (ring_teeth, sun_teeth, height, planets, planet_carrier_height, planet_carrier_planet_r) {
  planetary_carrier_base(ring_teeth, sun_teeth, height, planets, planet_carrier_height, planet_carrier_planet_r);

  translate([0, 0, planet_carrier_height]) {
    spur_gear(n=sun_teeth, z=height);
  }
}

module planetary_carrier_base (ring_teeth, sun_teeth, height, planets, planet_carrier_height, planet_carrier_planet_r) {
  planet_teeth = planetary_planet_teeth(ring_teeth, sun_teeth);
  d = sun_teeth + planet_teeth / 2;
  planet_angle = 360/planets;

  linear_extrude(planet_carrier_height) {
    hull () {
      planetary_for_each_planet(ring_teeth, sun_teeth, height, planets) {
        circle(r = planet_carrier_planet_r);
      }
    }
  }
}

planetary_sun(ring_teeth, sun_teeth, height, planets);
planetary_ring(ring_teeth, sun_teeth, height, ring_housing_thickness, planets);

planetary_planets(ring_teeth, sun_teeth, height, planets);
translate([0, 0, height / 2]) {
  planetary_carrier_output(ring_teeth, sun_teeth, height, planets, planet_carrier_height, planet_carrier_planet_r);
}
