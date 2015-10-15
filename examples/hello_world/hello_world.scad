// Simple example

$fn = 12;
t1r = 1.5; // radius of the tool T1 in mm
mt = 3;    // material thickness in mm

// Definition of the tools
carving_settings(tool_change_height=35);
carving_tool(tool_number=1, name="T1" , diameter=t1r*2);
carving_tool(tool_number=2, name="T2" , diameter=2.5);
carving_tool_speed(tool="T1", material="wood", spindle_speed=7000, feedrate=400, step_down=mt);
carving_tool_speed(tool="T2", material="wood", spindle_speed=7000, feedrate=400, step_down=mt);

part1_length = 50;
part1_width = 30;

// Definition of part1
module part1() {
    l = part1_length / 2;
    w = part1_width / 2;

    for( i = [10:10:50]) 
        carving_drill("T2", [i, w]);
    
    translate([l, w]) {
        carving_path2d("T1",[l, w], id="part1") {
            carving_arc([ l, -w], [l*3/4, 0]);
            carving_line([-l, -w]);
            carving_line([-l,  w]);
            carving_line([ l,  w]);
        }
    }
}

// Render milling path with View -> Carving -> Render Milling Path, F5
// Render carving result with View -> Carving -> Render Carving Result, F5
carving_workpiece([100, 50], "wood", thickness=mt) {
    translate([10,10]) part1();
}

// Assembly with only part1 (View -> Carving -> Extract parts for Assembly, F5)
carving_assembly() {
    carving_part("part1");
}
