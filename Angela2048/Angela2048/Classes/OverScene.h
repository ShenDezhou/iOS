#ifndef _OverScene_H_
#define _OverScene_H_
#include "cocos2d.h"
#include "resource.h"
USING_NS_CC;

class OverScene:public CCLayer{
public:
	static CCScene* createScene();

	CREATE_FUNC(OverScene);

	virtual bool init();

	void restartMenu(CCObject *pSender);
};
#endif