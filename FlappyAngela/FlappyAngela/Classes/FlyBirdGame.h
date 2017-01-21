#pragma once
#include "cocos2d.h"
#include "Obstacle.h"

NS_CC_BEGIN
class FlyBirdGame :public cocos2d::CCLayer
{
public:
	static cocos2d::CCScene* scene();
	virtual bool init();
	CREATE_FUNC(FlyBirdGame);
	void initUI();
	void gameStart(CCObject* pSender);
	void update(float time);
	Obstacle* obstacle;
	void registerWithTouchDispatcher();
	bool ccTouchBegan(cocos2d::CCTouch *pTouch, cocos2d::CCEvent *pEvent);
    void ccTouchEnded(cocos2d::CCTouch *pTouch, cocos2d::CCEvent *pEvent);
	bool isFlying = false;
	float velocity = -2;
	CCRect spriteRect(CCSprite* s);
	int GAME_STATUS;
	int score = 0;
	float gravity=0.2;
    
    //添加广告必须
    static void addAd();//添加iad
    static void deletAd();//删除iad
    static void * view;//EGLView指针
    // a selector callback
    void menuCloseCallback(CCObject* pSender);
};
NS_CC_END