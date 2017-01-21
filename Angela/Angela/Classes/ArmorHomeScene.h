#ifndef __ARMORHOME_SCENE_H__
#define __ARMORHOME_SCENE_H__

#include "cocos2d.h"
#include "cocos-ext.h"

#include "CCLayerParent.h"
#include "Scenes.h"
#define PTM_RATIO 32.0


NS_CC_BEGIN

class Player;

class ArmorHome : public CCLayerParent,public CCEditBoxDelegate
{
public:
  
	CCMenu* menu;
    // there's no 'id' in cpp, so we recommend returning the class instance pointer
     static cocos2d::CCScene* scene();
     // Here's a difference. Method 'init' in cocos2d-x returns bool, instead of returning 'id' in cocos2d-iphone
    virtual bool init();  
    void basicSetup();
	void addPlayers();
    //void choose(int level);
	void levelButtonTapped(CCObject* obj) ;
	void shopButtonTapped(CCObject* obj) ;
	void homeButtonTapped(CCObject* obj) ;
	void helpButtonTapped(CCObject* obj) ;
	//void update(float delta);
	//void restartTapped(CCObject* obj);
	//void showRestartMenu(bool won);
	//void draw();

	//void quirkButtonTapped(CCObject* obj) ;

	//void zapButtonTapped(CCObject* obj)  ;

	//void munchButtonTapped(CCObject* obj) ;

      // implement the "static node()" method manually
    CREATE_FUNC(ArmorHome);

	//virtual void release();

	void registerWithTouchDispatcher();
	//
	bool ccTouchBegan(cocos2d::CCTouch *pTouch, cocos2d::CCEvent *pEvent);
	//void ccTouchMoved(cocos2d::CCTouch *pTouch, cocos2d::CCEvent *pEvent);
	//void ccTouchCancelled(cocos2d::CCTouch *pTouch, cocos2d::CCEvent *pEvent);
	void ccTouchEnded(cocos2d::CCTouch *pTouch, cocos2d::CCEvent *pEvent);
    void setPlayerPosition(CCPoint position);
    
	//void didAccelerate(cocos2d::CCAcceleration* pAccelerationValue);
	//开始进入编辑
    virtual void editBoxEditingDidBegin(cocos2d::extension::CCEditBox* editBox);
    //结束编辑
    virtual void editBoxEditingDidEnd(cocos2d::extension::CCEditBox* editBox);
    //编辑框文本改变
    virtual void editBoxTextChanged(cocos2d::extension::CCEditBox* editBox, const std::string& text);
    //当触发return后的回调函数
    virtual void editBoxReturn(cocos2d::extension::CCEditBox* editBox);
    cocos2d::CCTMXTiledMap* _tileMap;
	cocos2d::CCTMXLayer* _background;
	cocos2d::CCSprite* _player;
 //   CC_SYNTHESIZE_RETAIN(cocos2d::CCTMXTiledMap*, _tileMap, Tilemap);
    //CC_SYNTHESIZE_RETAIN(cocos2d::CCTMXLayer*, _background, Background);
    //CC_SYNTHESIZE_RETAIN(cocos2d::CCSprite*, _player, Player);
    
    void setViewpointCenter(CCPoint position);
};

NS_CC_END
#endif // __ARMORHOME_SCENE_H__

