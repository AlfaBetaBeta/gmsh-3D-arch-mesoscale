# Generation of a mesoscale 3D arch with gmsh

All macros are developed under gmsh version 2.2., though they should work with later versions (4) as well.

These macros generate ONE single arch as a standalone element, i.e. no backfill/backing/ballast...

The load is expected to be dynamic and applied to the extrados face of a given 'brick layer' (`BZL` in the general input file).

In this version, units are expected to be mm! 

The self-weight of materials must be edited manually in the main file `test.geo` 

[...]

and at the end of the appropriate `Bond_Type` macro `Macro_01Bond_Type0x`

[...]

Illustratively, the 3 implemented bond types can be visualised in the .pdf file. 

Initial conditions and dynamic loading must be edited manually in the main .geo file (lines 76-77,80)

Geometric and meshing parameters to be entered in the general input file:
* Locally, x = direction along arch thickness (from extrados to intrados)
		   y = direction along arch width (inwards to the screen/paper)
		   z = (curved) direction along arch (left to right when seen from y=0 plane)

* When defining the dimensions of the brick and mortar along x/y/z (general input, lines 34-36), it is up to the user to set the order {brick,mortar} or {mortar,brick} for each direction separately!

* `n_x` and `n_y` represent the number of layers along local x and y, respectively. Bear in mind that this includes brick AND mortar (i.e. `n_x=3` represents {brick,mortar,brick} or {mortar,brick,mortar} depending on `br_x[]`). `n_z` is calculated inside the macros.

* Keep in mind that a 'brick' refers here to HALF of an actual brick! This is because there are very stiff 'mortar layers' meant to be inside the brick bulk. Their distribution alongside the proper mortar layers depends on the type of bond.

* `BZL` represents the number of brick layer (i.e. neglecting mortar) where loading will be applied. It starts from 1 in the brick layer at the left springing (when seen from y=0 plane).  


To read the main script into gmsh via GUI, simply open it from gmsh and then press 0. To execute the meshing after reading the script, press 3. The resulting `.msh` file will be necessary as input for further generative/analysis tools.