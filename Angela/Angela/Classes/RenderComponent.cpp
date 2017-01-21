#include "RenderComponent.h"

USING_NS_CC;

RenderComponent::RenderComponent(CCNode* node)
{
	this->node = node;
	this->node->retain();
}
RenderComponent* RenderComponent::create(CCNode *node)
{
	RenderComponent *pRet = new RenderComponent(node); \
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
RenderComponent::~RenderComponent()
{
	this->node->release();
}
CCString* RenderComponent::ClassName()
{
	return CCString::create("RenderComponent");
}