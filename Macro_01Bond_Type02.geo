/*********************************************************************
 *
 *  Macro Bond_Type02
 *
 *  BRICK PATTERN TO MATCH = RUNNING BOND ON PLANES XY AND XZ
 *
 *********************************************************************/
// DISTRIBUTE ALL JOINTS AS EXTRACTED ELSEWHERE (Macro PhysicalSTRIP) TO
// MATCH A BRICK PATTERN, BY DISTINGUISHING WHICH REPRESENT REAL MORTAR AND
// WHICH ARE ACTUALLY PART OF THE BRICK BULK


Macro ABond_Type02

/*
IN:	brck_X  = ***aux parameters generated in macro SubsetPierHd***
	brck_Y  = 
	brck_Z  = 

	hdjtX[] = List with ALL headjoint-X volumes, to be sorted into output lists
	brick[] = ***all 4 parameters inherited from macro PhysicalSTRIP***
	bedjt[] = 
	hdjtY[] = 

	Pn_x	= ***geometric input parameters in General_Input***
	Pn_y	= 
	Pn_z	= 

OUT: 	jHJX[]  = Joint layer actually representing headjoint-X mortar
	jBBX[]  = Joint layer embedded in brick bulk (connecting brick halves along X)

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

// RECALL FROM NOTE ON MACRO PhysicalSTRIP THAT DEPENDING ON THE POTENTIAL UPDATING OF hdjtX[]
// (DUE TO THE EXISTENCE OF A PHYSICAL INTERFACE AT THE ARCH EXTRADOS) THE ORDERING OF THE
// VOLUMES STORED IN hdjtX[] MAY BE DIFFERENT!

If (#ABfi[] == 0)
	For lyZ In {0 : elemZ-1}
		For Xrow In {0 : hjX_Y-1}
			start_hj = Abs(Xrow%2 - lyZ%2);

			slc_stt1 = start_hj + hjX_X*Xrow + hjX_Z*lyZ;
			slc_end1 = hjX_X*Xrow + hjX_Z*lyZ + (hjX_X-1);
			jHJX[] = {jHJX[], hdjtX[{ slc_stt1 : slc_end1 : 2 }]};

			slc_stt2 = Abs(start_hj-1) + hjX_X*Xrow + hjX_Z*lyZ;
			slc_end2 = hjX_X*Xrow + hjX_Z*lyZ + (hjX_X-1);
			jBBX[] = {jBBX[], hdjtX[{ slc_stt2 : slc_end2 : 2 }]};
		EndFor
	EndFor
ElseIf (#ABfi[] != 0)
	For lyZ In {0 : elemZ-1}
		For Yrow In {0 : hjX_X-2}
			start_hj = Abs(Yrow%2 - lyZ%2);

			slc_stt1 = start_hj + hjX_Y*Yrow + (hjX_Z-hjX_Y)*lyZ;
			slc_end1 = hjX_Y*Yrow + (hjX_Z-hjX_Y)*lyZ + (hjX_Y-1);
			jHJX[] = {jHJX[], hdjtX[{ slc_stt1 : slc_end1 : 2 }]};

			slc_stt2 = Abs(start_hj-1) + hjX_Y*Yrow + (hjX_Z-hjX_Y)*lyZ;
			slc_end2 = hjX_Y*Yrow + (hjX_Z-hjX_Y)*lyZ + (hjX_Y-1);
			jBBX[] = {jBBX[], hdjtX[{ slc_stt2 : slc_end2 : 2 }]};
		EndFor
	EndFor
EndIf
//-------------------------------------------------------------------------------------------
// ASSIGN TO PHYSICAL VOLUMES BY UPDATING LISTS INITIALISED EXTERNALLY

// ASSIGN PHYSICAL VOLUMES TO GROUPS (MATERIALS)
Physical Volume ("g_Abr")   += {brick[]};		// BRICKS
Physical Volume ("g_Abj") += {bedjt[]};			// BEDJOINTS
Physical Volume ("g_AhjY") += {hdjtY[]};		// HEADJOINTS (Y=ct)
Physical Volume ("g_AhjX") += {jHJX[]};			// HEADJOINTS (X=ct) = MORTAR
Physical Volume ("g_Abb") += {jBBX[]};			// HEADJOINTS (X=ct) = BRICK BULK

If (#ASki[] != 0)
	Physical Volume ("g_ASki")   += {ASki[]};		// PHYSICAL INTERFACE ARCH-SKEWBACK
EndIf
If (#ABfi[] != 0)
	Physical Volume ("g_ABfi")   += {ABfi[]};		// PHYSICAL INTERFACE ARCH-BACKFILL
EndIf

// ASSIGN PHYSICAL VOLUMES TO JOINT LAYERS BECOMING INTERFACE ELEMENTS
Physical Volume ("br2in")   += {bedjt[], jHJX[], jBBX[], hdjtY[], ASki[], ABfi[]};

// ASSIGN PHYSICAL VOLUMES TO BRICKS FOR SELF-WEIGHT
If (ref == 1)
	Physical Volume ("init_udl1_0_0_-20000") += {brick[]};
ElseIf (ref == 1000)
	Physical Volume ("init_udl1_0_0_-0.00002") += {brick[]};
EndIf
//-------------------------------------------------------------------------------------------

Return
