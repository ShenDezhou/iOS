#pragma once
#include "cocos2d.h"

NS_CC_BEGIN

class Component :
	public CCObject
{
	
public:
	Component();
	~Component();
	virtual CCString* ClassName()=0;
};

NS_CC_END