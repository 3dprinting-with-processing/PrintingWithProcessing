M10000
M10000
M10001 X8 Y28 SDoodle3D heat up...
M109 S210       ;set target temperature
G21             ;metric values
G90             ;absolute positioning
M107            ;start with the fan off
G28             ;home to endstops
G1 Z15 F9000    ;move the platform down 15mm
G92 E0          ;zero the extruded length
G1 F200 E10     ;extrude 10mm of feed stock
G92 E0          ;zero the extruded length again
G1 F9000
M10000
M10000
M10001 X8 Y28 SDoodle3D printing...
M106