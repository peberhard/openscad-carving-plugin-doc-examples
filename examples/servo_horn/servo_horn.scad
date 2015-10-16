// Horn for Hitec servo

$fn = 24;
t1r = 1.5; // radius of the tool T1 in mm
mt = 3;    // material thickness in mm

// Definition of the tools
carving_settings(tool_change_height=35);
carving_tool(tool_number=1, name="T1" , diameter=t1r*2);
carving_tool(tool_number=2, name="T2" , diameter=2.5);
carving_tool_speed(tool="T1", material="alu", spindle_speed=7000, feedrate=150, step_down=mt);
carving_tool_speed(tool="T2", material="alu", spindle_speed=7000, feedrate=150, step_down=mt);
//*/

l = 101;
r = 26/2;
w = 12;
servo_screw_r = 17.7 / 2;
servo_hole_in_d = 7.9;

module servo_horn() {
    // servo holes using 2.5mm drill end
    for(angle = [ 0 : 45 : 315])
        carving_drill("T2",[servo_screw_r * sin(angle), servo_screw_r * cos(angle)]);

    for(i = [20 : 10 : 100])
        carving_drill("T2",[i,0]);

    // inside cut using 3mm end-mill
    carving_path2d("T1",[-(servo_hole_in_d/2-t1r),0]) {
        carving_arc([-(servo_hole_in_d/2-t1r),0], [0,0]);
    }

    // outisde cut using 3mm end-mill
    carving_path2d("T1",[sqrt((r+t1r)*(r+t1r)-w/2*w/2),-w/2], "horn", [10, 0]) {
        carving_arc([sqrt((r+t1r)*(r+t1r)-w/2*w/2),+w/2], [0,0]);
        carving_line([l, w/2]);
        carving_arc([l, -w/2], [l, 0]);
        carving_line([sqrt((r+t1r)*(r+t1r)-w/2*w/2),-w/2]);
    }
}

// definition of the worpiece with the servo horn in it.
// Render milling path with View -> Carving -> Render Milling Path, F5
// Render carving result with View -> Carving -> Render Carving Result, F5
carving_workpiece([l+35, w+30], "alu", mt) {
    translate([20, 20]) servo_horn(tool1=false, tool2=true);
}

// extraction of the part in assembly mode (View -> Carving -> Extract parts for Assembly, F5)
carving_assembly() {
    carving_part("horn");
}
