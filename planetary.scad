use <PolyGear/PolyGear.scad>;
use <PolyGear/shortcuts.scad>;

// A lot of this is straight up stolen from PolyGear's examples.

DEFAULT_PLANETS = 3;
DEFAULT_RING_BACKLASH = -0.1;
DEFAULT_RING_ADD = 0.1;
DEFAULT_RING_DED = -0.2;

function planetary_planet_teeth (ring_teeth, sun_teeth) = (ring_teeth - sun_teeth) / 2;

module planetary_validate (ring_teeth, sun_teeth) {
  planet_teeth = planetary_planet_teeth(ring_teeth, sun_teeth);

  assert(
    planet_teeth == round(planet_teeth),
    "ring_teeth and sun_teeth have to be both even or both odd"
  );
}

module planetary_sun (
  ring_teeth,
  sun_teeth,
  height,
  planets = DEFAULT_PLANETS,
) {
  planetary_validate(ring_teeth, sun_teeth);
  planet_teeth = planetary_planet_teeth(ring_teeth, sun_teeth);
  Rz(180 / sun_teeth * ((planet_teeth+1)%2))
    spur_gear(n=sun_teeth, z=height);
}

module planetary_ring (
  ring_teeth,
  sun_teeth,
  height,
  ring_housing_thickness,
  planets = DEFAULT_PLANETS,
  ring_backlash = DEFAULT_RING_BACKLASH,
  ring_add = DEFAULT_RING_ADD,
  ring_ded = DEFAULT_RING_DED,
) {
  planetary_validate(ring_teeth, sun_teeth);
  // Cutting the ring gear, note that the backlash (which defaults to 0.1) here is negative.
  // Addendum and dedendum are also given to add some clearance
  D() {
    Cy(h=height, d=ring_teeth+ring_housing_thickness);
    spur_gear(n=ring_teeth, z=height, backlash=ring_backlash, add = ring_add, ded = ring_ded);
  }
}

module planetary_for_each_planet (ring_teeth, sun_teeth, height, planets = DEFAULT_PLANETS) {
  planetary_validate(ring_teeth, sun_teeth);
  planet_teeth = planetary_planet_teeth(ring_teeth, sun_teeth);
  planet_angle = 360/planets;

  // Now doing the planets
  // To properly place the planets without tooth interference, theta is computed.
  // It may slightly deviate from planet_angle depending on the numeber of teeth and planets.
  for (i=[0:planets-1]) {
    theta = round(i*planet_angle*(ring_teeth + sun_teeth)/360)* (360/(ring_teeth+sun_teeth));
    Rz(theta)
      Tx((sun_teeth+planet_teeth)/2) 
        Rz(theta*sun_teeth/planet_teeth) {
          children();
        }
  }
}

module planetary_planets (ring_teeth, sun_teeth, height, planets = DEFAULT_PLANETS) {
  planetary_validate(ring_teeth, sun_teeth);
  planet_teeth = planetary_planet_teeth(ring_teeth, sun_teeth);
  planetary_for_each_planet(ring_teeth, sun_teeth, height, planets) {
    difference () {
      union () {
        spur_gear(n=planet_teeth, z=height);
        if ($children > 0) children(0);
      }

      if ($children > 1) children(1);
    }
  }
}
