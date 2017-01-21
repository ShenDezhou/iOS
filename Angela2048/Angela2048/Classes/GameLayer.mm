#include "GameLayer.h"
#include "Tiled.h"
#include "OverScene.h"
//#include <time.h>
//#include <random>
#include "GameScene.h"
#include "KTPlayC.h"
#import "EAGLView.h"
#include "AdViewController.h"

#define RC_CONVERT_TO_XY(rc) (rc*105+60)

int GameLayer::score=0;

bool GameLayer::init(){
	bool bRet=false;
	do{
		CC_BREAK_IF(!CCLayer::init());
        
        auto cache=CCSpriteFrameCache::sharedSpriteFrameCache();
		CCSize size=CCDirector::sharedDirector()->getVisibleSize();

		//添加背景
		auto background=CCSprite::createWithSpriteFrame(cache->spriteFrameByName("background.png"));
		background->setPosition(CCPoint(size.width/2,size.height/2));
		this->addChild(background);

		//添加标题背景
		auto headBg=CCSprite::createWithSpriteFrame(cache->spriteFrameByName("title_bg.png"));
		headBg->setAnchorPoint(CCPoint(0,1));
		headBg->setPosition(CCPoint(0,640));
		this->addChild(headBg,1);

		//添加退出和重新开始按钮
		auto exitItem=CCMenuItemSprite::create(CCSprite::createWithSpriteFrame(cache->spriteFrameByName("exit_norm.png")),
                                               CCSprite::createWithSpriteFrame(cache->spriteFrameByName("exit_press.png")),this,menu_selector(GameLayer::close));
		exitItem->setPosition(CCPoint(65,600));

		auto restartItem=CCMenuItemSprite::create(CCSprite::createWithSpriteFrame(cache->spriteFrameByName("restart_norm.png")),
                                                  CCSprite::createWithSpriteFrame(cache->spriteFrameByName("restart_press.png")),this,menu_selector(GameLayer::replace));
 		restartItem->setPosition(CCPoint(375,600));
        // KT Play
        auto pCloseItem = CCMenuItemSprite::create(CCSprite::create("CloseNormal.png"), CCSprite::create("CloseSelected.png"),
                                                   this,
                                                   menu_selector(GameLayer::ktPlay) );
        pCloseItem->setPosition( ccp(220, 470) );
        
		auto menu=CCMenu::create(exitItem,restartItem,pCloseItem,NULL);
		menu->setAnchorPoint(CCPointZero);
		menu->setPosition(CCPointZero);
		this->addChild(menu,2);

		//添加砖块部分背景
		auto gameBg=CCSprite::createWithSpriteFrame(cache->spriteFrameByName("game_bg.png"));
		gameBg->setAnchorPoint(CCPointZero);
		gameBg->setPosition(CCPoint(5,5));
		this->addChild(gameBg);

		//添加分数背景
		auto scoreBg=CCSprite::createWithSpriteFrame(cache->spriteFrameByName("score_bg.png"));
		scoreBg->setAnchorPoint(CCPointZero);
		scoreBg->setPosition(CCPoint(5,435));
		this->addChild(scoreBg);

		//添加分数显示
		lScore= CCLabelTTF::create("0", fontname, fontSizeTiny, ccp(26,13), kCCTextAlignmentCenter );
		lScore->setPosition(CCPoint(65,470));
		this->addChild(lScore);

		//添加最高分显示
		int high=CCUserDefault::sharedUserDefault()->getIntegerForKey("HighScore",0);
		auto hScore= CCLabelTTF::create(CCString::createWithFormat("%d",high)->getCString(), fontname, fontSizeTiny, ccp(26,13), kCCTextAlignmentCenter );
		hScore->setPosition(CCPoint(300,470));
		this->addChild(hScore);
		//初始化游戏界面
		gameInit();
        
        //add iAd
        AdViewController* pAdsViewCtrl = [[AdViewController alloc] initWithNibName:nil bundle:nil];
        
        [[EAGLView sharedEGLView] addSubview:pAdsViewCtrl.view];

        //添加监听器
        this->setTouchEnabled(true);
        this->scheduleUpdate();

		bRet=true;
	}while(0);
	return bRet;
}
    void GameLayer::ktPlay()
{
    
    KTPlayC::show();
    
}
void GameLayer::gameInit(){
	GameLayer::score=0;
	auto cache=CCSpriteFrameCache::sharedSpriteFrameCache();
	//初始化砖块
	for(int i=0;i<4;i++){
		for(int j=0;j<4;j++){
			auto tiled=Tiled::create();
			tiled->level=0;
			tiled->setAnchorPoint(CCPointZero);
			tiled->setPosition(CCPoint(RC_CONVERT_TO_XY(j),RC_CONVERT_TO_XY(i)));
			tiled->setVisible(false);
			this->addChild(tiled,1);
			tables[i][j]=tiled;

		}
	}

	//获取两个随机坐标
	//c++11的随机数产生方式
	//default_random_engine e(time(NULL));
	//这里是设定产生的随机数的范围，这里是0到3
	//uniform_int_distribution<unsigned> u(0,3);
	int row1=arc4random()%4;//u(e);
	int col1=arc4random()%4;//u(e);
	int row2=arc4random()%4;//u(e);
	int col2=arc4random()%4;//u(e);
	//这个循环是保证两个砖块的坐标不会重复
	do{
		row2=arc4random()%4;//u(e);
		col2=arc4random()%4;//u(e);
	}while(row1==row2&&col1==col2);

	//添加第一个砖块
	auto tiled1=tables[row1][col1];
	int isFour=arc4random()%10;
	if(isFour==0){
		tiled1->level=2;
		tiled1->backround->setDisplayFrame(cache->spriteFrameByName(CCString::createWithFormat("level2.png")->getCString()));
		tiled1->label->setString("4");
		tiled1->setVisible(true);
	}else{
		tiled1->level=1;
		tiled1->backround->setDisplayFrame(cache->spriteFrameByName(CCString::createWithFormat("level1.png")->getCString()));
		tiled1->label->setString("2");
		tiled1->setVisible(true);
	}

	//添加第二个砖块
	auto tiled2=tables[row2][col2];
	isFour=arc4random()%10;
	if(isFour==0){
		tiled2->level=2;
		tiled2->backround->setDisplayFrame(cache->spriteFrameByName(CCString::createWithFormat("level2.png")->getCString()));
		tiled2->label->setString("4");
		tiled2->setVisible(true);
	}else{
		tiled2->level=1;
		tiled2->backround->setDisplayFrame(cache->spriteFrameByName(CCString::createWithFormat("level1.png")->getCString()));
		tiled2->label->setString("2");
		tiled2->setVisible(true);
	}
}

