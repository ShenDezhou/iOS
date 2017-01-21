#include "cocos2d.h"
#include "FlyBirdGame.h"
#include "resource.h"
#include "AdViewController.h"
#import "EAGLView.h"
#include "KTPlayC.h"

USING_NS_CC;

CCScene* FlyBirdGame::scene()
{
	CCScene* scene = CCScene::create();
	FlyBirdGame* layer = FlyBirdGame::create();
	scene->addChild(layer);
	return scene;
}

bool FlyBirdGame::init()
{
	if (!CCLayer::init())
	{
		return false;
	}
	initUI();
	return true;
}

void  FlyBirdGame::menuCloseCallback(CCObject* pSender)
{
    KTPlayC::show();
    
}
void FlyBirdGame::initUI()
{
    
    //add iAd
    AdViewController* pAdsViewCtrl = [[AdViewController alloc] initWithNibName:nil bundle:nil];
    
    [[EAGLView sharedEGLView] addSubview:pAdsViewCtrl.view];
    
 	// win size
	auto winSize = CCDirector::sharedDirector()->getVisibleSize();

	// game bg
	CCSprite* bg = CCSprite::create(bird_bg);
	bg->setPosition(ccp(winSize.width / 2, winSize.height / 2));
	bg->setScale(winSize.width / bg->getContentSize().width);
	this->addChild(bg);

	// logo
	auto logo = CCSprite::create(bird_logo);
	logo->setPosition(ccp(winSize.width / 2, winSize.height / 2 + logo->getContentSize().height * 2));
	logo->setTag(TAG_LOGO);
	this->addChild(logo, 1);

	// over logo
	auto overLogo = CCSprite::create(bird_gameover);
	overLogo->setPosition(ccp(winSize.width / 2, winSize.height / 2 + overLogo->getContentSize().height));
	overLogo->setTag(TAG_OVER);
	overLogo->setVisible(false);
	this->addChild(overLogo, 1);

    // KT Play
    auto pCloseItem = CCMenuItemSprite::create(CCSprite::create(ktplay_start_btn), CCSprite::create(ktplay_start_btn),
                                                            this,
                                                            menu_selector(FlyBirdGame::menuCloseCallback) );
    pCloseItem->setPosition( ccp(winSize.width / 3, winSize.height / 3) );

	// start btn
	auto startBtn = CCMenuItemSprite::create(CCSprite::create(bird_start_btn), CCSprite::create(bird_start_btn_pressed),this, menu_selector(FlyBirdGame::gameStart));
	auto menu = CCMenu::create(pCloseItem,startBtn, NULL);
	menu->setTag(TAG_START_BTN);
	this->addChild(menu);

	// hero
	auto hero = CCSprite::create(bird_hero);
	hero->setPosition(ccp(winSize.width / 3, winSize.height*0.8));
	hero->setVisible(false);
	hero->setTag(TAG_HERO);
	this->addChild(hero, 1);
	CCAnimation* an = CCAnimation::create();
	an->addSpriteFrameWithFileName(bird_hero);
	an->addSpriteFrameWithFileName(bird_hero2);
	an->addSpriteFrameWithFileName(bird_hero3);
	an->setDelayPerUnit(0.5f / 3.0f);
	an->setLoops(-1);
	CCAnimate* anim = CCAnimate::create(an);
	hero->runAction(anim);

	// score
    auto score = CCLabelTTF::create("0", fontname, fontSizeTiny, ccp(26,13), kCCTextAlignmentCenter );
    score->setColor(ccc3(255,255,0));
	score->setPosition(CCPoint(winSize.width / 2, winSize.height / 4 * 3));
	addChild(score, 1);
	score->setVisible(false);
	score->setTag(TAG_SCORE);

	// Obstacle
	obstacle = new Obstacle();
	this->addChild(obstacle);

	// update 

	// touch
//	auto dispatcher = CCDirector::sharedDirector()->getEventDispatcher();
//	auto listener = EventListenerTouchAllAtOnce::create();
//	listener->onTouchesEnded = CC_CALLBACK_2(FlyBirdGame::onTouchesEnded, this);
//	listener->onTouchesBegan = CC_CALLBACK_2(FlyBirdGame::onTouchesBegan, this);
//	dispatcher->addEventListenerWithSceneGraphPriority(listener, this);
    this->setTouchEnabled(true);
	this->scheduleUpdate();
    
	// init status
	GAME_STATUS = GAME_STATUS_START;
 
}
void FlyBirdGame::registerWithTouchDispatcher()
{
	CCDirector::sharedDirector()->getTouchDispatcher()->addTargetedDelegate(this,0,true);
}
void FlyBirdGame::gameStart(CCObject* pSender)
{

	this->getChildByTag(TAG_START_BTN)->setVisible(false);
	this->getChildByTag(TAG_LOGO)->setVisible(false);
	this->getChildByTag(TAG_SCORE)->setVisible(true);
	this->getChildByTag(TAG_HERO)->setVisible(true);
	obstacle->GAME_STATUS = GAME_STATUS_PLAYING;
	GAME_STATUS = GAME_STATUS_PLAYING;
	isFlying = false;
	score = 0;
	velocity = -3;
}

