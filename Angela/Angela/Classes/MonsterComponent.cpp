#include "MonsterComponent.h"

USING_NS_CC;

MonsterComponent::MonsterComponent(MonsterType monsterType,int team)
{
	this->monsterType = monsterType;
	monster = Monster::create(&decks[(int)monsterType]);
	monster->retain();
	//monster->retain();
	/*switch(monsterType)
	{
	case MonsterTypeQuirk:
		monster = QuirkMonster::create(team);
		break;
	case MonsterTypeZap:
		monster = ZapMonster::create(team);
		break;
	case MonsterTypeMunch:
		monster = MunchMonster::create(team);
		break;
	case MonsterTypePhoenix:
		monster = PhoenixMonster::create(team);
		break;
	case MonsterTypeDragon:
		monster = DragonMonster::create(team);
		break;
	default:
		break;
	}*/
	//_batchNode->addChild(monster);
}

MonsterComponent* MonsterComponent::create(MonsterType monsterType,int team)
{
	MonsterComponent *pRet = new MonsterComponent(monsterType,team); \
	if (pRet ) \
	{ \
		pRet->autorelease(); \
		return pRet; \
	} \
	else \
	{ \
		delete pRet; \
		pRet = NULL; \
		return NULL; \
	} \
}
CCString* MonsterComponent::ClassName()
{
	return CCString::create("MonsterComponent");

}
MonsterComponent::~MonsterComponent(){}