void GameLayer::registerWithTouchDispatcher()
{
    CCDirector::sharedDirector()->getTouchDispatcher()->addTargetedDelegate(this,0,true);
}

bool GameLayer::ccTouchBegan(cocos2d::CCTouch *pTouch, cocos2d::CCEvent *pEvent){
	this->touchDown=pTouch->getLocationInView();
	this->touchDown=CCDirector::sharedDirector()->convertToGL(this->touchDown);
	return true;
}

void GameLayer::ccTouchMoved(cocos2d::CCTouch *pTouch, cocos2d::CCEvent *pEvent){

}

void GameLayer::ccTouchEnded(cocos2d::CCTouch *pTouch, cocos2d::CCEvent *pEvent){
	bool hasMoved=false;
	CCPoint touchUp=pTouch->getLocationInView();
	touchUp=CCDirector::sharedDirector()->convertToGL(touchUp);

	if(touchUp.getDistance(touchDown)>50){
		//判断上下还是左右
		if(fabs(touchUp.x-touchDown.x)> fabs(touchUp.y-touchDown.y)){
			//左右滑动
			if(touchUp.x-touchDown.x>0){
				//向右
				CCLog("toRight");
				hasMoved=moveToRight();
			}else{
				//向左
				CCLog("toLeft");
				hasMoved=moveToLeft();
			}
		}else{
			//上下滑动
			if(touchUp.y-touchDown.y>0){
				//向上
				CCLog("toTop");
				hasMoved=moveToTop();
			}else{
				//向下
				CCLog("toDown");
				hasMoved=moveToDown();
			}
		}

		if(hasMoved){
			addTiled();
		}

		if(isOver()){
			//存放分数
			int high=CCUserDefault::sharedUserDefault()->getIntegerForKey("HighScore",0);
			if(GameLayer::score>high){
				CCUserDefault::sharedUserDefault()->setIntegerForKey("HighScore",GameLayer::score);
				CCUserDefault::sharedUserDefault()->flush();
			}
			GameLayer::score=0;
			//切换画面
			CCDirector::sharedDirector()->replaceScene(CCTransitionSlideInB::create(1.0f,OverScene::createScene()));
		}

	}
}

