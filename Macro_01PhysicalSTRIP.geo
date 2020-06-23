/*********************************************************************
 *
 *  Macro PhysicalSTRIP
 *
 *  
 *
 *********************************************************************/
// GIVEN THE ORDER IN WHICH BRICK AND INTERFACE ARE ALTERNATED IN ALL ARCH
// DIRECTIONS, THIS MACRO IDENTIFIES THE APPROPRIATE OUTPUT LISTS FROM MACRO
// CrtArchIntrf, DISTINGUISHING BETWEEN BRICKS, BEDJOINTS, HEADJOINTS-X AND
// HEADJOINTS-Y

Macro PhysicalSTRIP

/*
IN:	brck_X  = ***aux parameters generated in macro SubsetArSprng***
	brck_Y  = 
	brck_Z  = 

OUT: 	brick[] = List with all brick Volumes in a given arch
	bedjt[] = List with all bedjoint Volumes in a given arch
		***With the exclusion of the bedjoints in the physical interface between
		   the arch springings and the skewbacks, should these be present***

	hdjtY[] = List with all Y-headjoint Volumes in a given arch
	hdjtX[] = List with all X-headjoint Volumes in a given arch
		***With the exclusion of the X-headjoints in the physical interface between
		   the arch extrados and the backing/backfill, should these be present***

	[ASki[]	= List with bedjoint Volumes in the physical interface between arch
		  springings and skewbacks]
	[ABfi[]	= List with X-headjoint Volumes in the physical interface between arch
		  extrados and backing/backfill]

*/
//-------------------------------------------------------------------------------------------
// ASSIGNMENT TO OUTPUT LISTS DEPENDS ON THE ORDER IN ARGUMENTS brck_X[], brck_Y[] and brck_Z[]
If (brck_X == 0)	
	If (brck_Y == 0)
		If (brck_Z == 0)
			// br_X[] = {e = brick, o = interface}
			// br_Y[] = {e = brick, o = interface}
			// br_Z[] = {e = brick, o = interface}
			brick[] = eee[];
			bedjt[] = eeo[];
			hdjtY[] = eoe[];
			hdjtX[] = oee[];
		Else
			// br_X[] = {e = brick, o = interface}
			// br_Y[] = {e = brick, o = interface}
			// br_Z[] = {e = interface, o = brick}
			brick[] = eeo[];
			bedjt[] = eee[];
			hdjtY[] = eoo[];
			hdjtX[] = oeo[];
		EndIf
	Else
		If (brck_Z == 0)
			// br_X[] = {e = brick, o = interface}
			// br_Y[] = {e = interface, o = brick}
			// br_Z[] = {e = brick, o = interface}
			brick[] = eoe[];
			bedjt[] = eoo[];
			hdjtY[] = eee[];
			hdjtX[] = ooe[];
		Else
			// br_X[] = {e = brick, o = interface}
			// br_Y[] = {e = interface, o = brick}
			// br_Z[] = {e = interface, o = brick}
			brick[] = eoo[];
			bedjt[] = eoe[];
			hdjtY[] = eeo[];
			hdjtX[] = ooo[];
		EndIf
	EndIf
Else
	If (brck_Y == 0)
		If (brck_Z == 0)
			// br_X[] = {e = interface, o = brick}
			// br_Y[] = {e = brick, o = interface}
			// br_Z[] = {e = brick, o = interface}
			brick[] = oee[];
			bedjt[] = oeo[];
			hdjtY[] = ooe[];
			hdjtX[] = eee[];
		Else
			// br_X[] = {e = interface, o = brick}
			// br_Y[] = {e = brick, o = interface}
			// br_Z[] = {e = interface, o = brick}
			brick[] = oeo[];
			bedjt[] = oee[];
			hdjtY[] = ooo[];
			hdjtX[] = eeo[];
		EndIf
	Else
		If (brck_Z == 0)
			// br_X[] = {e = interface, o = brick}
			// br_Y[] = {e = interface, o = brick}
			// br_Z[] = {e = brick, o = interface}
			brick[] = ooe[];
			bedjt[] = ooo[];
			hdjtY[] = oee[];
			hdjtX[] = eoe[];
		Else
			// br_X[] = {e = interface, o = brick}
			// br_Y[] = {e = interface, o = brick}
			// br_Z[] = {e = interface, o = brick}
			brick[] = ooo[];
			bedjt[] = ooe[];
			hdjtY[] = oeo[];
			hdjtX[] = eoo[];
		EndIf
	EndIf
EndIf
//-------------------------------------------------------------------------------------------
// ESTABLISH THE AMOUNT OF BRICK LAYERS IN EACH DIRECTION, DEPENDING ON THE ORDER
// {brick, interface} IN THE INPUT PARAMETERS br_x[], br_y[] AND br_z[]

