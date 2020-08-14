# Generation of a mesoscale 3D arch FE mesh with gmsh

All macros (`Macro_*.geo`) are developed under gmsh version 2.2., though they should work with later versions (4) as well. These macros generate one single arch mesh as a standalone structural component (i.e. no backfill/backing/ballast...).


## Units and loads

The load is expected to be dynamic and applied to the extrados face of a given 'brick layer' (`BZL` in the `General_input` file). In this version, units are expected to be mm! 

The self-weight of materials must be edited manually in the main file `test.geo` 

<img src="https://github.com/AlfaBetaBeta/gmsh-3D-arch-mesoscale/blob/ABB/img/physical-volume-bricks-sw.png" width=90% height=90%>

and at the end of the appropriate `Bond_Type` macro `Macro_01Bond_Type0x.geo`

<img src="https://github.com/AlfaBetaBeta/gmsh-3D-arch-mesoscale/blob/ABB/img/brick-sw-bond-type-1.png" width=90% height=90%>

provided that the string with the Physical Volume name be programmatically processed by a FE engine to define volumetric loads. Should the self weight components be defined differently, then this manual labelling is unnecessary.

Similarly, initial conditions and dynamic loading must be edited manually in the main file `test.geo` **if** the strings are meant to convey information about displacement/velocity/acceleration:

<img src="https://github.com/AlfaBetaBeta/gmsh-3D-arch-mesoscale/blob/ABB/img/Initial-conditions-loading.png" width=50% height=50%>


## Geometry and FE mesh

The frame of reference is based on the following coordinates:
* Local X = direction along arch thickness (from extrados to intrados)
* Local Y = direction along arch width (axis of revolution)
* Local Z = (curved) direction along arch (left to right when seen from y=0 plane)

Illustratively, the local and global coordinates are shown below (though the latter are not used in this framework):
<img src="https://github.com/AlfaBetaBeta/gmsh-3D-arch-mesoscale/blob/ABB/img/Axes-local-global.png" width=100% height=100%>

* **Both** the bricks and the mortar joints are defined as solid hexahedrons. Transforming the latter into zero-thickness interface elements can be done externally and is not addressed further here. When defining the dimensions of the brick and mortar along X/Y/Z in `General_input`, it is up to the user to set the order {brick,mortar} or {mortar,brick} for each direction separately!

* Note that a *brick* refers here to **half** of an actual brick (i.e. cross sectional dimensions 65 x 102.5 and length 215/2). This is because there are very stiff 'mortar layers' meant to be inside the brick bulk. Their distribution alongside the real mortar layers depends on the type of bond.

Geometric and meshing parameters to be entered in the `General_input` file:
* `n_x` and `n_y` represent the number of layers along local x and y, respectively. Bear in mind that this includes brick **and** mortar (i.e. `n_x=3` represents {brick,mortar,brick} or {mortar,brick,mortar} depending on `br_x[]`). `n_z` is calculated inside the macros and displayed as an INFO message upon execution.

* `BZL` represents the number of brick layer (i.e. ignoring mortar) where loading will be applied. It starts from 1 in the brick layer at the left springing (when seen from y=0 plane).  


## Bond types

Three distinct bond types for the bricks in the arch are implemented here, taking the equivalences below in consideration:
* Joint plane at local X = constant == CIRCUMFERENTIAL JOINT
* Joint plane at local Y = constant == ARCH JOINT (LONGITUDINAL)
* Joint plane at local Z = constant == RADIAL JOINT

Illustratively, these bond types can be inspected below:
* Bond type 1: running bond in XY and YZ (leaves entire circumferential and radial joints)
<img src="https://github.com/AlfaBetaBeta/gmsh-3D-arch-mesoscale/blob/ABB/img/BT1.png" width=100% height=100%>

* Bond type 2: running bond in XY and XZ (leaves entire arch and radial joints)
<img src="https://github.com/AlfaBetaBeta/gmsh-3D-arch-mesoscale/blob/ABB/img/BT2.png" width=100% height=100%>

* Bond type 3: leaves entire circumferential joints representing interfaces between rings, as well as radial joints
<img src="https://github.com/AlfaBetaBeta/gmsh-3D-arch-mesoscale/blob/ABB/img/BT3.png" width=100% height=100%>

## Execution

To read the main script (here `test.geo`) into gmsh via GUI, simply open it from gmsh and then press 0. To execute the meshing after reading the script, press 3. The resulting `.msh` file can be saved locally and might be necessary as input for further generative/analysis tools.