//四个方向
bool GameLayer::moveToDown(){
	bool hasMoved=false;
	//将数字相同的格子合一
 	for(int col=0;col<4;col++){
 		for(int row=0;row<4;row++){
			//遍历的每一次获得的方块
 			auto tiled=tables[row][col];
			//找到不为空的方块
 			if(tiled->level!=0){
 				int k=row+1;
				//看这一列有没有等级和这个方块等级相同的
 				while(k<4){
 					auto nextTiled=tables[k][col];
 					if(nextTiled->level!=0){
 						if(tiled->level==nextTiled->level){
							//找到等级和这个砖块等级相同的就把他们合并
  							tiled->setLevel(nextTiled->level+1);
 							nextTiled->setLevel(0);
 							nextTiled->setVisible(false);
 							GameLayer::score+=Tiled::nums[tiled->level];
 							this->lScore->setString(CCString::createWithFormat("%d",GameLayer::score)->getCString());
							hasMoved=true;
 						}
 						k=4;
 					}
 					k++;
 				}
 			}
 		}
 	}


	//将有数的格子填入空格子
	for(int col=0;col<4;col++){
		for(int row=0;row<4;row++){
			//遍历每一次的砖块
			auto tiled=tables[row][col];
			//找到空格子
			if(tiled->level==0){
				int k=row+1;
				while(k<4){
					auto nextTiled=tables[k][col];
					if(nextTiled->level!=0){
						//将不为空的格子移到这里
						tiled->setLevel(nextTiled->level);
						nextTiled->setLevel(0);
						tiled->setVisible(true);
						nextTiled->setVisible(false);
						hasMoved=true;
						k=4;
					}
					k++;
				}
			}
		}
	}
	
	return hasMoved;
}

//向左
bool GameLayer::moveToLeft(){ 
	bool hasMoved=false;
	//合成
 	for(int col=0;col<4;col++){
 		for(int row=0;row<4;row++){
 			auto tiled=tables[row][col];
 			if(tiled->level!=0){
 				int k=col+1;
 				while(k<4){
 					auto nextTiled=tables[row][k];
 					if(nextTiled->level!=0){
 						if(tiled->level==nextTiled->level){
							tiled->setLevel(nextTiled->level+1);
							nextTiled->setLevel(0);
							nextTiled->setVisible(false);
							GameLayer::score+=Tiled::nums[tiled->level];
							this->lScore->setString(CCString::createWithFormat("%d",GameLayer::score)->getCString());
							hasMoved=true;
 						}
 						k=4;
 					}
 					k++;
 				}
 			}
 		}
 	}

 	for(int row=0;row<4;row++){
 		for(int col=0;col<4;col++){
 			auto tiled=tables[row][col];
 			if(tiled->level==0){
 				int k=col+1;
 				while(k<4){
 					auto nextTiled=tables[row][k];
 					if(nextTiled->level!=0){
						tiled->setLevel(nextTiled->level);
						nextTiled->setLevel(0);
						tiled->setVisible(true);
						nextTiled->setVisible(false);
						hasMoved=true;
 						k=4;
 					}
 					k++;
 				}
 			}
 		}
 	}

	return hasMoved;
}

