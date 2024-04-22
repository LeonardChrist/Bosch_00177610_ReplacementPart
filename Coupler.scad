$fn = 64;

pinSize = 4.15 * 1.02;
pinLength = 13.17 * 1.02;
pinTwist = 45;

mainDiskDiameter = 29.12;
mainDiskHeight = 1.61 * 0.95;

trenchDiameter = 8.87 * 1.02;
trenchDepth = 1.36 * 1.02;

surfaceRingOuterDiameter = 23.89;
surfaceRingInnerDiameter = 21.98;
surfaceRingHeight = 1.83 * 1.02 - mainDiskHeight;

plateauDiameter = 17.95 * 1.02;
plateauHeight = 2.5 * 1.02 - mainDiskHeight;


gearPinOuterDiameter = 5.4 * 0.90;
gearPinInnerDiameter = gearPinOuterDiameter - 1.5 * 1.02 * 2;
gearPinHeight = 13.66 * 1.02;

gearPinOuterDiameterAtCutout = 4.42 * 0.95;
gearPinCutoutOffset = gearPinOuterDiameter / 2 - (gearPinOuterDiameter - gearPinOuterDiameterAtCutout);

gearDiameter = 9.8; //7.13 * 1.02 * 2 - gearPinOuterDiameter; // 7.13 measured
gearHeight = 6.24 * 1.02 - mainDiskHeight - plateauHeight;


gearToothLength = 7.15 * 1.02;
gearToothTipDiameter = 1.2 * 1.02;

gearToothCubeLength = gearToothLength - gearToothTipDiameter / 2;

lastGearToothRadius = 4.26 * 1.02;
lastGearToothLength = 8.83 * 1.02;

lastGearToothCubeLength = lastGearToothLength - lastGearToothRadius;


// pin
translate([0, 0, (pinLength + trenchDepth) / 2]) rotate([0, 0, pinTwist]) cube([pinSize, pinSize, pinLength + trenchDepth], center = true);

translate([0, 0, pinLength]) {
    difference() {
        // main disk
        cylinder(d = mainDiskDiameter, h = mainDiskHeight);

        // trench cutout
        translate([0, 0, -0.1]) cylinder(d = trenchDiameter, h = trenchDepth);
    }

    translate([0, 0, mainDiskHeight]) {
        difference() {
            // outer surface ring
            cylinder(d = surfaceRingOuterDiameter, h = surfaceRingHeight);
            
            // inner surface ring cutout
            cylinder(d = surfaceRingInnerDiameter, h = surfaceRingHeight + 0.01);
        }

        difference() {
            union() {
                // plateau
                cylinder(d = plateauDiameter, h = plateauHeight);

                translate([0, 0, plateauHeight]) {
                    // gear cylinder
                    cylinder(d = gearDiameter, h = gearHeight);

                    // gear teeth
                    gearTeeth();
                    translate([0, 0, gearHeight]) difference() {
                        // main outer gear pin
                        cylinder(d = gearPinOuterDiameter, h = gearPinHeight);

                        // gear pin cut out
                        rotate([0, 0, pinTwist]) translate([0, gearPinHeight / 2+ gearPinCutoutOffset, gearHeight / 2]) cube([gearPinHeight * 2, gearPinHeight, gearPinHeight * 3 + 0.01], center = true);                        
                    }
                }
            }

            // inner gear pin cutout
            cylinder(d = gearPinInnerDiameter, h = gearPinHeight + plateauHeight + gearHeight + 0.01);
        }
    }
}





module gearTeeth() {

    module gearTooth(tipDiameter = gearToothTipDiameter) {
        translate([0, gearToothCubeLength  / 2, gearHeight / 2]) {
            cube([tipDiameter, gearToothCubeLength, gearHeight], center = true);
            translate([0, gearToothCubeLength / 2, 0]) cylinder(d = tipDiameter, h = gearHeight, center = true);
        }
    }

    for(i = [0:4]) {
        if(i == 0) {
            newTipDiameter = gearToothTipDiameter * 1.3;
            rotate([0, 0, i * -360 / 12]) translate([0, -(newTipDiameter - gearToothTipDiameter), 0]) gearTooth(tipDiameter = newTipDiameter);
        } else {
            rotate([0, 0, i * -360 / 12]) gearTooth();
        }
    }

    rotate([0, 0, 180 - 5]) translate([gearToothTipDiameter / 2, lastGearToothCubeLength / 2, gearHeight / 2]) {
        difference() {
            union() {
                cube([lastGearToothRadius * 2, lastGearToothCubeLength, gearHeight], center = true);
                translate([0, lastGearToothCubeLength / 2, 0]) cylinder(r = lastGearToothRadius, h = gearHeight, center = true);
            }
            translate([lastGearToothRadius, 0, 0]) cube([lastGearToothRadius * 2, lastGearToothLength * 2, gearHeight + 0.01], center = true);
            
        }
    }

}