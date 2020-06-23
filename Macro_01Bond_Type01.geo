/*********************************************************************
 *
 *  Macro Bond_Type01
 *
 *  BRICK PATTERN TO MATCH = RUNNING BOND ON PLANES XY AND YZ
 *
 *********************************************************************/
// DISTRIBUTE ALL JOINTS AS EXTRACTED ELSEWHERE (Macro PhysicalSTRIP) TO
// MATCH A BRICK PATTERN, BY DISTINGUISHING WHICH REPRESENT REAL MORTAR AND
// WHICH ARE ACTUALLY PART OF THE BRICK BULK


Macro ABond_Type01

/*
IN:	brck_X  = ***aux parameters generated in macro SubsetPierHd***
	brck_Y  = 
	brck_Z  = 

	hdjtY[] = List with ALL headjoint-Y volumes, to be sorted into output lists
	brick[] = ***all 4 parameters inherited from macro PhysicalSTRIP***
	bedjt[] = 
	hdjtX[] = 

	Pn_x	= ***geometric input parameters in General_Input***
	Pn_y	= 
	Pn_z	= 

OUT: 	jHJY[]  = Joint layer actually representing headjoint-Y mortar
	jBBY[]  = Joint layer embedded in brick bulk (connecting brick halves along Y)

	elemX	= aux variables
	elemY	= 
	elemZ	= 
	elem	= 

*/
//-------------------------------------------------------------------------------------------
// INITIALISE OUTPUT LISTS (DEPENDING ON THE BOND TYPE, SOME MAY REMAIN UNUSED)
jHJY[] = {};
jBBY[] = {};

jHJX[] = {};
jBBX[] = {};
//-------------------------------------------------------------------------------------------
// UPDATE OUTPUT LISTS
For lyZ In {0 : elemZ-1}
	For Xrow In {0 : hjY_Y-1}
		start_hj = Abs(Xrow%2 - lyZ%2);

		slc_stt1 = start_hj + hjY_X*Xrow + hjY_Z*lyZ;
		slc_end1 = hjY_X*Xrow + hjY_Z*lyZ + (hjY_X-1);
		jHJY[] = {jHJY[], hdjtY[{ slc_stt1 : slc_end1 : 2 }]};

		slc_stt2 = Abs(start_hj-1) + hjY_X*Xrow + hjY_Z*lyZ;
		slc_end2 = hjY_X*Xrow + hjY_Z*lyZ + (hjY_X-1);
		jBBY[] = {jBBY[], hdjtY[{ slc_stt2 : slc_end2 : 2 }]};
	EndFor
EndFor
//-------------------------------------------------------------------------------------------
// ASSIGN TO PHYSICAL VOLUMES BY UPDATING LISTS INITIALISED EXTERNALLY

// ASSIGN PHYSICAL VOLUMES TO GROUPS (MATERIALS)
Physical Volume ("g_Abr")   += {brick[]};		// BRICKS
Physical Volume ("g_Abj") += {bedjt[]};			// BEDJOINTS
Physical Volume ("g_AhjY") += {jHJY[]};			// HEADJOINTS (Y=ct) = MORTAR
Physical Volume ("g_AhjX") += {hdjtX[]};		// HEADJOINTS (X=ct)
Physical Volume ("g_Abb") += {jBBY[]};			// HEADJOINTS (Y=ct) = BRICK BULK

If (#ASki[] != 0)
	Physical Volume ("g_ASki")   += {ASki[]};		// PHYSICAL INTERFACE ARCH-SKEWBACK
EndIf
If (#ABfi[] != 0)
	Physical Volume ("g_ABfi")   += {ABfi[]};		// PHYSICAL INTERFACE ARCH-BACKFILL
EndIf

// ASSIGN PHYSICAL VOLUMES TO JOINT LAYERS BECOMING INTERFACE ELEMENTS
Physical Volume ("br2in")   += {bedjt[], jHJY[], jBBY[], hdjtX[], ASki[], ABfi[]};

// ASSIGN PHYSICAL VOLUMES TO BRICKS FOR SELF-WEIGHT
If (ref == 1)
	Physical Volume ("init_udl1_0_0_-20000") += {brick[]};
ElseIf (ref == 1000)
	Physical Volume ("init_udl1_0_0_-0.00002") += {brick[]};
EndIf
//-------------------------------------------------------------------------------------------

Return
