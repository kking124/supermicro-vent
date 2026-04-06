# SuperMicro Rack Server Airflow Grates

[![CC BY-NC-SA 4.0][cc-by-nc-sa-shield]][cc-by-nc-sa]

These are airflow grates for SuperMicro Servers that accept ```MCP-220-00024-0B``` or ```MCP-220-00118-0B``` caddies.

They were designed using a CSE-826 2U server; I'm sure they fit other servers that accept these caddies.

Designs are provided in ```scad``` design files and ```stl``` printable files.

Three vertical size options are available - 1 bay, 2 bay, and 3 bay.

Two hexagon sizes are available - small and large.

## Editing

### Hexagon sizes

If you want a different hexagon size, change the radius with the ```hex_cr``` variable in the scad file. The following 
sizes are provided already:

- small: 2.2 mm
- large: 4.0 mm

### Hexagon separation

If you want to change the separation between the hexagons, change the ```hex_gap``` variable in the scad file. All
models use a 1.0 mm separation.

### Caddy Depth

If you want to vary the caddy depth, change the ```rail_d``` variable in the scad file. All models use a 36.0 mm depth.

### Caddy Tab Depth

I found that full width caddies tended to rub internally in the slots, so they are only full width to 25.0 mm. Beyond
that they take on a width offset similar to the side groove. You can change the full width arm depth using the 
```tab_d``` variable.

## License

These designs are licensed under a [Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License][cc-by-nc-sa].

[![CC BY-NC-SA 4.0][cc-by-nc-sa-image]][cc-by-nc-sa]

[cc-by-nc-sa]: https://creativecommons.org/licenses/by-nc-sa/4.0/
[cc-by-nc-sa-image]: https://licensebuttons.net/l/by-nc-sa/4.0/88x31.png
[cc-by-nc-sa-shield]: https://img.shields.io/badge/License-CC%20BY--NC--SA%204.0-lightgrey.svg

## Copyright

Copyright &copy; 2026 https://gihub.com/kking124. All Rights Reserved.