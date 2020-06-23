/*********************************************************************
 *
 *  Macro VolToSurfLoad
 *
 *
 *********************************************************************/
// TAKE THE VOLUME LIST REPRESENTING THE ARCH EXTRADOS (PROVIDED AS INPUT)
// AND CREATE A LIST WITH THE 'TOP' SURFACES OF THE EXTRADOS VOLUMES AFFECTED
// BY LOADING!

// NOTES: * IT IS ASUMED THAT IN MACRO CrtArchIntrf THE POINT EXTRUSIONS ARE ALWAYS
//	    MADE FROM TOP TO BOTTOM OF SKEWBACK!
//	  * THERE IS A MANUAL SELECTION HERE DEPENDING ON THE KERNEL!!

Macro VolToSurfLoad

/*
IN:	extrados[]  = Already subset list of Volumes representing arch extrados
	BZL	    = Brick Z-layer along which loading will be applied

OUT: 	ArExtr2Ld[] = List of 'top' Surfaces for loading
*/
//-------------------------------------------------------------------------------------------
ArExtr2Ld[] = {};
//-------------------------------------------------------------------------------------------
// SELECT/COMMENT OUT DEPENDING ON THE KERNEL:

// USE IF KERNEL = Built-in
For index In {elemY*(BZL-1) : elemY*BZL-1}
	auxB[] = Boundary { Volume{extrados[index]}; };
	ArExtr2Ld[] = {ArExtr2Ld[], auxB[#auxB[]-1]};
EndFor

// USE IF KERNEL = OpenCASCADE
//For index In {elemY*(BZL-1) : elemY*BZL-1}
//	auxB[] = Boundary { Volume{extrados[index]}; };
//	ArExtr2Ld[] = {ArExtr2Ld[], auxB[0]};
//EndFor
//-------------------------------------------------------------------------------------------
Return