// BRICK LAYERS ALONG Y
If (brck_Y == 0)
	elemY = Ceil(n_y/2);
Else
	elemY = Floor(n_y/2);
EndIf
// BRICK LAYERS ALONG X
If (brck_X == 0)
	elemX = Ceil(n_x/2);
Else
	elemX = Floor(n_x/2);
EndIf
// BRICKS PER Z-LAYER
elem = elemX * elemY;

// BRICK LAYERS ALONG Z
If (brck_Z == 0)
	elemZ = Ceil(n_z/2);
Else
	elemZ = Floor(n_z/2);
EndIf
//-------------------------------------------------------------------------------------------
// ESTABLISH THE AMOUNT OF HEADJOINT-Y VOLUMES PER BRICK Z-LAYER, DEPENDING ON THE ORDER
// {brick, interface} IN THE INPUT PARAMETERS br_x[], br_y[] AND br_z[]
If (brck_Y == 0)
	hjY_Y = Floor(n_y/2);
Else
	hjY_Y = Ceil(n_y/2);
EndIf
If (brck_X == 0)
	hjY_X = Ceil(n_x/2);
Else
	hjY_X = Floor(n_x/2);
EndIf

hjY_Z = hjY_X * hjY_Y;
//-------------------------------------------------------------------------------------------
// ESTABLISH THE AMOUNT OF HEADJOINT-X VOLUMES PER BRICK Z-LAYER, DEPENDING ON THE ORDER
// {brick, interface} IN THE INPUT PARAMETERS br_x[], br_y[] AND br_z[]
If (brck_Y == 0)
	hjX_Y = Ceil(n_y/2);
Else
	hjX_Y = Floor(n_y/2);
EndIf
If (brck_X == 0)
	hjX_X = Floor(n_x/2);
Else
	hjX_X = Ceil(n_x/2);
EndIf

hjX_Z = hjX_X * hjX_Y;
//-------------------------------------------------------------------------------------------
// RETRIEVE BRICK VOLUMES WITH SURFACES AT Y=0 AND Y=W

VolYmin[] = {};
VolYmax[] = {};
For Zlyr In {0 : elemZ-1}
	VolYmin[] = {VolYmin[], brick[ {elem*Zlyr : elem*Zlyr+(elemX-1) } ]};
	VolYmax[] = {VolYmax[], brick[ {elem*Zlyr+(elem-elemX) : elem*Zlyr+(elem-1) } ]};
EndFor
//-------------------------------------------------------------------------------------------
// EXTRACT SURFACES AT Y=0 AND Y=W FROM THE LIST OF VOLUMES ABOVE

