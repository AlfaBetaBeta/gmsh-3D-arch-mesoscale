/*********************************************************************
 *
 *  Arch with interfaces
 *
 *********************************************************************/
//SetFactory("OpenCASCADE");
SetFactory("Built-in");

Mesh.ElementOrder=2;
Mesh.SecondOrderIncomplete=1;

Mesh.CharacteristicLengthMin = 5;
Mesh.CharacteristicLengthMax = 100;

//----------------------------------------------------------------------------------

Include "Macro_00InitEQSpIntrf.geo";
Include "Macro_01CrtArchIntrf.geo";
Include "Macro_01SubsetArSprng.geo";
Include "Macro_01VolToSurfLoad.geo";
Include "Macro_01PhysicalSTRIP.geo";
Include "Macro_01Bond_Type01.geo";
Include "Macro_01Bond_Type02.geo";
Include "Macro_01Bond_Type03.geo";
Include "General_Input.geo";

//----------------------------------------------------------------------------------
// GEOMETRIC AND DISCRETISATION INPUT SUPPLIED VIA "General_Input.geo"
//----------------------------------------------------------------------------------
// AUX MACRO FOR INTERNAL VARIABLES RE BRICK-MORTAR ARRANGEMENT
Call SubsetArSprng;
//----------------------------------------------------------------------------------
// INITIALISE LISTS FOR PHYSICAL VOLUME ASSIGNMENT LATER, VIA MACRO PhysicalSTRIP/BondType
Physical Volume ("g_Abr")   = {};	// BRICKS
Physical Volume ("g_Abj") = {};		// BEDJOINTS
Physical Volume ("g_AhjY") = {};	// HEADJOINTS (LOCAL Y=ct)
Physical Volume ("g_AhjX") = {};	// HEADJOINTS (LOCAL X=ct)
Physical Volume ("g_Abb") = {};		// 'EMBEDDED' JOINTS (INSIDE BRICK BULK)

Physical Volume ("g_ASki")   = {};	// PHYSICAL INTERFACE ARCH SPR. - SKEWBACK
Physical Volume ("g_ABfi")   = {};	// PHYSICAL INTERFACE ARCH EXTRAD. - BACKFILL

Physical Volume ("br2in") = {};		// JOINT LAYERS TO BECOME INTERFACE ELMTS
If (ref == 1)
	Physical Volume ("init_udl1_0_0_-20000") = {};		// BRICKS SELF-WEIGHT
ElseIf (ref == 1000)
	Physical Volume ("init_udl1_0_0_-0.00002") = {};	// BRICKS SELF-WEIGHT
EndIf
//----------------------------------------------------------------------------------
// INITIALISE LIST FOR PHYSICAL SURFACE ASSIGNMENT LATER, VIA MACRO PhysicalSTRIP
Physical Surface ("r_y") = {};		// RESTRAINTS FOR PLANE STRAIN STRIP
//----------------------------------------------------------------------------------
// CREATE ARCH
StrtPt = pA2;
Call CrtArchIntrf;

// ASSIGN PHYSICAL VOLUMES
Call PhysicalSTRIP;
//----------------------------------------------------------------------------------
// RETRIEVE LIST OF VOLUMES FORMING THE EXTRADOS
If (#ABfi[] != 0)
	extrados[] = ABfi[];
Else
	extrados[] = brick[ {0 : #brick[]-1 : elemX} ];
EndIf
//----------------------------------------------------------------------------------
// CHECK FEASABILITY OF LOADING INPUT
If (BZL > elemZ)
	Printf("ERROR: BZL in General_Input must be between 1 and %.0f", elemZ);
	Abort;
EndIf
//----------------------------------------------------------------------------------
// INITIAL CONDITIONS (CAREFUL WITH UNITS!!)
Call VolToSurfLoad;

Physical Surface("init_z_d_-0.2") = ArExtr2Ld[];	// << EDIT MANUALLY!
Physical Surface("init_z_v_-0.1") = ArExtr2Ld[];	// << EDIT MANUALLY!

// DYNAMIC LOADING
Physical Surface("dyna_z_a_c1_0.0") = ArExtr2Ld[];
//----------------------------------------------------------------------------------
