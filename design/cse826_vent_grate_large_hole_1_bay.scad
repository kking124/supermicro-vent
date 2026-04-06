// Supermicro CSE-826 Hot-Swap Bay Vent Grate
// Print in PETG, 0.2mm layers, 3 walls, 20% infill, no supports needed

// ── Dimensions ───────────────────────────────────────────────────
bay_w      = 106.0;   // bay opening width (mm)
bay_h      =  27.0;   // bay opening height (mm)
face_t     =   3.0;   // faceplate thickness
rail_t     =   6.0;   // side rail thickness (thickened for groove)
rail_d     =  36.0;   // depth rails extend into bay
rail_h     =  27.0;   // rail height
rail_y     =   0;     // flush with bottom edge of bay
border     =   4.0;   // solid border around vent cutouts

// ── Groove (runs along outside face of each rail) ─────────────────
groove_h   =   7.0;   // groove height
groove_d   =   2.0;   // groove depth (into rail, from outside face)
groove_y   =   4.5;   // offset from bottom of rail
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

// Centre the honeycomb grid within the vent area.
// Calculate how much space is left over after fitting whole pitches,
// then shift the grid by half that remainder so it's symmetric.
cols_fit    = floor(vent_w / hex_pitch_x);
rows_fit    = floor(vent_h / hex_pitch_y);
offset_x    = (vent_w - cols_fit * hex_pitch_x) / 2;
offset_y    = (vent_h - rows_fit * hex_pitch_y) / 2;

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

// Left rail groove
// Left rail groove — cut from outside (x = -0.1) inward by groove_d
module left_groove() {
    translate([-0.1, rail_y + groove_y, face_t])
        cube([groove_d + 0.1, groove_h, rail_d]);
}

module left_offset() {
    translate([-0.1, rail_y, tab_d])
        cube([groove_d + 0.1, bay_h, rail_d]);
}

// Right rail groove — cut from outside face inward by groove_d
module right_groove() {
    translate([bay_w - groove_d, rail_y + groove_y, face_t])
        cube([groove_d + 0.1, groove_h, rail_d]);
}

module right_offset() {
    translate([bay_w - groove_d, rail_y , tab_d])
        cube([groove_d + 0.1, bay_h, rail_d]);
}

difference() {
    union() {
        // Faceplate
        cube([bay_w, bay_h, face_t]);

        // Left rail
        translate([0, rail_y, face_t])
            cube([rail_t, rail_h, rail_d]);

        // Right rail
        translate([bay_w - rail_t, rail_y, face_t])
            cube([rail_t, rail_h, rail_d]);
    }

    // Honeycomb cutouts clipped to vent area
    translate([vent_x0, vent_y0, 0])
        intersection() {
            cube([vent_w, vent_h, face_t + 0.2]);
            honeycomb(vent_w, vent_h, face_t);
        }

    // Rail grooves
    left_groove();
    left_offset();
    right_groove();
    right_offset();
}

// Copyright 2026 https://gihub.com/kking124. All Rights Reserved.