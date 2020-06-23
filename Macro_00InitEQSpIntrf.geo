/*********************************************************************
 *
 *  Macro InitEQSpIntrf
 *
 *  Initialise the main (geometric) input parameters for the main macros 
 *  based on the most commonly given dimensions
 *
 *********************************************************************/
// PREPARE THE SET OF INPUT PARAMETERS FOR THE SEPARATE CONSTRUCTING MACROS
// (CrtArchIntrf, ..) BASED ON THE MOST COMMONLY
// GIVEN GEOMETRIC INFO, I.E. CLEAR SPAN, ARCH RISE AND ARCH THICKNESS

// NOTES: * IT IS ASSUMED THAT ALL SPANS ARE IDENTICAL, THAT IS, THE
//	    CLEAR SPAN, ARCH RISE AND THICKNESS ARE CONSTANT, WHICH
//	    ALSO ENTAILS THAT THE SKEWBACKS ARE SYMMETRIC (L_x1 = -L_x3)
//	  * BY DEFAULT L_x2 IS SET TO ZERO IF THE PIERS ARE TOO THIN, AND
//	    PWd0 IS USED INSTEAD, CONSIDERING 3 EDGED SKEWBACKS/BACKINGS
//	  * OTHERWISE L_x2 IS SET TO THE APPROPRIATE FINITE VALUE, AND
//	    ALL 4 EDGES ARE CONSIDERED IN THE SKEWBACKS/BACKINGS
//	  * IT IS ASSUMED THAT IN THE START AND END ARCH SPRINGINGS, AS WELL
//	    AS IN THE ARCH EXTRADOS, THERE IS ALWAYS AN INTERFACE LAYER!
//	    SHOULD THIS NOT BE THE CASE, THEN APPROPRIATE CHANGES MUST BE
//	    MADE IN THE BLOCK BELOW (CALCULATION OF pA1, pA2, pA3)

Macro InitEQSpIntrf

/*
IN:	CSp    = Clear span
	ARs    = Arch rise
	Th     = Arch thickness
	PH     = Pier height

	br_x[] = {interface, brick} dimensions along X **see 4th note above**
	br_z[] = {interface, brick} dimensions along Z **see 4th note above**

INOUT:	PWd    = X-width of the piers (may be changed here, depending on PWd0)

OUT: 	Radius = Arch radius (centre to mid-surface)
	R      = Arch radius (centre to intrados)
	L_x1   = 
	L_x2   = 
	L_x3   = 
	L_z    =

	PWd0  = Consistent design pier X-width, as calculated from CSp and ARs
	Lx0   = Aux variable, L_x1 in absolute value
	Lz0   = Aux variable, L_z in absolute value
	Cphi0 = Cos(phi0), where phi0 is the angle of the skewback
		side (p001 to p003 )wrt the horizontal
	Th0   = Aux variable, arch thickness necessary to have PWd0
		matching PWd

	pA1   = Starting Point to generate arch1 
	pA2   = Starting Point to generate arch2
	pA3   = Starting Point to generate arch3
*/
//-------------------------------------------------------------------------------------------
// CALCULATE RADIUS, CONSTANT AND EQUAL FOR ALL SPANS

R = (CSp^2/4 + ARs^2)/(2*ARs);
Radius = R + Th/2;
//-------------------------------------------------------------------------------------------
// CALCULATE ANGLE (its Cos) AT ARCH SPRINGING

Cphi0 = CSp/(2*R);
phi0  = Acos(Cphi0);
Sphi0 = Sin(phi0);
//-------------------------------------------------------------------------------------------
// DETERMINE SKEWBACK GEOMETRY PARAMETERS (INPUT FOR SUBSEQUENT MACROS)

Lx0  = Th * Cphi0; Printf("X-width of triangular side of skewback = ", Lx0);
PWd0 = 2*Lx0; // << VALOR DE CALCULO
L_x1 = -Lx0;
L_x3 = Lx0;
Lz0  = Sqrt(Th^2 - Lx0^2); Printf("Height of the skewback = ", Lz0);
L_z  = -Lz0;

// L_x2 DEPENDS ON THE COMPARISON PWd TO PWd0
If (PWd0 < PWd)
	L_x2 = PWd - PWd0;	// COMPLIANCE WITH ORIGINAL PWd
Else
	L_x2 = 0;
	Th0 = PWd/(2*Cphi0);
	PWd = PWd0;		// PWd0 IS USED INSTEAD
	Printf("WARNING: The pier is too thin for the specified values of CSp, ARs and Th!");
	Printf("         Instead, a pier width of %.2f is used throughout.", PWd0);
	Printf("         To comply with the original value of PWd, reduce arch thickness Th to %.2f and restart.", Th0);
EndIf
//-------------------------------------------------------------------------------------------
// DETERMINE STARTING POINTS FOR THE 3 ARCHES (SUBROUTINE CrtArchIntrf)
// SEE 4th NOTE ABOVE AFFECTING THE CALCULATION OF THESE POINTS

// ONLY ONE ARCH (MIDDLE ONE, A2) IS GENERATED HERE

//pA1 = newp; Point(pA1) = {-3*CSp/2-3*Lx0-L_x2-br_x[0]/2, 0, PH+Lz0-br_z[0]/2};
//Rotate {{0,1,0}, {-3*CSp/2-3*Lx0-L_x2, 0, PH+Lz0}, phi0} { Point{pA1}; }

pA2 = newp; Point(pA2) = {-CSp/2-Lx0-br_x[0]/2,          0, PH+Lz0-br_z[0]/2};
Rotate {{0,1,0}, {-CSp/2-Lx0, 0, PH+Lz0}, phi0} { Point{pA2}; }

//pA3 = newp; Point(pA3) = { CSp/2+Lx0+L_x2-br_x[0]/2,     0, PH+Lz0-br_z[0]/2};
//Rotate {{0,1,0}, {CSp/2+Lx0+L_x2, 0, PH+Lz0}, phi0} { Point{pA3}; }
//-------------------------------------------------------------------------------------------
// DETERMINE STARTING POINTS FOR THE 1st SKEWBACK (SUBROUTINE TrpzmStr)

// NOT NEEDED HERE
//-------------------------------------------------------------------------------------------
// DETERMINE STARTING POINTS FOR THE 2 PIERS (SUBROUTINE CrtPierIntrf)

// NOT NEEDED HERE
//-------------------------------------------------------------------------------------------

Return
