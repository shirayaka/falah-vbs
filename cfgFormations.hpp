class FalahGenericFormationBasePublic
{
	name = "Falah Generic base class formation for public";
	class Fixed
	{
		FormationPositionInfo0[] = {0,0,0,0};
	};

	class Pattern
	{
		FormationPositionInfo1[] = {-1,0,0,0};
	};
	
	reorderRules[] = {
		0,2,
		0,3,
		0,4,
		0,5,
		0,6,
		0,7,
		0,8,
		0,9,
		0,1
	};
};

class FalahGenericTeamWedgeLeftPublic: FalahGenericFormationBasePublic
{
	name = "Falah Generic Team Wedge Left Public";
	class Fixed
	{
		FormationPositionInfo0[] = {0, 0, 0, 0, true, "TL"};
		FormationPositionInfo1[] = {0, 5, -3, 6, true, "MG"};
		FormationPositionInfo2[] = {0, -5, -3, -6, true, "GL"};
		FormationPositionInfo3[] = {0, -10, -6, -12, true, "MKSM"};
		FormationPositionInfo4[] = {0, 10, -6, 12, true, "Any"};
		FormationPositionInfo5[] = {0, -15, -9, 18, true, "Any"};
	};
};

class FalahGenericTeamWedgeRightPublic: FalahGenericFormationBasePublic
{
	name = "Falah Generic Team Wedge Right Public";
	class Fixed
	{
		FormationPositionInfo0[] = {0, 0, 0, 0, true, "TL"};
		FormationPositionInfo1[] = {0, -5, -3, 6, true, "MG"};
		FormationPositionInfo2[] = {0, 5, -3, -6, true, "GL"};
		FormationPositionInfo3[] = {0, 10, -6, -12, true, "MKSM"};
		FormationPositionInfo4[] = {0, -10, -6, 12, true, "Any"};
		FormationPositionInfo5[] = {0, 15, -9, 18, true, "Any"};
	};
};

class FalahGenericTeamScatteredPublic: FalahGenericFormationBasePublic
{
	name = "Falah Generic Team Scattered Public";
	class Fixed
	{
		FormationPositionInfo0[] = {0, 0, 0, 0, true, "TL"};
		FormationPositionInfo1[] = {0, 3, -2, 6, true, "MG"};
		FormationPositionInfo2[] = {0, -5, -3, -6, true, "GL"};
		FormationPositionInfo3[] = {0, 8, -6, -12, true, "MKSM"};
		FormationPositionInfo4[] = {0, -10, 4, -12, true, "MKSM"};
		FormationPositionInfo5[] = {0, 12, -8, -12, true, "MKSM"};
	};
};

class FalahGenericSquadOrderLeftPublic: FalahGenericFormationBasePublic
{
	name = "Falah Generic Squad Order Left Public";
	class Fixed
	{
		FormationPositionInfo0[] = {0, 0, 0, 0, true, "LD"};
		FormationPositionInfo1[] = {0, -15, -10, 0, true, "FF"};
		FormationPositionInfo2[] = {0, -30, -20, 0, true, "FF"};
		FormationPositionInfo3[] = {0, -45, -30, 0, true, "FF"};
		FormationPositionInfo4[] = {0, -60, -40, 0, true, "FF"};
		FormationPositionInfo5[] = {0, -75, -50, 0, true, "FF"};
	};
};

class FalahGenericSquadOrderRightPublic: FalahGenericFormationBasePublic
{
	name = "Falah Generic Squad Order Right Public";
	class Fixed
	{
		FormationPositionInfo0[] = {0, 0, 0, 0, true, "LD"};
		FormationPositionInfo1[] = {0, 15, -10, 0, true, "FF"};
		FormationPositionInfo2[] = {0, 30, -20, 0, true, "FF"};
		FormationPositionInfo3[] = {0, 45, -30, 0, true, "FF"};
		FormationPositionInfo4[] = {0, 60, -40, 0, true, "FF"};
		FormationPositionInfo5[] = {0, 75, -50, 0, true, "FF"};
	};
};
