# Generation of a mesoscale 3D arch FE mesh

This repository contains a set of macros to generate a 3D Finite Element mesoscale mesh of a masonry arch, via the free meshing tool [gmsh](https://gmsh.info/). The main features of the macros, as well as their input parameters and execution guidelines can be found in the sections below:

* [Introduction]
* [Bond types]


## Introduction

The spatial mesh comprises solely 20-noded serendipitous hexahedrons, forming a **single arch** as a standalone structural component (i.e. without further typical masonry elements like backfill or backing).

Illustratively, an example of arch mesh is shown below, alongside the local and global coordinate systems used throughout (though the latter is mere reference in this context, it is kept for consistency with [other repositories](https://github.com/AlfaBetaBeta/gmsh-3D-arch-bridge)). Note that the volumes are made transparent for clarity.

<img src="https://github.com/AlfaBetaBeta/gmsh-3D-arch-mesoscale/blob/master/img/Axes-local-global.png" width=100% height=100%>

Consistently with a mesoscale description of the material, **both** the bricks and the mortar joints are separately defined as solid hexahedrons. Though the mesh could be left as is, it is common practice to model the joints as zero-thickness interface elements. Programmatically transforming the solid mortar elements into such interfaces, however, belongs to another utility program and is not addressed further here.

Note that, although notionally a *brick* still refers intuitively to a standard engineering brick (say cross sectional dimensions 65 x 102.5 and length 215, in mm), a *brick element* represents here **half of an actual brick**. This is because there are very stiff 'joint layers' meant to be inside the brick bulk, as shown below. Such 'brick bulk joints' concentrate the brick material nonlinearity (they represent a potential plane of fracture between elastic brick elements) and also effectively enable the offset between bricks needed to materialise a certain type of bond.

<img src="https://github.com/AlfaBetaBeta/gmsh-3D-arch-mesoscale/blob/master/img/brick-mortar-detail.png" width=100% height=100%>


## Bond types

Three distinct bond types are implemented in the macros, taking the definitions below in consideration:

* Joint plane at constant (local) X => ***circumferential*** joint
* Joint plane at constant (local) Y => ***arch (longitudinal)*** joint
* Joint plane at constant (local) Z => ***radial*** joint

All joint planes are highlighted below on sample arches for ease of interpretation. Each bond type aims at avoiding certain joint planes, to increase stability and favour brick interlocking.

<img src="https://github.com/AlfaBetaBeta/gmsh-3D-arch-mesoscale/blob/ABB/img/joint-types.png" width=100% height=100%>


Illustratively, all three bond types can be inspected below, whereby on the left the brick and mortar hexahedra are distinctly displayed and the 'brick bulk joints' are made translucent for clarity; on the right only the real mortar joints are displayed:

* Bond type 1: running bond in XY and YZ (leaves entire circumferential and radial joints)
<img src="https://github.com/AlfaBetaBeta/gmsh-3D-arch-mesoscale/blob/master/img/BT1.png" width=100% height=100%>

* Bond type 2: running bond in XY and XZ (leaves entire arch and radial joints)
<img src="https://github.com/AlfaBetaBeta/gmsh-3D-arch-mesoscale/blob/master/img/BT2.png" width=100% height=100%>

* Bond type 3: leaves entire circumferential joints representing interfaces between rings, as well as radial joints
<img src="https://github.com/AlfaBetaBeta/gmsh-3D-arch-mesoscale/blob/master/img/BT3.png" width=100% height=100%>


## Input parameters

All the `.geo` files containing macros are named as the macro they embed, prepended by `Macro_`. Additionally, there is a file (`General_Input.geo`) gathering all relevant modelling information. This file is the one meant to be edited by the user, alongside the main file actually calling the macros and retrieving the input values, in this case `test.geo`.

There are two main groups of input parameters in `General_Input.geo`: geometry and meshing parameters.

### Geometry

An example of geometric input from within `General_Input.geo` is shown below:

<img src="https://github.com/AlfaBetaBeta/gmsh-3D-arch-mesoscale/blob/ABB/img/geometry-input.png" width=90% height=90%>


## Units and loads

The load is expected to be dynamic and applied to the extrados face of a given 'brick layer' (`BZL` in the `General_input` file). In this version, units are expected to be mm! 

The self-weight of materials must be edited manually in the main file `test.geo` 

<img src="https://github.com/AlfaBetaBeta/gmsh-3D-arch-mesoscale/blob/master/img/physical-volume-bricks-sw.png" width=90% height=90%>

and at the end of the appropriate `Bond_Type` macro `Macro_01Bond_Type0x.geo`

<img src="https://github.com/AlfaBetaBeta/gmsh-3D-arch-mesoscale/blob/master/img/brick-sw-bond-type-1.png" width=90% height=90%>

provided that the string with the Physical Volume name be programmatically processed by a FE engine to define volumetric loads. Should the self weight components be defined differently, then this manual labelling is unnecessary.

Similarly, initial conditions and dynamic loading must be edited manually in the main file `test.geo` **if** the strings are meant to convey information about displacement/velocity/acceleration:

<img src="https://github.com/AlfaBetaBeta/gmsh-3D-arch-mesoscale/blob/master/img/Initial-conditions-loading.png" width=50% height=50%>


## Geometry and FE mesh

...

* ...When defining the dimensions of the brick and mortar along X/Y/Z in `General_input`, it is up to the user to set the order {brick,mortar} or {mortar,brick} for each direction (`br_x[]`, `br_y[]` and `br_z[]`) separately!

* ...

Geometric and meshing parameters to be entered in the `General_input` file:
* `n_x` and `n_y` represent the number of layers along local X and Y, respectively. Bear in mind that this includes brick **and** mortar (i.e. `n_x=3` represents {brick,mortar,brick} or {mortar,brick,mortar} depending on `br_x[]`). `n_z` is calculated inside the macros and displayed as an INFO message upon execution.

* `BZL` represents the number of brick layer (i.e. ignoring mortar) where loading will be applied. It starts from 1 in the brick layer at the left springing (when seen from y=0 plane).  




## Execution

Once `General_input.geo` has been populated with the appropriate values, to read the main script `test.geo` into gmsh and proceed with the meshing, execution can be done via:
* GUI:
    * Open it from gmsh and then press `0` to read the file.
    * To execute the 3D meshing after reading the script, press `3`.
    * The resulting `.msh` file can be saved locally and might be necessary as input for further generative/analysis tools.

* CLI:
```
$ gmsh -3 test.geo
```

## Caveats

All macros (`Macro_*.geo`) are developed under gmsh version 2.2., though they should work with later versions (4) as well.
