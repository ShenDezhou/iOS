#pragma once
#include "cocos2d.h"
NS_CC_BEGIN
class  Obstacle :public CCNode
{
public:
	CCArray* obstacleList;

	Obstacle();
	virtual void onEnter();
	void update(); 
	void addOne(int offsetX);
	void checkDel();
	int addCount = 0;
	int GAME_STATUS = 0;
};
NS_CC_END