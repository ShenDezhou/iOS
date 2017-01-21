#pragma once

#include "cocos2d.h"

#include "Component.h"

NS_CC_BEGIN

class SelectionComponent:public Component
{
public:
	bool selected;
	SelectionComponent();
	~SelectionComponent();
 	CCString* ClassName();
	inline bool init(){ return true;}
	CREATE_FUNC(SelectionComponent);
};
NS_CC_END