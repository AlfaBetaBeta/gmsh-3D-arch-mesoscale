/*********************************************************************
 *
 *  GENERAL INPUT (FULL 3D ARCH MESO-SCALE MODEL)
 *
 *********************************************************************/
// COMMON INPUT TO BE PASSED ON TO ALL .geo FILES INVOKING MACROS!
//-------------------------------------------------------------------------------------------
// REFERENCE UNIT OF MEASURE:
// ref == 1		    FOR METRES
// ref == 1000		FOR MILLIMETRES

ref = 1000;
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
If (ref == 1)
	Printf("Complete all input parameters in metres!");
	Abort();
//-------------------------------------------------------------------------------------------
ElseIf (ref == 1000)
// NOMINAL BRICK DIMENSIONS FOR ARCHES
br_x[] = {102.5, 10.0};	// {e = brick, o = interface}
br_y[] = {105.0, 6.0};	// {e = brick, o = interface}
br_z[] = {140, 7.0};	// {e = brick, o = interface}

// PIER DIMENSIONS (ONLY NEEDED TO LOCATE THE ARCH IN GEOMETRIC SPACE)
PH    = 5000;	// Height
PWd   = 0;	    // Reference X-width [Use 0 if minimum X-width is sought (triangular skewback)]
W     = 660;	// Y-width

// ARCH DIMENSIONS
CSp   = 5000;	// Clear span
ARs   = 1250;	// Rise
Th    = 215;	// Thickness

// SKEWBACK (ONLY NEEDED TO ORIENTATE THE ARCH IN GEOMETRIC SPACE)
Call InitEQSpIntrf;
Angle = Pi-2*phi0;

// LOADING
BZL = 6;	// Number of the brick Z-layer where prop/dyn load will be applied

EndIf
//-------------------------------------------------------------------------------------------
// DEFINE DISCRETISATION INPUT (REGARDLESS OF UNITS)
//-------------------------------------------------------------------------------------------
// ARCH
n_x  = 3;	// Number of layers (brick & interface) along local X
n_y  = 11;	// Number of layers (brick & interface) along local Y
//-------------------------------------------------------------------------------------------

