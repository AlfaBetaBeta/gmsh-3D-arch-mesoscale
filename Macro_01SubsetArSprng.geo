/*********************************************************************
 *
 *  Macro SubsetArSprng
 *
 *
 *********************************************************************/
// SUBSET THE VOLUMES OF THE ARCH SPRINGINGS CORRESPONDING TO THE BEDJOINTS,
// AND THE VOLUMES OF THE ARCH EXTRADOS CORRESPONDING TO HEADJOINTS (LOCAL X=0),
// FOR THE PURPOSE OF MESH TYING IN AN UPPER MACRO

Macro SubsetArSprng

/*
IN:	br_x[] = {brick, interface} or {interface, brick} dimensions along X
	br_y[] = {brick, interface} or {interface, brick} dimensions along Y
	br_z[] = {brick, interface} or {interface, brick} dimensions along 'Z'
	n_x    = Number of layers (including both bricks and interfaces) along
		 X in the 'cross section'
	n_y    = Number of layers (including both bricks and interfaces) along
		 Y in the 'cross section'
	n_z    = Number of layers (including both bricks and interfaces) along
		 arch longitudinal direction ('Z')

OUT: 	subsetAS[]  = List of indices to slice from the Surface list S_sprngx[]
		      (x=S or E) in the upper macro for the arch springings
	
	ntrf_X = aux
	brck_X = aux
	ntrf_Y = aux
	brck_Y = aux
	ntrf_Z = aux
	brck_Z = aux
*/
//-------------------------------------------------------------------------------------------
If (br_x[0] < br_x[1])
	ntrf_X = 0;	// br_x[] is given as {e = interface, o = brick}
	brck_X = 1;
Else
	ntrf_X = 1;	// br_x[] is given as {e = brick, o = interface}
	brck_X = 0;
EndIf


If (br_y[0] < br_y[1])
	ntrf_Y = 0;	// br_y[] is given as {e = interface, o = brick}
	brck_Y = 1;
Else
	ntrf_Y = 1;	// br_y[] is given as {e = brick, o = interface}
	brck_Y = 0;
EndIf


If (br_z[0] < br_z[1])
	ntrf_Z = 0;	// br_z[] is given as {e = interface, o = brick}
	brck_Z = 1;
Else
	ntrf_Z = 1;	// br_z[] is given as {e = brick, o = interface}
	brck_Z = 0;
EndIf
//-------------------------------------------------------------------------------------------
subsetAS[] = {};
For y_index In {brck_Y : n_y-1 : 2}
	For x_index In {brck_X : n_x-1 : 2}
		subsetAS[] = {subsetAS[], y_index*n_x + x_index};
	EndFor
EndFor
//-------------------------------------------------------------------------------------------

Return
