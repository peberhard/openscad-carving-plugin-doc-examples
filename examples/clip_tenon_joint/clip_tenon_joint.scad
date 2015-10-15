
$fn = 3;  // speed up rendering
t1r = 1.5; // radius of the tool T1
mt = 4.8;  // material thickness
step_down = mt/2; // note: if step_down=(mt-0.6)/2 then 3 passes: 2.1, 2.1 then 0.6

carving_settings(tool_change_height=35);
carving_tool(tool_number=1, name="T1" , diameter=t1r*2);
carving_tool_speed(tool="T1", material="wood", spindle_speed=7000, feedrate=400, step_down=step_down);
    
clip_out = ((mt-2*t1r)+4*t1r);
clip_width = 4*t1r + 2*t1r;
clip_dx = mt;
clip_hole_l = 4*t1r;
clip_hole_w = mt + 0.2; // small offset required too let the clip get through
clip_coef = 0.50;

box_length = 90;   // external mesures of the box
box_width  = 70;
box_height = 60;
front_length = box_length - 2*mt;
front_width = box_height;
front_v = [mt-clip_out, mt, 0];
left_length = box_width;
left_width = box_height;
left_v = [0, 0, 0];


/* position of the parts in the workpiece */
margin = 6;
workpiece_length = 200;
workpiece_width = 80;

front_in_wp = [margin + clip_out, margin];
left_in_wp = front_in_wp + [ 2*margin + front_length + clip_out, 0];

module clip() {
    translate([-3*t1r,0]) {
        w_out = (mt-2*t1r);
        w_in = mt*6;
        carving_line([ t1r, 0]);
        carving_line([ t1r, -w_in]);
        carving_line([ t1r, w_out]);
        carving_line([-t1r, w_out]);
        carving_line([-t1r, w_out+4*t1r-2*t1r]);
        carving_arc( [-t1r+2*t1r, w_out+4*t1r], [-t1r+2*t1r, w_out+4*t1r-2*t1r]);
        carving_line([5*t1r-2*t1r, w_out+4*t1r]);
        carving_arc([5*t1r, w_out+4*t1r-2*t1r], [5*t1r-2*t1r, w_out+4*t1r-2*t1r]);
        carving_line([5*t1r, w_out]);
        carving_line([5*t1r, -w_in]);
        carving_line([5*t1r, 0]);
    }
}

module clip_hole() {
    l = clip_hole_l/2;
    w = clip_hole_w/2-t1r;
    carving_path2d("T1", [l, w]) {
        carving_line([ l, -w]);
        carving_line([-l, -w]);
        carving_line([-l, w]);
        carving_line([ l, w]);
    }
}

module front_and_back(id) {
    l = front_length/2 + t1r;
    w = front_width/2 + t1r;
    translate([l, w]) {
        carving_path2d("T1",[l, w], id=id) {
            translate([+l,+w*clip_coef]) rotate([0,0,-90]) clip();
            translate([+l,-w*clip_coef]) rotate([0,0,-90]) mirror(1,0,0) carving_reverse() clip();
            carving_line([ l, -w]);
            carving_line([-l, -w]);
            translate([-l,-w*clip_coef]) rotate([0,0,90]) clip();
            translate([-l,+w*clip_coef]) rotate([0,0,90]) mirror(1,0,0) carving_reverse() clip();
            carving_line([-l,  w]);
            carving_line([ l,  w]);
        }
    }
}

module front() {
    front_and_back("front");
}

module left() {
    l = left_length/2 + t1r;
    w = left_width/2 + t1r;
    left_clip_dx = clip_dx + mt/2 + t1r;
    translate([l, w]) {
        translate([-(l-left_clip_dx),+(front_width*clip_coef /*+ t1r*/) * 2/4])  rotate([0,0,90]) clip_hole();
        translate([-(l-left_clip_dx),-(front_width*clip_coef /*+ t1r*/) * 2/4])  rotate([0,0,90]) clip_hole();
        translate([+(l-left_clip_dx),+(front_width*clip_coef /*+ t1r*/) * 2/4])  rotate([0,0,90]) clip_hole();
        translate([+(l-left_clip_dx),-(front_width*clip_coef /*+ t1r*/) * 2/4])  rotate([0,0,90]) clip_hole();
        carving_path2d("T1",[l, w], id="left") {
            carving_line([ l, -w]);
            carving_line([-l, -w]);
            carving_line([-l,  w]);
            carving_line([ l,  w]);
        }
    }
}

carving_workpiece([workpiece_length, workpiece_width], "wood", thickness=mt) {

    translate(front_in_wp) front();
    translate(left_in_wp) left();
}

carving_assembly() {
    translate(front_v + [front_length+2*clip_out, 0, 0]) rotate([90, 0, 180])  carving_part("front");
%    translate(left_v) rotate([90,0,90]) carving_part("left");
}
