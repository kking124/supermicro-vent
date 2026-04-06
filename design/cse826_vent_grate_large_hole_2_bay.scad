// Supermicro CSE-826 Hot-Swap Bay Vent Grate — Tall (77mm, 3x rail sets)
// Print in PETG, 0.2mm layers, 3 walls, 20% infill, no supports needed

// ── Dimensions ───────────────────────────────────────────────────
bay_w      = 106.0;   // bay opening width (mm)
bay_h      =  55.0;   // bay opening height (mm) — 3 bays tall
face_t     =   3.0;   // faceplate thickness
rail_t     =   6.0;   // side rail thickness
rail_d     =  36.0;   // depth rails extend into bay
rail_h     =  27.0;   // height of each individual rail set
rail_gap   =   1.0;   // gap between rail sets
border     =   4.0;   // solid border around vent cutouts

// ── Groove (runs along outside face of each rail) ─────────────────
groove_h   =   8.0;   // groove height
groove_d   =   2.0;   // groove depth
groove_y   =   4.0;   // offset from bottom of each rail set
tab_d      =   25.0;  // offset of back tab to prevent rubbing

// ── Honeycomb ────────────────────────────────────────────────────
hex_cr     =   4.0;   // circumradius of each hexagon
hex_gap    =   1.0;   // gap between hex cell edges

hex_ir      = hex_cr * cos(30);
hex_pitch_x = (hex_ir + hex_gap/2) * 2;
hex_pitch_y = hex_pitch_x * sin(60);

// ─────────────────────────────────────────────────────────────────

vent_x0 = border;
vent_y0 = border;
vent_w  = bay_w - border * 2;
vent_h  = bay_h - border * 2;

// Centre honeycomb grid within vent area
cols_fit = floor(vent_w / hex_pitch_x);
rows_fit = floor(vent_h / hex_pitch_y);
offset_x = (vent_w - cols_fit * hex_pitch_x) / 2;
offset_y = (vent_h - rows_fit * hex_pitch_y) / 2;

module hex_cell(h) {
    rotate([0, 0, 30])
        cylinder(r = hex_cr, h = h, $fn = 6);
}

module honeycomb(w, h, depth) {
    cols = ceil(w / hex_pitch_x) + 2;
    rows = ceil(h / hex_pitch_y) + 2;
    for (row = [0 : rows]) {
        for (col = [0 : cols]) {
            cx = offset_x + col * hex_pitch_x
                 + (row % 2 == 1 ? hex_pitch_x / 2 : 0)
                 - hex_pitch_x;
            cy = offset_y + row * hex_pitch_y - hex_pitch_y;
            if (   cx + hex_cr > 0 && cx - hex_cr < w
                && cy + hex_cr > 0 && cy - hex_cr < h)
                translate([cx, cy, -0.1])
                    hex_cell(depth + 0.2);
        }
    }
}

// One rail set (left+right pair) at a given y offset
module rail_set(y_offset) {
    // Left rail
    translate([0, y_offset, face_t])
        cube([rail_t, rail_h, rail_d]);
    // Right rail
    translate([bay_w - rail_t, y_offset, face_t])
        cube([rail_t, rail_h, rail_d]);
}

// Grooves for one rail set at a given y offset
module groove_set(y_offset) {
    // Left groove
    translate([-0.1, y_offset + groove_y, face_t])
        cube([groove_d + 0.1, groove_h, rail_d]);
    // Right groove
    translate([bay_w - groove_d, y_offset + groove_y, face_t])
        cube([groove_d + 0.1, groove_h, rail_d]);
}

module tab_set(y_offset) {
    // Left tab
    translate([-0.1, y_offset, tab_d])
        cube([groove_d + 0.1, bay_h, rail_d]);

    // Right tab
    translate([bay_w - groove_d, y_offset , tab_d])
        cube([groove_d + 0.1, bay_h, rail_d]);
}

// Y positions for each of the 3 rail sets
// Total = 3*rail_h + 2*rail_gap = 75+2 = 77 = bay_h, flush top to bottom
rail_y0 = 0;
rail_y1 = rail_h + rail_gap;
rail_y2 = (rail_h + rail_gap) * 2;

difference() {
    union() {
        // Faceplate
        cube([bay_w, bay_h, face_t]);

        // 3 rail sets
        rail_set(rail_y0);
        rail_set(rail_y1);
    }

    // Honeycomb cutouts
    translate([vent_x0, vent_y0, 0])
        intersection() {
            cube([vent_w, vent_h, face_t + 0.2]);
            honeycomb(vent_w, vent_h, face_t);
        }

    // Grooves on all 3 rail sets
    groove_set(rail_y0);
    groove_set(rail_y1);
        
    tab_set(rail_y0);
    tab_set(rail_y1);
        
}

// Copyright 2026 https://gihub.com/kking124. All Rights Reserved.