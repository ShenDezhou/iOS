#pragma once
#include "cocos2d.h"
#include "Component.h"

NS_CC_BEGIN

class RenderComponent:public Component
{
public:
	CCNode *node;
public:
	RenderComponent(CCNode *node);
	static RenderComponent* create(CCNode *node);
  		~RenderComponent();
	CCString* ClassName();
};

NS_CC_END