void FlyBirdGame::update(float time)
{
	auto winSize = CCDirector::sharedDirector()->getVisibleSize();
	auto hero = this->getChildByTag(TAG_HERO);
	CCRect rHero = ((CCSprite*)hero)->boundingBox();
	//CCLog("time=%f", time);
	switch (GAME_STATUS)
	{
	case GAME_STATUS_PLAYING:
		obstacle->update();
		// update bird positionY
		if (hero->getPositionY() > 0 && hero->getPositionY() < winSize.height)
		{
			velocity -= gravity;
			hero->setPositionY(hero->getPositionY() + velocity);
		}
		//if (isFlying&&hero->getPositionY() < winSize.height)
		//{
		//	hero->setPositionY(hero->getPositionY() + velocity);
		//}
		//else if (hero->getPositionY()>0)
		//{
		//	hero->setPositionY(hero->getPositionY() - velocity);
		//}
		//check collision
		for (int i = 0; i < obstacle->obstacleList->count(); i++)
		{
			CCSprite* obstacleSprite = (CCSprite*)obstacle->obstacleList->objectAtIndex(i);
			bool pia = rHero.intersectsRect(obstacleSprite->boundingBox());
			if (pia == true)
			{
				GAME_STATUS = GAME_STATUS_GAME_OVER;
				break;
			}
			int oPosX = obstacleSprite->getPositionX() + obstacleSprite->getContentSize().width / 2;
			int heroX = hero->getPositionX() - hero->getContentSize().width;
			if (oPosX == heroX)
			{
				score++;
				auto scoreSprite = (CCLabelTTF*)this->getChildByTag(TAG_SCORE);
                CCString* s = CCString::createWithFormat("%d", score / 2);
				scoreSprite->setString(s->getCString());
			}
		}
		break;
	case GAME_STATUS_GAME_OVER:
		this->getChildByTag(TAG_OVER)->setVisible(true);
		break;
	case GAME_STATUS_RESTART:
		//reset game
		obstacle->removeAllChildren();
		obstacle->obstacleList->removeAllObjects();
		// reset hero
		hero->setPosition(winSize.width / 5, winSize.height*0.8);
		hero->setVisible(false);
		// show btn
		this->getChildByTag(TAG_START_BTN)->setVisible(true);
		// show logo
		this->getChildByTag(TAG_LOGO)->setVisible(true);
		// hide over log
		this->getChildByTag(TAG_OVER)->setVisible(false);
		// hide score
		this->getChildByTag(TAG_SCORE)->setVisible(false);
		break;
	}
}

void FlyBirdGame::ccTouchEnded(cocos2d::CCTouch *pTouch, cocos2d::CCEvent *pEvent)
{
	CCPoint touchPoint = this->convertTouchToNodeSpace(pTouch);
	//CCPoint location = touch->getLocation();
	if (GAME_STATUS == GAME_STATUS_PLAYING)
	{
		isFlying = false;
	}
}

bool FlyBirdGame::ccTouchBegan(CCTouch *pTouch, CCEvent *pEvent)
{
	CCPoint touchPoint = this->convertTouchToNodeSpace(pTouch);
//	Point location = touch->getLocation();
	if (GAME_STATUS == GAME_STATUS_PLAYING)
	{
		CCLog("GAME_STATUS_PLAYING");
		isFlying = true;
		velocity = 5;
	}
	else if (GAME_STATUS == GAME_STATUS_GAME_OVER)
	{
		GAME_STATUS = GAME_STATUS_RESTART;
		CCLog("GAME_STATUS_GAME_OVER");
	}
    return true;
}

CCRect FlyBirdGame::spriteRect(CCSprite* s)
{
	CCPoint pos = s->getPosition();
	CCSize cs = s->getContentSize();
	return CCRectMake(pos.x - cs.width / 2, pos.y - cs.height / 2, cs.width, cs.height / 2);
}