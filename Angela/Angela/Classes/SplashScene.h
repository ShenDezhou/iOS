#ifndef __Splash_H__
#define __Splash_H__

#include "cocos2d.h"
#include "Scenes.h"
#include "CCControlSlider.h"
NS_CC_BEGIN


class Splash :	public CCLayer
{
private:
	//CCArray *_monsters;
	//CCArray *_projectiles;
	//int _monstersDestroyed;
	//static Splash* splash;
	//cocos2d::CCSprite *_player;
	//cocos2d::CCSprite *_nextProjectile;
	CCSpriteBatchNode* _batchNodes;
	//CCArray* planes;
	CCMenu* menu;
	CCMenu* accessory;
	int page;
	CCLabelTTF* pagelabel;
	CCLabelTTF* decksLabel;
	//CCMenu* menu_sel;
	//int level;
	CCLabelTTF* guide;
public:
	static Splash* sharedSplash(); 
    // Here's a difference. Method 'init' in cocos2d-x returns bool, instead of returning 'id' in cocos2d-iphone
    virtual bool init(int level);  
   // implement the "static node()" method manually
    //CREATE_FUNC(Splash);
	static Splash* create(int level);
	void basicSetup();
   // there's no 'id' in cpp, so we recommend returning the class instance pointer
    static cocos2d::CCScene* scene(int level);
   
	void levelButtonTapped(CCObject *object);
	void startButtonTapped(CCObject *object);
   // void gameLogic(float dt);

    void registerWithTouchDispatcher();

    bool ccTouchBegan(cocos2d::CCTouch *pTouch, cocos2d::CCEvent *pEvent);

    void ccTouchEnded(cocos2d::CCTouch *pTouch, cocos2d::CCEvent *pEvent);
	void AmendInfo(CCSprite* craftinfo,int index);


	void shopButtonTapped(CCObject* obj) ;
	void homeButtonTapped(CCObject* obj) ;
	void helpButtonTapped(CCObject* obj) ;
 };
NS_CC_END
#endif

