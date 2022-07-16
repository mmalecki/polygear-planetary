# polygear-planetary
A library on top of [PolyGear](https://github.com/dpellegr/PolyGear) to generate planetary gearboxes. It allows you
to pass in a single planetary gearbox definition, and aligns all its components
in a common coordinate system.

## Usage

### `options` - a planetary gearbox definition
* `ring_teeth` - number of ring teeth
* `sun_teeth` - number of sun teeth
* `planets` - number of planet gears

### `planetary_sun(ring_teeth, sun_teeth, height, planets = 3)`
### `planetary_ring(ring_teeth, sun_teeth, height, ring_housing_thickness, planets = 3, ring_backlash = -0.1, ring_add = 0.1, ring_ded = -0.2)`
### `planetary_planets(options)`
Draws the planets.

Accepts two children: addition and difference. When passed, applies these to
each planet gear.