//向右
bool GameLayer::moveToRight(){
	bool hasMoved=false;
	//合成
	for(int row=0;row<4;row++){
		for(int col=3;col>=0;col--){
			auto tiled=tables[row][col];
			if(tiled->level!=0){
				int k=col-1;
				while(k>=0){
					auto nextTiled=tables[row][k];
					if(nextTiled->level!=0){
						if(tiled->level==nextTiled->level){
							tiled->setLevel(nextTiled->level+1);
							nextTiled->setLevel(0);
							nextTiled->setVisible(false);
							GameLayer::score+=Tiled::nums[tiled->level];
							this->lScore->setString(CCString::createWithFormat("%d",GameLayer::score)->getCString());
							hasMoved=true;
						}
						k=-1;
					}
					k--;
				}
			}
		}
	}

	for(int row=0;row<4;row++){
		for(int col=3;col>=0;col--){
			auto tiled=tables[row][col];
			if(tiled->level==0){
				int k=col-1;
				while(k>=0){
					auto nextTiled=tables[row][k];
					if(nextTiled->level!=0){
						tiled->setLevel(nextTiled->level);
						nextTiled->setLevel(0);
						tiled->setVisible(true);
						nextTiled->setVisible(false);
						hasMoved=true;
						k=-1;
					}
					k--;
				}
			}
		}
	}

	return hasMoved;
}

//向上
bool GameLayer::moveToTop(){
	bool hasMoved=false;
	//将数字相同的格子合一
	for(int col=0;col<4;col++){
		for(int row=3;row>=0;row--){
			auto tiled=tables[row][col];
			if(tiled->level!=0){
				int k=row-1;
				while(k>=0){
					auto nextTiled=tables[k][col];
					if(nextTiled->level!=0){
						if(tiled->level==nextTiled->level){
							tiled->setLevel(nextTiled->level+1);
							nextTiled->setLevel(0);
							nextTiled->setVisible(false);
							GameLayer::score+=Tiled::nums[tiled->level];
							this->lScore->setString(CCString::createWithFormat("%d",GameLayer::score)->getCString());
							hasMoved=true;
						}
						k=-1;
					}
					k--;
				}
			}
		}
	}


	//将有数的格子填入空格子
	for(int col=0;col<4;col++){
		for(int row=3;row>=0;row--){
			auto tiled=tables[row][col];
			if(tiled->level==0){
				int k=row-1;
				while(k>=0){
					auto nextTiled=tables[k][col];
					if(nextTiled->level!=0){
						tiled->setLevel(nextTiled->level);
						nextTiled->setLevel(0);
						tiled->setVisible(true);
						nextTiled->setVisible(false);
						hasMoved=true;
						k=-1;
					}
					k--;
				}
			}
		}
	}
	return hasMoved;
}


void GameLayer::addTiled(){
	auto cache=CCSpriteFrameCache::sharedSpriteFrameCache();
	//获取两个随机坐标
//	default_random_engine e(time(NULL));
//	uniform_int_distribution<unsigned> u(0,3);
	int row=0;
	int col=0;
	do{
		row=arc4random()%4;//u(e);
		col=arc4random()%4;//u(e);
	}while(tables[row][col]->level!=0);
	
	//添加砖块
	auto tiled=tables[row][col];
	int isFour=arc4random()%10;
	if(isFour==0){
		tiled->level=2;
		tiled->backround->setDisplayFrame(cache->spriteFrameByName(CCString::createWithFormat("level2.png")->getCString()));
		tiled->label->setString("4");
		tiled->setVisible(true);
	}else{
		tiled->level=1;
		tiled->backround->setDisplayFrame(cache->spriteFrameByName(CCString::createWithFormat("level1.png")->getCString()));
		tiled->label->setString("2");
		tiled->setVisible(true);
	}

	tiled->setScale(0.5);
	tiled->runAction(CCScaleTo::create(0.1f,1.0f));
}

bool GameLayer::isOver(){
	for(int row=0;row<4;row++){
		for(int col=0;col<4;col++){
			//判断是否存在空格子
			if(tables[row][col]->level==0){
				//有空格子肯定不会OVER
				return false;
			}
			//判断周围格子,如果存在相等的数字则不OVER
			//上
			int c=col;
			int r=row+1;
			if(r!=-1&&r!=4){
				if(tables[row][col]->level==tables[r][c]->level){
					return false;
				}
			}
			//左
			c=col-1;
			r=row;
			if(c!=-1&&c!=4){
				if(tables[row][col]->level==tables[r][c]->level){
					return false;
				}
			}
			//右
			c=col+1;
			r=row;
			if(c!=-1&&c!=4){
				if(tables[row][col]->level==tables[r][c]->level){
					return false;
				}
			}
			//下
			c=col;
			r=row-1;
			if(r!=-1&&r!=4){
				if(tables[row][col]->level==tables[r][c]->level){
					return false;
				}
			}
		}
	}
	return true;
}