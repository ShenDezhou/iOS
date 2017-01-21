#pragma once
#include "cocos2d.h"
#include "Component.h"
#include "Constant.h"
NS_CC_BEGIN
class ItemComponent:public Component
{
public:
	ItemType itemType;
	int createTime;
	bool isConsumed;
	int TargetTeam;
	int EffectiveTime;
	int CollectTime;
	int AttackPoint;
	int MaxHitPoint;
	int ArmorPoint;
	int AccuracyPoint;
	int MissPoint;
	int CriticalPoint;
	int DirectDamagePoint;
	int MoveSpeed;
	int FireSpeed;
	int Gold;
	int Experience;
	int LevelUp;
	
	ItemComponent();
	inline bool init(){ return true;}
	CREATE_FUNC(ItemComponent);
	CCString* ClassName();
};
NS_CC_END