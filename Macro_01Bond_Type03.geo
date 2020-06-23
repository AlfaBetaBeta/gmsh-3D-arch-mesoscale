/*********************************************************************
 *
 *  Macro Bond_Type03
 *
 *  BRICK PATTERN TO MATCH = 
 *
 *********************************************************************/
// DISTRIBUTE ALL JOINTS AS EXTRACTED ELSEWHERE (Macro PhysicalSTRIP) TO
// MATCH A BRICK PATTERN, BY DISTINGUISHING WHICH REPRESENT REAL MORTAR AND
// WHICH ARE ACTUALLY PART OF THE BRICK BULK


Macro ABond_Type03

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
// UPDATE LISTS OF X-HEADJOINTS (MORTAR AND BRICK BULK)

// RECALL FROM NOTE ON MACRO PhysicalSTRIP THAT DEPENDING ON THE POTENTIAL UPDATING OF hdjtX[]
// (DUE TO THE EXISTENCE OF A PHYSICAL INTERFACE AT THE ARCH EXTRADOS) THE ORDERING OF THE
// VOLUMES STORED IN hdjtX[] MAY BE DIFFERENT!

//-----------------------
// BRICK Z-LAYERS TYPE 1
//-----------------------
If (#ABfi[] == 0)

	slc_ind1[] = {}; slc_ind2[] = {};
	For ind In {0 : (hjX_X-1)}
		If (ind%4 != 0)
			slc_ind1[] = {slc_ind1[], ind};
		ElseIf (ind%4 == 0)
			slc_ind2[] = {slc_ind2[], ind};
		EndIf
	EndFor

	slc_ind3[] = {}; slc_ind4[] = {};
	For ind In {0 : (hjX_X-1)}
		If ((ind+2)%4 != 0)
			slc_ind3[] = {slc_ind3[], ind};
		ElseIf ((ind+2)%4 == 0)
			slc_ind4[] = {slc_ind4[], ind};
		EndIf
	EndFor

	For lyZ In {0 : elemZ-1 : 3}
		For Xrow In {0 : hjX_Y-1 : 3}
			start_hj = 0;

			slc_stt1 = start_hj + hjX_X*Xrow + hjX_Z*lyZ;
			slc_end1 = hjX_X*Xrow + hjX_Z*lyZ + (hjX_X-1);

			aux_slc[] = hdjtX[{ slc_stt1 : slc_end1 };

			jHJX[] = {jHJX[], hdjtX[{ aux_slc[ {slc_ind1[]} ] }]};
			jBBX[] = {jBBX[], hdjtX[{ aux_slc[ {slc_ind2[]} ] }]};
		EndFor
		For Xrow In {1 : hjX_Y-1 : 3}
			start_hj = 0;

			slc_stt1 = start_hj + hjX_X*Xrow + hjX_Z*lyZ;
			slc_end1 = hjX_X*Xrow + hjX_Z*lyZ + (hjX_X-1);

			jHJX[] = {jHJX[], hdjtX[{ slc_stt1 : slc_end1 }]};
		EndFor
		For Xrow In {2 : hjX_Y-1 : 3}
			start_hj = 0;

			slc_stt1 = start_hj + hjX_X*Xrow + hjX_Z*lyZ;
			slc_end1 = hjX_X*Xrow + hjX_Z*lyZ + (hjX_X-1);

			aux_slc[] = hdjtX[{ slc_stt1 : slc_end1 };

			jHJX[] = {jHJX[], hdjtX[{ aux_slc[ {slc_ind3[]} ] }]};
			jBBX[] = {jBBX[], hdjtX[{ aux_slc[ {slc_ind4[]} ] }]};
		EndFor
	EndFor

ElseIf (#ABfi[] != 0)

	slc_ind1[] = {}; slc_ind2[] = {};
	For ind In {0 : (hjX_Y-1)}
		If (ind%3 != 0)
			slc_ind1[] = {slc_ind1[], ind};
		ElseIf (ind%3 == 0)
			slc_ind2[] = {slc_ind2[], ind};
		EndIf
	EndFor

	slc_ind3[] = {}; slc_ind4[] = {};
	For ind In {0 : (hjX_Y-1)}
		If ((ind+1)%3 != 0)
			slc_ind3[] = {slc_ind3[], ind};
		ElseIf ((ind+1)%3 == 0)
			slc_ind4[] = {slc_ind4[], ind};
		EndIf
	EndFor
	
	For lyZ In {0 : elemZ-1 : 3}
		For Yrow In {0 : hjX_X-2 : 4}
			start_hj = 0;

			slc_stt1 = start_hj + hjX_Y*Yrow + (hjX_Z-hjX_Y)*lyZ;
			slc_end1 = slc_stt1 + (hjX_Y-1);

			aux_slc[] = hdjtX[ {slc_stt1 : slc_end1} ];
			
			jHJX[] = { jHJX[], aux_slc[ {slc_ind1[]} ] };
			jBBX[] = { jBBX[], aux_slc[ {slc_ind2[]} ] };
		EndFor
		
		For Yrow In {1 : hjX_X-2 : 2}
			start_hj = 0;

			slc_stt1 = start_hj + hjX_Y*Yrow + (hjX_Z-hjX_Y)*lyZ;
			slc_end1 = slc_stt1 + (hjX_Y-1);

			jHJX[] = { jHJX[], hdjtX[{ slc_stt1 : slc_end1 }] };
		EndFor
		For Yrow In {2 : hjX_X-2 : 4}
			start_hj = 0;

			slc_stt1 = start_hj + hjX_Y*Yrow + (hjX_Z-hjX_Y)*lyZ;
			slc_end1 = slc_stt1 + (hjX_Y-1);

			aux_slc[] = hdjtX[ {slc_stt1 : slc_end1} ];

			jHJX[] = { jHJX[], aux_slc[ {slc_ind3[]} ] };
			jBBX[] = { jBBX[], aux_slc[ {slc_ind4[]} ] };
		EndFor
	EndFor

EndIf

//-----------------------
// BRICK Z-LAYERS TYPE 2
//-----------------------
If (#ABfi[] == 0)

	slc_ind1[] = {}; slc_ind2[] = {};
	For ind In {0 : (hjX_X-1)}
		If ((ind+2)%4 != 0)
			slc_ind1[] = {slc_ind1[], ind};
		ElseIf ((ind+2)%4 == 0)
			slc_ind2[] = {slc_ind2[], ind};
		EndIf
	EndFor

	slc_ind3[] = {}; slc_ind4[] = {};
	For ind In {0 : (hjX_X-1)}
		If (ind%4 != 0)
			slc_ind3[] = {slc_ind3[], ind};
		ElseIf (ind%4 == 0)
			slc_ind4[] = {slc_ind4[], ind};
		EndIf
	EndFor

	For lyZ In {1 : elemZ-1 : 3}
		For Xrow In {0 : hjX_Y-1 : 3}
			start_hj = 0;

			slc_stt1 = start_hj + hjX_X*Xrow + hjX_Z*lyZ;
			slc_end1 = hjX_X*Xrow + hjX_Z*lyZ + (hjX_X-1);

			aux_slc[] = hdjtX[{ slc_stt1 : slc_end1 }];

			jHJX[] = {jHJX[], hdjtX[{ aux_slc[ {slc_ind1[]} ] }]};
			jBBX[] = {jBBX[], hdjtX[{ aux_slc[ {slc_ind2[]} ] }]};
		EndFor
		For Xrow In {1 : hjX_Y-1 : 3}
			start_hj = 0;

			slc_stt1 = start_hj + hjX_X*Xrow + hjX_Z*lyZ;
			slc_end1 = hjX_X*Xrow + hjX_Z*lyZ + (hjX_X-1);

			jHJX[] = {jHJX[], hdjtX[{ slc_stt1 : slc_end1 }]};
		EndFor
		For Xrow In {2 : hjX_Y-1 : 3}
			start_hj = 0;

			slc_stt1 = start_hj + hjX_X*Xrow + hjX_Z*lyZ;
			slc_end1 = hjX_X*Xrow + hjX_Z*lyZ + (hjX_X-1);

			aux_slc[] = hdjtX[{ slc_stt1 : slc_end1 }];

			jHJX[] = {jHJX[], hdjtX[{ aux_slc[ {slc_ind3[]} ] }]};
			jBBX[] = {jBBX[], hdjtX[{ aux_slc[ {slc_ind4[]} ] }]};
		EndFor
	EndFor

ElseIf (#ABfi[] != 0)

	slc_ind1[] = {}; slc_ind2[] = {};
	For ind In {0 : (hjX_Y-1)}
		If ((ind+1)%3 != 0)
			slc_ind1[] = {slc_ind1[], ind};
		ElseIf ((ind+1)%3 == 0)
			slc_ind2[] = {slc_ind2[], ind};
		EndIf
	EndFor

	slc_ind3[] = {}; slc_ind4[] = {};
	For ind In {0 : (hjX_Y-1)}
		If (ind%3 != 0)
			slc_ind3[] = {slc_ind3[], ind};
		ElseIf (ind%3 == 0)
			slc_ind4[] = {slc_ind4[], ind};
		EndIf
	EndFor

	For lyZ In {1 : elemZ-1 : 3}
		For Yrow In {0 : hjX_X-2 : 4}
			start_hj = 0;

			slc_stt1 = start_hj + hjX_Y*Yrow + (hjX_Z-hjX_Y)*lyZ;
			slc_end1 = slc_stt1 + (hjX_Y-1);

			aux_slc[] = hdjtX[ {slc_stt1 : slc_end1} ];

			jHJX[] = { jHJX[], aux_slc[ {slc_ind1[]} ] };
			jBBX[] = { jBBX[], aux_slc[ {slc_ind2[]} ] };
		EndFor
		For Yrow In {1 : hjX_X-2 : 2}
			start_hj = 0;

			slc_stt1 = start_hj + hjX_Y*Yrow + (hjX_Z-hjX_Y)*lyZ;
			slc_end1 = slc_stt1 + (hjX_Y-1);

			jHJX[] = { jHJX[], hdjtX[ {slc_stt1 : slc_end1} ] };
		EndFor
		For Yrow In {2 : hjX_X-2 : 4}
			start_hj = 0;

			slc_stt1 = start_hj + hjX_Y*Yrow + (hjX_Z-hjX_Y)*lyZ;
			slc_end1 = slc_stt1 + (hjX_Y-1);

			aux_slc[] = hdjtX[ {slc_stt1 : slc_end1} ];

			jHJX[] = { jHJX[], aux_slc[ {slc_ind3[]} ] };
			jBBX[] = { jBBX[], aux_slc[ {slc_ind4[]} ] };
		EndFor
	EndFor

EndIf

//-----------------------
// BRICK Z-LAYERS TYPE 3
//-----------------------
If (#ABfi[] == 0)

	slc_ind1[] = {}; slc_ind2[] = {};
	For ind In {0 : (hjX_X-1)}
		If (ind%4 != 0)
			slc_ind1[] = {slc_ind1[], ind};
		ElseIf (ind%4 == 0)
			slc_ind2[] = {slc_ind2[], ind};
		EndIf
	EndFor

	slc_ind3[] = {}; slc_ind4[] = {};
	For ind In {0 : (hjX_X-1)}
		If ((ind+2)%4 != 0)
			slc_ind3[] = {slc_ind3[], ind};
		ElseIf ((ind+2)%4 == 0)
			slc_ind4[] = {slc_ind4[], ind};
		EndIf
	EndFor

	For lyZ In {2 : elemZ-1 : 3}
		For Xrow In {0 : 0}
			start_hj = 0;

			slc_stt1 = start_hj + hjX_X*Xrow + hjX_Z*lyZ;
			slc_end1 = hjX_X*Xrow + hjX_Z*lyZ + (hjX_X-1);

			jHJX[] = {jHJX[], hdjtX[{ slc_stt1+1 : slc_end1 : 2}]};
			jBBX[] = {jBBX[], hdjtX[{ slc_stt1 : slc_end1 : 2}]};
		EndFor
		For Xrow In {1 : hjX_Y-1 : 3}
			start_hj = 0;

			slc_stt1 = start_hj + hjX_X*Xrow + hjX_Z*lyZ;
			slc_end1 = hjX_X*Xrow + hjX_Z*lyZ + (hjX_X-1);

			aux_slc[] = hdjtX[{ slc_stt1 : slc_end1 }];

			jHJX[] = {jHJX[], hdjtX[{ aux_slc[ {slc_ind1[]} ] }]};
			jBBX[] = {jBBX[], hdjtX[{ aux_slc[ {slc_ind2[]} ] }]};
		EndFor
		For Xrow In {2 : hjX_Y-1 : 3}
			start_hj = 0;

			slc_stt1 = start_hj + hjX_X*Xrow + hjX_Z*lyZ;
			slc_end1 = hjX_X*Xrow + hjX_Z*lyZ + (hjX_X-1);

			jHJX[] = {jHJX[], hdjtX[{ slc_stt1 : slc_end1 }]};
		EndFor
		For Xrow In {3 : hjX_Y-1 : 3}
			start_hj = 0;

			slc_stt1 = start_hj + hjX_X*Xrow + hjX_Z*lyZ;
			slc_end1 = hjX_X*Xrow + hjX_Z*lyZ + (hjX_X-1);

			aux_slc[] = hdjtX[{ slc_stt1 : slc_end1 }];

			jHJX[] = {jHJX[], hdjtX[{ aux_slc[ {slc_ind3[]} ] }]};
			jBBX[] = {jBBX[], hdjtX[{ aux_slc[ {slc_ind4[]} ] }]};
		EndFor
	EndFor

ElseIf (#ABfi[] != 0)

	slc_ind1[] = {}; slc_ind2[] = {0};
	For ind In {1 : (hjX_Y-1)}
		If ((ind+2)%3 != 0)
			slc_ind1[] = {slc_ind1[], ind};
		ElseIf ((ind+2)%3 == 0)
			slc_ind2[] = {slc_ind2[], ind};
		EndIf
	EndFor

	slc_ind3[] = {}; slc_ind4[] = {};
	For ind In {0 : (hjX_Y-1)}
		If (ind%3 != 0)
			slc_ind3[] = {slc_ind3[], ind};
		ElseIf (ind%3 == 0)
			slc_ind4[] = {slc_ind4[], ind};
		EndIf
	EndFor

	For lyZ In {2 : elemZ-1 : 3}
		For Yrow In {0 : hjX_X-2 : 4}
			start_hj = 0;

			slc_stt1 = start_hj + hjX_Y*Yrow + (hjX_Z-hjX_Y)*lyZ;
			slc_end1 = slc_stt1 + (hjX_Y-1);

			aux_slc[] = hdjtX[ {slc_stt1 : slc_end1} ];

			jHJX[] = { jHJX[], aux_slc[ {slc_ind1[]} ] };
			jBBX[] = { jBBX[], aux_slc[ {slc_ind2[]} ] };
		EndFor
		For Yrow In {1 : hjX_X-2 : 2}
			start_hj = 0;

			slc_stt1 = start_hj + hjX_Y*Yrow + (hjX_Z-hjX_Y)*lyZ;
			slc_end1 = slc_stt1 + (hjX_Y-1);

			jHJX[] = { jHJX[], hdjtX[ {slc_stt1 : slc_end1} ] };
		EndFor
		For Yrow In {2 : hjX_X-2 : 4}
			start_hj = 0;

			slc_stt1 = start_hj + hjX_Y*Yrow + (hjX_Z-hjX_Y)*lyZ;
			slc_end1 = slc_stt1 + (hjX_Y-1);

			aux_slc[] = hdjtX[ {slc_stt1 : slc_end1} ];

			jHJX[] = { jHJX[], aux_slc[ {slc_ind3[]} ] };
			jBBX[] = { jBBX[], aux_slc[ {slc_ind4[]} ] };
		EndFor
	EndFor

EndIf
//-------------------------------------------------------------------------------------------
// UPDATE LISTS OF Y-HEADJOINTS (MORTAR AND BRICK BULK)

//-----------------------
// BRICK Z-LAYERS TYPE 1
//-----------------------
slc_ind1[] = {}; slc_ind2[] = {};
slc_ind3[] = {}; slc_ind4[] = {};
For ind In {0 : (hjY_X-1)}
	If ((ind+2)%4 == 0 || (ind+1)%4 == 0)
		slc_ind2[] = {slc_ind2[], ind};
		slc_ind3[] = {slc_ind3[], ind};
	Else
		slc_ind1[] = {slc_ind1[], ind};
		slc_ind4[] = {slc_ind4[], ind};
	EndIf
EndFor

For lyZ In {0 : elemZ-1 : 3}
	For Xrow In {0 : hjY_Y-1 : 3}
		start_hj = 0;

		slc_stt1 = start_hj + hjY_X*Xrow + hjY_Z*lyZ;
		slc_end1 = slc_stt1 + (hjY_X-1);

		aux_slc[] = hdjtY[ {slc_stt1 : slc_end1} ];

		jHJY[] = { jHJY[], aux_slc[ {slc_ind1[]} ] };
		jBBY[] = { jBBY[], aux_slc[ {slc_ind2[]} ] };
	EndFor
	For Xrow In {1 : hjY_Y-1 : 3}
		start_hj = 0;

		slc_stt1 = start_hj + hjY_X*Xrow + hjY_Z*lyZ;
		slc_end1 = slc_stt1 + (hjY_X-1);

		aux_slc[] = hdjtY[ {slc_stt1 : slc_end1} ];

		jHJY[] = { jHJY[], aux_slc[ {slc_ind3[]} ] };
		jBBY[] = { jBBY[], aux_slc[ {slc_ind4[]} ] };
	EndFor
	For Xrow In {2 : hjY_Y-1 : 3}
		start_hj = 0;

		slc_stt1 = start_hj + hjY_X*Xrow + hjY_Z*lyZ;
		slc_end1 = slc_stt1 + (hjY_X-1);

		jHJY[] = { jHJY[], hdjtY[ {slc_stt1 : slc_end1} ] };
	EndFor
EndFor

//-----------------------
// BRICK Z-LAYERS TYPE 2
//-----------------------
slc_ind1[] = {}; slc_ind2[] = {};
slc_ind3[] = {}; slc_ind4[] = {};
For ind In {0 : (hjY_X-1)}
	If ((ind+2)%4 == 0 || (ind+1)%4 == 0)
		slc_ind1[] = {slc_ind1[], ind};
		slc_ind4[] = {slc_ind4[], ind};
	Else
		slc_ind2[] = {slc_ind2[], ind};
		slc_ind3[] = {slc_ind3[], ind};
	EndIf
EndFor

For lyZ In {1 : elemZ-1 : 3}
	For Xrow In {0 : hjY_Y-1 : 3}
		start_hj = 0;

		slc_stt1 = start_hj + hjY_X*Xrow + hjY_Z*lyZ;
		slc_end1 = slc_stt1 + (hjY_X-1);

		aux_slc[] = hdjtY[ {slc_stt1 : slc_end1} ];

		jHJY[] = { jHJY[], aux_slc[ {slc_ind1[]} ] };
		jBBY[] = { jBBY[], aux_slc[ {slc_ind2[]} ] };
	EndFor
	For Xrow In {1 : hjY_Y-1 : 3}
		start_hj = 0;

		slc_stt1 = start_hj + hjY_X*Xrow + hjY_Z*lyZ;
		slc_end1 = slc_stt1 + (hjY_X-1);

		aux_slc[] = hdjtY[ {slc_stt1 : slc_end1} ];

		jHJY[] = { jHJY[], aux_slc[ {slc_ind3[]} ] };
		jBBY[] = { jBBY[], aux_slc[ {slc_ind4[]} ] };
	EndFor
	For Xrow In {2 : hjY_Y-1 : 3}
		start_hj = 0;

		slc_stt1 = start_hj + hjY_X*Xrow + hjY_Z*lyZ;
		slc_end1 = slc_stt1 + (hjY_X-1);

		jHJY[] = { jHJY[], hdjtY[ {slc_stt1 : slc_end1} ] };
	EndFor
EndFor

//-----------------------
// BRICK Z-LAYERS TYPE 3
//-----------------------
slc_ind1[] = {}; slc_ind2[] = {};
slc_ind3[] = {}; slc_ind4[] = {};
For ind In {0 : (hjY_X-1)}
	If ((ind+2)%4 == 0 || (ind+1)%4 == 0)
		slc_ind2[] = {slc_ind2[], ind};
		slc_ind3[] = {slc_ind3[], ind};
	Else
		slc_ind1[] = {slc_ind1[], ind};
		slc_ind4[] = {slc_ind4[], ind};
	EndIf
EndFor

For lyZ In {2 : elemZ-1 : 3}
	For Xrow In {0 : 0}
		start_hj = 0;

		slc_stt1 = start_hj + hjY_X*Xrow + hjY_Z*lyZ;
		slc_end1 = slc_stt1 + (hjY_X-1);

		jHJY[] = { jHJY[], hdjtY[ {slc_stt1 : slc_end1} ] };
	EndFor
	For Xrow In {1 : hjY_Y-1 : 3}
		start_hj = 0;

		slc_stt1 = start_hj + hjY_X*Xrow + hjY_Z*lyZ;
		slc_end1 = slc_stt1 + (hjY_X-1);

		aux_slc[] = hdjtY[ {slc_stt1 : slc_end1} ];

		jHJY[] = { jHJY[], aux_slc[ {slc_ind1[]} ] };
		jBBY[] = { jBBY[], aux_slc[ {slc_ind2[]} ] };
	EndFor
	For Xrow In {2 : hjY_Y-1 : 3}
		start_hj = 0;

		slc_stt1 = start_hj + hjY_X*Xrow + hjY_Z*lyZ;
		slc_end1 = slc_stt1 + (hjY_X-1);

		aux_slc[] = hdjtY[ {slc_stt1 : slc_end1} ];

		jHJY[] = { jHJY[], aux_slc[ {slc_ind3[]} ] };
		jBBY[] = { jBBY[], aux_slc[ {slc_ind4[]} ] };
	EndFor
	For Xrow In {3 : hjY_Y-1 : 3}
		start_hj = 0;

		slc_stt1 = start_hj + hjY_X*Xrow + hjY_Z*lyZ;
		slc_end1 = slc_stt1 + (hjY_X-1);

		jHJY[] = { jHJY[], hdjtY[ {slc_stt1 : slc_end1} ] };
	EndFor
EndFor
//-------------------------------------------------------------------------------------------
// ASSIGN TO PHYSICAL VOLUMES BY UPDATING LISTS INITIALISED EXTERNALLY

// ASSIGN PHYSICAL VOLUMES TO GROUPS (MATERIALS)
Physical Volume ("g_Abr")   += {brick[]};		// BRICKS
Physical Volume ("g_Abj") += {bedjt[]};			// BEDJOINTS
Physical Volume ("g_AhjY") += {jHJY[]};			// HEADJOINTS (Y=ct) = MORTAR
Physical Volume ("g_AhjX") += {jHJX[]};			// HEADJOINTS (X=ct) = MORTAR
Physical Volume ("g_Abb") += {jBBX[]};			// HEADJOINTS (X=ct) = BRICK BULK
Physical Volume ("g_Abb") += {jBBY[]};			// HEADJOINTS (Y=ct) = BRICK BULK

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
