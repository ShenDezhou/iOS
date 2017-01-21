#ifndef __HELPSCENE_H__
#define __HELPSCENE_H__
#include "cocos2d.h"
#include "scenes.h"
NS_CC_BEGIN
class HelpLayer : public CCLayer
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

	CREATE_FUNC(HelpLayer);

	void shopButtonTapped(CCObject* obj) ;
	void homeButtonTapped(CCObject* obj) ;
	void helpButtonTapped(CCObject* obj) ;
};
NS_CC_END

#endif