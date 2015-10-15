
$fn = 3;   // speed up rendering
t1r = 1.5; // radius of the tool T1
mt = 4.8;  // material thickness
step_down = mt; // note: if step_down=(mt-0.6)/2 then 3 passes: 2.1, 2.1 then 0.6

carving_settings(tool_change_height=35);
carving_tool(tool_number=1, name="T1" , diameter=t1r*2);
carving_tool_speed(tool="T1", material="wood", spindle_speed=7000, feedrate=400, step_down=step_down);

slot_depth = mt / 2;
slot_w =  mt + 0.2; // small offset required too let the top and botton parts to slice in

clip_out = ((mt-2*t1r)+4*t1r);
clip_width = 4*t1r + 2*t1r;
clip_dx = mt;
clip_hole_l = 4*t1r;
clip_hole_w = mt + 0.2; // small offset required too let the clip get through
clip_coef = 0.50;

box_length = 90;   // external mesures of the box
box_width  = 70;
box_height = 60;
top_length = box_length - (mt - slot_depth);
top_width = box_width - 2*(mt - slot_depth) - (clip_dx) * 2;
top_v = [ mt - slot_depth, (mt - slot_depth + clip_dx), box_height - mt*1.5 ];
top_mid_v = [ mt - slot_depth + box_length/2, mt - slot_depth, box_height - 2*mt ];
bottom_length = box_length - 2*(mt - slot_depth);
bottom_width = box_width - 2*(mt - slot_depth) - (clip_dx) * 2;
bottom_v = [ mt - slot_depth, (mt - slot_depth + clip_dx), mt * 0.5 ];
front_length = box_length - 2*mt;
front_width = box_height;
front_v = [mt-clip_out, mt, 0];
back_length = front_length;
back_width = front_width;
back_v = [mt-clip_out, box_width-2*mt, 0];
left_length = box_width;
left_width = box_height;
left_v = [0, 0, 0];
right_length = box_width;
right_width = box_height - 1.5*mt - 0.2;
right_v = [box_length-mt, 0, 0];

echo ("top_v", top_v);

/* position of the parts in the workpiece */
margin = 6;
workpiece_length = 200;
workpiece_width = 210;

front_in_wp = [margin + clip_out, margin];
left_in_wp = front_in_wp + [margin + top_length + clip_out, 0];

back_in_wp = front_in_wp + [0, 1 * margin + 3*t1r + front_width];
right_in_wp = back_in_wp + [margin + 4*t1r + back_length + clip_out, 0];

bottom_in_wp = [margin, 2*(2 * margin + 1*t1r + front_width)];
top_in_wp = bottom_in_wp + [ margin + 4*t1r + bottom_length, 0];

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

module slot(length)
 {
    l = length / 2 + t1r;
    w = slot_w/2 - t1r;
    translate([l, 0]) {
        carving_path2d("T1", [l, w], thickness = slot_depth) {
            carving_line([ l, -w]);
            carving_line([-l, -w]);
            carving_line([-l, w]);
            carving_line([ l, w]);
        }
    }
 }
 
module top()
{
    l = top_length/2 + t1r;
    w = top_width/2 + t1r;
    translate([l, w]) {
        carving_path2d("T1",[l, w], id="top", pos=[-l+t1r,-w+t1r]) {
            carving_line([ l, -w]);
            carving_line([-l, -w]);
            carving_line([-l, w]);
            carving_line([ l, w]);
        }
    }
 }

module bottom()
{
    l = bottom_length/2 + t1r;
    w = bottom_width/2 + t1r;
    translate([l, w]) {
        carving_path2d("T1",[l, w], id="bottom", pos=[-l+t1r,-w+t1r]) {
            carving_line([ l, -w]);
            carving_line([-l, -w]);
            carving_line([-l,  w]);
            carving_line([ l,  w]);
        }
    }
}

module front_and_back(id) {
    l = front_length/2 + t1r;
    w = front_width/2 + t1r;
    translate([0, t1r+mt]) slot(front_length);
    translate([0, t1r+front_width-mt]) slot(front_length);
    translate([l, w]) {
        carving_path2d("T1",[l, w], id=id, pos=[-l+t1r,-w+t1r]) {
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

module back() {
    front_and_back("back");
}

module left() {
    l = left_length/2 + t1r;
    w = left_width/2 + t1r;
    left_clip_dx = clip_dx + mt/2 + t1r;
    translate([left_clip_dx, t1r+mt]) slot(left_length-left_clip_dx*2);
    translate([left_clip_dx, t1r+left_width-mt]) slot(left_length-left_clip_dx*2);
    translate([l, w]) {
        translate([-(l-left_clip_dx),+(front_width*clip_coef /*+ t1r*/) * 2/4])  rotate([0,0,90]) clip_hole();
        translate([-(l-left_clip_dx),-(front_width*clip_coef /*+ t1r*/) * 2/4])  rotate([0,0,90]) clip_hole();
        translate([+(l-left_clip_dx),+(front_width*clip_coef /*+ t1r*/) * 2/4])  rotate([0,0,90]) clip_hole();
        translate([+(l-left_clip_dx),-(front_width*clip_coef /*+ t1r*/) * 2/4])  rotate([0,0,90]) clip_hole();
        carving_path2d("T1",[l, w], id="left", pos=[-l+t1r,-w+t1r]) {
            carving_line([ l, -w]);
            carving_line([-l, -w]);
            carving_line([-l,  w]);
            carving_line([ l,  w]);
        }
    }
}

module right() {
    l = right_length/2 + t1r;
    w = right_width/2 + t1r;
    right_clip_dx = clip_dx + mt/2 + t1r;
    translate([right_clip_dx, t1r+mt]) slot(right_length-right_clip_dx*2);
    translate([left_length/2 + t1r, left_width/2 + t1r]) {
        translate([-(l-right_clip_dx),+(front_width*clip_coef) * 2/4])  rotate([0,0,90]) clip_hole();
        translate([-(l-right_clip_dx),-(front_width*clip_coef) * 2/4])  rotate([0,0,90]) clip_hole();
        translate([+(l-right_clip_dx),+(front_width*clip_coef) * 2/4])  rotate([0,0,90]) clip_hole();
        translate([+(l-right_clip_dx),-(front_width*clip_coef) * 2/4])  rotate([0,0,90]) clip_hole();
    }
    translate([l, w]) {
        carving_path2d("T1",[l, w], id="right", pos=[-l+t1r,-w+t1r]) {
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
    translate(back_in_wp) back();
    translate(right_in_wp) right();
    translate(top_in_wp) top();
    translate(bottom_in_wp) bottom();
}


carving_assembly() {
%   translate(front_v + [front_length+2*clip_out, 0, 0]) rotate([90, 0, 180]) carving_part("front");
    translate(left_v) rotate([90,0,90]) carving_part("left");
    translate(back_v + [0, mt]) rotate([90,0,0]) carving_part("back");
    translate(right_v + [mt, right_length]) rotate([90,0,-90]) carving_part("right");
#   translate([2.4, 7.2, 52.8] + [30, 0, 0]) carving_part("top");
%   translate(bottom_v) carving_part("bottom");
}
