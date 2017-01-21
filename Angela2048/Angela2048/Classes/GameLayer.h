#ifndef _GameLayer_H_
#define _GameLayer_H_
#include "cocos2d.h"
#include "Tiled.h"
#include "GameScene.h"
#include "resource.h"
USING_NS_CC;
using namespace std;

class GameLayer:public CCLayer{
public:
	virtual bool init();
	CREATE_FUNC(GameLayer);
	//GameLayer();
	void gameInit();
	CCPoint touchDown;
	static int score;
	CCLabelTTF *lScore;
private:
	Tiled* tables[4][4];
    void registerWithTouchDispatcher();
	bool ccTouchBegan(cocos2d::CCTouch *pTouch, cocos2d::CCEvent *pEvent);
    void ccTouchMoved(cocos2d::CCTouch *pTouch, cocos2d::CCEvent *pEvent);
    void ccTouchEnded(cocos2d::CCTouch *pTouch, cocos2d::CCEvent *pEvent);
    void inline close(){
        CCDirector::sharedDirector()->end();
        exit(0);
    }
    void inline replace(){
        CCDirector::sharedDirector()->replaceScene(GameScene::create());
    }
	//四个移动方向，返回是否有砖块移动过
	bool moveToTop();
	bool moveToDown();
	bool moveToLeft();
	bool moveToRight();

	void swapTiled(Tiled *tiled1,Tiled * tiled2);
	void addTiled();
	bool isOver();
    void ktPlay();
};
#endif