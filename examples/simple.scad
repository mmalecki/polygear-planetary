use <../planetary.scad>;

ring_teeth = 40;
sun_teeth = 18;
planets = 5;
height = 10;
ring_housing_thickness = 10;

planetary_sun(ring_teeth, sun_teeth, height, planets);
planetary_ring(ring_teeth, sun_teeth, height, ring_housing_thickness, planets);
planetary_planets(ring_teeth, sun_teeth, height, planets);
