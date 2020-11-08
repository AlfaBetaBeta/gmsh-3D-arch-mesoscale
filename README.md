# Generation of a mesoscale 3D arch FE mesh

This repository contains a set of macros to generate a 3D Finite Element mesoscale mesh of a masonry arch, via the free meshing tool [gmsh](https://gmsh.info/). The main features of the macros, as well as their input parameters and execution guidelines can be found in the sections below:

* [Introduction](https://github.com/AlfaBetaBeta/gmsh-3D-arch-mesoscale#introduction)
* [Bond types](https://github.com/AlfaBetaBeta/gmsh-3D-arch-mesoscale#bond-types)
* [Input parameters](https://github.com/AlfaBetaBeta/gmsh-3D-arch-mesoscale#input-parameters):
    * [Geometry](https://github.com/AlfaBetaBeta/gmsh-3D-arch-mesoscale#geometry)
    * [Meshing](https://github.com/AlfaBetaBeta/gmsh-3D-arch-mesoscale#meshing)
    * [Main file and editable macros](https://github.com/AlfaBetaBeta/gmsh-3D-arch-mesoscale#main-file-and-editable-macros)
* [Execution](https://github.com/AlfaBetaBeta/gmsh-3D-arch-mesoscale#execution)
* [Caveats](https://github.com/AlfaBetaBeta/gmsh-3D-arch-mesoscale#caveats)

## Introduction

The spatial mesh comprises solely 20-noded serendipitous hexahedrons, forming a **single arch** as a standalone structural component (i.e. without further typical masonry elements like backfill or backing).

Illustratively, an example of arch mesh is shown below, alongside the local and global coordinate systems used throughout (though the latter is mere unused reference in this context, it is kept for consistency with [other repositories](https://github.com/AlfaBetaBeta/gmsh-3D-arch-bridge)). Note that the volumes are made transparent for clarity.

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

<img src="https://github.com/AlfaBetaBeta/gmsh-3D-arch-mesoscale/blob/master/img/joint-types.png" width=100% height=100%>


Illustratively, all three bond types can be inspected below, whereby on the left the brick and mortar hexahedra are distinctly displayed and the 'brick bulk joints' are made translucent for clarity; on the right only the real mortar joints are displayed:

* Bond type `1`: running bond in XY and YZ (leaves entire circumferential and radial joints)
<img src="https://github.com/AlfaBetaBeta/gmsh-3D-arch-mesoscale/blob/master/img/BT1.png" width=100% height=100%>

* Bond type `2`: running bond in XY and XZ (leaves entire arch and radial joints)
<img src="https://github.com/AlfaBetaBeta/gmsh-3D-arch-mesoscale/blob/master/img/BT2.png" width=100% height=100%>

* Bond type `3`: leaves entire circumferential joints representing interfaces between rings, as well as radial joints
<img src="https://github.com/AlfaBetaBeta/gmsh-3D-arch-mesoscale/blob/master/img/BT3.png" width=100% height=100%>


## Input parameters

All the `.geo` files containing macros are named as the macro they embed, prepended by `Macro_`. Additionally, there is a file (`General_Input.geo`) gathering all relevant modelling information. This file is the one meant to be edited by the user, alongside the main file actually calling the macros and retrieving the input values, in this case `test.geo`. Under certain circumstances, the bond type macros [may need to be edited as well](https://github.com/AlfaBetaBeta/gmsh-3D-arch-mesoscale#main-file-and-editable-macros).

There are two main groups of input parameters in `General_Input.geo`: geometry and meshing parameters.

### Geometry

An example of geometric input from within `General_Input.geo` is shown below:

<img src="https://github.com/AlfaBetaBeta/gmsh-3D-arch-mesoscale/blob/master/img/geometry-input.png" width=80% height=80%>

* `Abt` specifies the bond type as elaborated [above]().
* `br_*[]` are lists containing the brick and mortar element dimensions along each (local) coordinate direction. It is up to the user to set the list order as {brick,mortar} or {mortar,brick} for each direction (`br_x[]`, `br_y[]` and `br_z[]`) separately. For instance, along (local) Y, the dimensions in the example are `107.5` for the brick elements and `6.0` for the joint elements (mortar and 'brick bulk'). As noted in the [introduction](https://github.com/AlfaBetaBeta/gmsh-3D-arch-mesoscale#introduction), recall that two brick elements (and a 'brick bulk joint') are necessary to fully represent a physical brick.
* `PH`, `PWd` and `W` are legacy parameters from [this repository](https://github.com/AlfaBetaBeta/gmsh-3D-arch-bridge), without real use here aside from positioning the arch in global coordinates. Any arbitrary value can be assigned to them (e.g. `PH = 0` would lead to the global positioning of the arch shown in the [introduction](https://github.com/AlfaBetaBeta/gmsh-3D-arch-mesoscale#introduction)). These parameters are maintained to enable future mesoscale extensions of the macros, for compatible generation of other masonry elements (e.g. piers).
* `CSp`, `ARs` and `Th` define the geometry of the arch. Their meaning can be visually interpreted [here](https://github.com/AlfaBetaBeta/gmsh-3D-arch-bridge#geometry).
* `BZL` represents the number of brick layer (i.e. ignoring mortar) where loading will be applied on its extrados face. It starts from 1 in the brick layer at the springing where (local) Z is zero. Illustratively, a sample arch with 60 brick layers is shown below where `BZL = 50` (volumes made translucent for clarity).

<img src="https://github.com/AlfaBetaBeta/gmsh-3D-arch-mesoscale/blob/master/img/BZL-example.png" width=100% height=100%>

In its current form, the set of macros only accepts one brick layer for `BZL`, but future revisions will accommodate the case of multiple layers via a list-like parameter (`BZL[]`).

### Meshing

A sample meshing input from within `General_Input.geo` is also shown below:

<img src="https://github.com/AlfaBetaBeta/gmsh-3D-arch-mesoscale/blob/master/img/meshing-input.png" width=60% height=60%>

* `n_x` and `n_y` represent the number of layers along local X and Y, respectively. Bear in mind that this includes brick **and** mortar (thus for instance `n_x = 3` represents {brick, joint, brick} or {joint, brick, joint} depending on `br_x[]`). `n_z` is calculated inside the macros and displayed as an `INFO` message upon execution.

### Main file and editable macros

The main `test.geo` file initialises the physical entities to be populated in the macros. If the strings labelling the physical entities are not to be programmatically processed for integration purposes with the relevant FE engine, then the user can select their physical entities of interest, leave the rest commented out and proceed with execution. None of the physical entities is essential for the correct execution of any macro. 

If the physical entity labels in `test.geo` do convey information to be processed (like self-weight, as in the example below left), then attention must be paid to ensure **consistency of units with geometric dimensions** (e.g. as specified in `br_*[]`), as well as **consistency between `test.geo` and the relevant bond type macro** (e.g. `01Bond_Type01`, as shown below right).

<img src="https://github.com/AlfaBetaBeta/gmsh-3D-arch-mesoscale/blob/master/img/bricks-sw-main-file-vs-bondtype1.png" width=100% height=100%>

Similarly, initial conditions and loading must be edited manually in the main file `test.geo` **only if** the string labels are meant to convey information about displacement/velocity/acceleration/force (ensuring consistency of units, as ever):

<img src="https://github.com/AlfaBetaBeta/gmsh-3D-arch-mesoscale/blob/master/img/Initial-conditions-loading.png" width=45% height=45%>


## Execution

Once `General_input.geo` has been populated with the appropriate values by the user as per the guidelines [above](https://github.com/AlfaBetaBeta/gmsh-3D-arch-mesoscale#input-parameters), the execution of the macros from the main `.geo` file can be done via GUI or CLI. For the example included here, these options would be:
* GUI:
    * Open `test.geo` from gmsh and then press `0` to read the file.
    * To execute the 3D meshing after reading the script, press `3`.
    * The resulting `.msh` file can be saved locally and might be necessary as input for further generative/analysis tools.

* CLI:
```
$ gmsh -3 test.geo
```
or
```
$ gmsh -3 -part 6 test.geo
```
should it be necessary to partition the mesh (say in 6 in this case).

## Caveats

* All macros are developed under an old gmsh version (2.2), though they should work with later versions (4) as well.

* The current project architecture is somewhat unstructured, and may need the user to manually control consistency between `General_Input.geo` and the main `geo` file. A desirable upgrade would consist of centralising the input into a single file and handling all consistency checks internally.
