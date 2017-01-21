#include "TeamComponent.h"
USING_NS_CC;
TeamComponent::TeamComponent(int team)
{
	this->team = team;
}
TeamComponent* TeamComponent::create(int team)
{
	TeamComponent *pRet = new TeamComponent(team); \
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
CCString* TeamComponent::ClassName()
{
	return new CCString("TeamComponent");
}