/*********************************************************************
 *
 *  GENERAL INPUT (FULL 3D ARCH MESO-SCALE MODEL)
 *
 *********************************************************************/
// COMMON INPUT TO BE PASSED ON TO ALL .geo FILES INVOKING MACROS!
//-------------------------------------------------------------------------------------------
// REFERENCE UNIT OF MEASURE: MILLIMETRES
//-------------------------------------------------------------------------------------------
// BOND TYPE FOR THE BRICKS IN THE ARCH, TAKING THE EQUIVALENCES BELOW IN CONSIDERATION:
// JOINT PLANE AT LOCAL X=ct == CIRCUMPHERENTIAL JOINT
// JOINT PLANE AT LOCAL Y=ct == ARCH JOINT (LONGITUDINAL)
// JOINT PLANE AT LOCAL Z=ct == RADIAL JOINT

// Abt == 1	RUNNING BOND IN XY AND YZ (LEAVES ENTIRE CIRCUMPHERENTIAL AND RADIAL JOINTS)
// Abt == 2	RUNNING BOND IN XY AND XZ (LEAVES ENTIRE ARCH AND RADIAL JOINTS)
// Abt == 3	LEAVES ENTIRE CIRCUMPHERENTIAL JOINTS REPRESENTING INTERFACES BETWEEN RINGS,
//	        AS WELL AS RADIAL JOINTS

Abt = 1;
//-------------------------------------------------------------------------------------------
// DEFINE GEOMETRIC INPUT (DEPENDENT ON UNITS)
//-------------------------------------------------------------------------------------------
// NOMINAL BRICK DIMENSIONS FOR ARCHES
br_x[] = {65, 10};		// {e = brick, o = interface}
br_y[] = {107.5, 6.0};	// {e = brick, o = interface}
br_z[] = {7.0, 102.5};	// {e = interface, o = brick}

// PIER DIMENSIONS (ONLY NEEDED TO LOCATE THE ARCH IN GEOMETRIC SPACE)
PH    = 5000;	// Height
PWd   = 0;	    // Reference X-width [Use 0 if minimum X-width is sought (triangular skewback)]
W     = 675;	// Y-width

// ARCH DIMENSIONS
CSp   = 5000;	// Clear span
ARs   = 1500;	// Rise
Th    = 440;	// Thickness

// SKEWBACK (ONLY NEEDED TO ORIENTATE THE ARCH IN GEOMETRIC SPACE)
Call InitEQSpIntrf;
Angle = Pi-2*phi0;

// LOADING
BZL = 6;	// Number of the brick Z-layer where prop/dyn load will be applied
//-------------------------------------------------------------------------------------------
// DEFINE DISCRETISATION INPUT (REGARDLESS OF UNITS)
//-------------------------------------------------------------------------------------------
// ARCH
n_x  = 11;	// Number of layers (brick & interface) along local X
n_y  = 11;	// Number of layers (brick & interface) along local Y
//-------------------------------------------------------------------------------------------