Ymin[] = {};
Ymax[] = {};
For vol In {0 : #VolYmin[]-1}
	Smin[] = Boundary{ Volume{VolYmin[vol]}; };
	Ymin[] = {Ymin[], Smin[2]};
	
	Smax[] = Boundary{ Volume{VolYmax[vol]}; };
	Ymax[] = {Ymax[], Smax[4]};
EndFor
//-------------------------------------------------------------------------------------------
// SEPARATE THE BEDJOINTS BELONGING TO THE ARCH SPRINGINGS FROM THE REST, AS THEY MAY BE
// MODELLED WITH DIFFERENT MATERIAL PROPERTIES!
// - IN THE ABSENCE OF SUCH BEDJOINTS, A WARNING IS RAISED
// - IF PRESENT, THEN bedjt[] IS UPDATED TO EXCLUDE THEM

ASki[] = {};
bjI = 0;
bjE = #bedjt[]-1;

If (brck_Z != 0)
	ASki[] = { ASki[], bedjt[{0 : elem-1}] };
	bjI = elem;

	If (n_z%2 != 0)
		ASki[] = { ASki[], bedjt[{#bedjt[]-elem : #bedjt[]-1}] };
		bjE = #bedjt[]-elem-1;
	Else
		Printf("WARNING: Arch springings with no physical interface!");
		Printf("         (Ignore if this is intended)");
	EndIf
Else
	Printf("WARNING: Arch springings with no physical interface!");
	Printf("         (Ignore if this is intended)");
EndIf

bedjt[] = bedjt[{bjI : bjE}];

// NOTE: EVEN IF bedjt[] IS UPDATED, THE ORDER IN WHICH THE REMAINING BEDJOINT VOLUMES ARE
//	 STORED DOES NOT CHANGE
//-------------------------------------------------------------------------------------------
// SEPARATE THE X-HEADJOINTS BELONGING TO THE ARCH EXTRADOS FROM THE REST, AS THEY MAY BE
// MODELLED WITH DIFFERENT MATERIAL PROPERTIES!
// - IN THE ABSENCE OF SUCH X-HEADJOINTS, A WARNING IS RAISED
// - IF PRESENT, THEN hdjtX[] IS UPDATED TO EXCLUDE THEM

ABfi[] = {};
auxhj[] = {};

If (brck_X != 0)
	ABfi[] = {ABfi[], hdjtX[{0 : #hdjtX[]-1 : Ceil(n_x/2)}]};

	For lyZ In {0 : elemZ-1}
		For Yrow In {0 : hjX_X-2}
			start_hj = 1;
	
			slc_stt1 = start_hj + Yrow + (hjX_Z)*lyZ;
			slc_end1 = slc_stt1 + (hjX_Y-1)*hjX_X;
	
			auxhj[] = { auxhj[], hdjtX[ {slc_stt1 : slc_end1 : hjX_X} ] };
		EndFor
	EndFor
		
	//For hjind In {1 : hjX_X-1}
	//	auxhj[] = { auxhj[], hdjtX[ {hjind : #hdjtX[]-1 : Ceil(n_x/2)} ] };
	//EndFor
	
	// UPDATE hdjtX[] TO EXCLUDE VOLUMES IN ABfi[]
	hdjtX[] = auxhj[];
Else
	Printf("WARNING: Arch extrados with no physical interface!");
	Printf("         (Ignore if this is intended)");
EndIf

// NOTE: IF hdjtX[] IS UPDATED, KEEP IN MIND THAT THE ORDER IN WHICH THE REMAINING X-HEADJOINT
//	 VOLUMES ARE STORED DOES INDEED CHANGE!
//	 BEFORE THE UPDATE, THE ORDERING FOLLOWS THE LOCAL Y AXIS IN A GIVEN BRICK Z-LAYER
//	 AFTER THE UPDATE, THE ORDERING FOLLOWS THE LOCAL X AXIS IN A GIVEN BRICK Z-LAYER
//-------------------------------------------------------------------------------------------
// COMPARE THE ARCH THICKNESS AS GIVEN BY:
// (1) THE Th PARAMETER IN General_Input (I.E. THE LENGTH OF THE INCLINED SKEWBACK EDGE)
// (2) THE SUM OF THICKNESSES ALONG LOCAL X IN THE ARCH, ACCOUNTING FOR POTENTIAL MORTAR 'CONTRACTION'
If (brck_X == 0)
	If (n_x%2 != 0)
		Th2 = width;
	ElseIf (n_x%2 == 0)
		Th2 = width - br_x[1]/2;
	EndIf
ElseIf (brck_X == 1)
	If (n_x%2 != 0)
		Th2 = width - br_x[0];
	ElseIf (n_x%2 == 0)
		Th2 = width - br_x[0]/2;
	EndIf
EndIf
Printf("Arch thickness measured as length of inclined skewback side: ", Th);
Printf("Arch thickness measured as sum of brick and mortar layers' thickness: ", Th2);
//-------------------------------------------------------------------------------------------
// COMPARE THE ARCH Y-WIDTH AS GIVEN BY:
// (1) THE W PARAMETER IN General_Input
// (2) THE SUM OF THICKNESSES ALONG LOCAL Y IN THE ARCH, ACCOUNTING FOR POTENTIAL MORTAR 'CONTRACTION'
Ywidth = 0;
For i In {0 : n_y-1}
	Ywidth += br_y[i%(#br_y[])];
EndFor

If (brck_Y == 0)
	If (n_y%2 != 0)
		W2 = Ywidth;
	ElseIf (n_y%2 == 0)
		W2 = Ywidth - br_y[1]/2;
	EndIf
ElseIf (brck_Y == 1)
	If (n_y%2 != 0)
		W2 = Ywidth - br_y[0];
	ElseIf (n_y%2 == 0)
		W2 = Ywidth - br_y[0]/2;
	EndIf
EndIf
Printf("Arch Y-width measured as Y-width of the skewback: ", W);
Printf("Arch Y-width measured as sum of brick and mortar layers' thickness: ", W2);
//-------------------------------------------------------------------------------------------
// ASSIGN TO PHYSICAL SURFACES BY UPDATING LISTS INITIALISED EXTERNALLY

// ASSIGN PHYSICAL SURFACES TO RESTRAIN DISPLACEMENTS AT Y=0 AND Y=W
Physical Surface ("r_y") += {Ymin[], Ymax[]};
//-------------------------------------------------------------------------------------------
// ASSIGNING OF PHYSICAL VOLUMES IS PERFORMED ACCORDING TO THE BOND TYPE!
// THE APPROPRIATE MACRO IS SELECTED DEPENDING ON Abt IN General_Input:

If (Abt == 1)
	Call ABond_Type01;	// << RUNNING BOND IN XY AND YZ
ElseIf (Abt == 2)
	Call ABond_Type02;	// << RUNNING BOND IN XY AND XZ
ElseIf (Abt == 3)
	Call ABond_Type03;	// << 
EndIf
//-------------------------------------------------------------------------------------------

Return
