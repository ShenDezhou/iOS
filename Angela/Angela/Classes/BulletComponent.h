#pragma once

#include "cocos2d.h"

#include "Component.h"

NS_CC_BEGIN

class BulletComponent:public Component
{
public:
	
	BulletComponent();
	~BulletComponent();
 	CCString* ClassName();
	inline bool init(){ return true;}
	CREATE_FUNC(BulletComponent);
};
NS_CC_END