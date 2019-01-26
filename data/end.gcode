M10000
M10000
M10001 X20 Y28 SDoodle3D done!
M107 ;fan off
G91 ;relative positioning
G1 E-1 F300 ;retract the filament a bit before lifting the nozzle, to release some of the pressure
G1 Z+5.5 E-5 X-20 Y-20 F9000 ;move Z up a bit and retract filament even more
G28 ;home the printer
M84 ;disable axes / steppers
G90 ;absolute positioning
;M104 S0