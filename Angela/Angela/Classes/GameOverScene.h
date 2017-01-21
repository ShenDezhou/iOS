#ifndef __GAMEOVERSCENE_H__
#define __GAMEOVERSCENE_H__
#include "cocos2d.h"
#include "scenes.h"

NS_CC_BEGIN
class GameOverLayer : public CCLayer
{
public:
    CCSpriteBatchNode *_batchNodes;
	    // there's no 'id' in cpp, so we recommend returning the class instance pointer 
	static CCScene* scene();

    // Here's a difference. Method 'init' in cocos2d-x returns bool, instead of returning 'id' in cocos2d-iphone    
    virtual bool init();
	//static GameOverLayer* create(bool won,int _level);
	void registerWithTouchDispatcher();
	bool ccTouchBegan(cocos2d::CCTouch *pTouch, cocos2d::CCEvent *pEvent);
	//bool initWithWon(bool won,int _level);
    void basicSetup();

	CREATE_FUNC(GameOverLayer);

	void GameFinished();
};
NS_CC_END
#endif