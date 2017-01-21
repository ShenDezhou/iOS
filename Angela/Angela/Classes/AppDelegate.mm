#include "AppDelegate.h"
#include "ServerScene.h"
#include "Scenes.h"
#include "KTPlay.h"

USING_NS_CC;

AppDelegate::AppDelegate() {

}

AppDelegate::~AppDelegate() 
{
}

bool AppDelegate::applicationDidFinishLaunching() {
    // initialize director
    CCDirector* pDirector = CCDirector::sharedDirector();
    CCEGLView* pEGLView = CCEGLView::sharedOpenGLView();

    pDirector->setOpenGLView(pEGLView);
	CCSize frameSize = pEGLView->getFrameSize();  
	
    if(frameSize.width == ip5Resource.size.width)
    {
        pEGLView->setDesignResolutionSize(ip5DesignResolutionSize.width, ip5DesignResolutionSize.height, kResolutionNoBorder);
        pDirector->setContentScaleFactor(ip5Resource.size.height/ip5DesignResolutionSize.height);
        //MARGIN = 43.4 / CC_CONTENT_SCALE_FACTOR();
        fontSizeBig = 12;
        fontSizeSmall = 10;
        fontSizeTiny = 8;
        yOffset = (852-640)/2;
        SPEEDRATIO = 1;
    }else{
	// Set the design resolution
	if (frameSize.width >= mediumResource.size.width)
	{ 
		pEGLView->setDesignResolutionSize(ipadDesignResolutionSize.width, ipadDesignResolutionSize.height, kResolutionNoBorder); 
	}
	else
	{
		pEGLView->setDesignResolutionSize(designResolutionSize.width, designResolutionSize.height, kResolutionNoBorder); 
	}
	 // In this demo, we select resource according to the frame's height.
	 // If the resource size is different from design resolution size, you need to set contentScaleFactor.    
	 // We use the ratio of resource's height to the height of design resolution,    
	 // this can make sure that the resource's height could fit for the height of design resolution.     
	 // if the frame's height is larger than the height of medium resource size, select large resource.    
	 if (frameSize.width > mediumResource.size.width)
	 { 
		//CCSpriteFrameCache::sharedSpriteFrameCache()->addSpriteFramesWithFile("Sprites-ipadhd.plist");
		//_batchNodes = CCSpriteBatchNode::create("Sprites-ipadhd.pvr.ccz");

		 //CCFileUtils::sharedFileUtils()->setResourceDirectory(largeResource.directory); 
		 pDirector->setContentScaleFactor(largeResource.size.height/ipadDesignResolutionSize.height);
		 	// xMARGIN = 104 / CC_CONTENT_SCALE_FACTOR();
			 //yMARGIN = 
			 fontSizeBig = 24;
			 fontSizeSmall = 18;
			 fontSizeTiny = 12;
			 yOffset=0;
			 SPEEDRATIO = 3;
	 } 
	 // if the frame's height is larger than the height of small resource size, select medium resource.    
	 else if (frameSize.width > smallResource.size.width)    
	 {        
		//CCSpriteFrameCache::sharedSpriteFrameCache()->addSpriteFramesWithFile("Sprites-hd.plist");
		//_batchNodes = CCSpriteBatchNode::create("Sprites-hd.pvr.ccz");
		 //CCFileUtils::sharedFileUtils()->setResourceDirectory(mediumResource.directory);        
		 pDirector->setContentScaleFactor(mediumResource.size.height/ipadDesignResolutionSize.height); 
		//MARGIN = 52 / CC_CONTENT_SCALE_FACTOR();
		fontSizeBig = 24;
		fontSizeSmall = 18;
		fontSizeTiny = 12;
		yOffset = 0;
		SPEEDRATIO = 2;
	 } 
	 // if the frame's height is smaller than the height of medium resource size, select small resource.    
	 else  if (frameSize.width > tinyResource.size.width)      
	 {
		//CCSpriteFrameCache::sharedSpriteFrameCache()->addSpriteFramesWithFile("Sprites.plist");
		//_batchNodes = CCSpriteBatchNode::create("Sprites.pvr.ccz");
		 //CCFileUtils::sharedFileUtils()->setResourceDirectory(smallResource.directory);        
		 pDirector->setContentScaleFactor(smallResource.size.height/designResolutionSize.height); 
		 	 //MARGIN = 43.4 / CC_CONTENT_SCALE_FACTOR();
			fontSizeBig = 12;
			fontSizeSmall = 10;
			fontSizeTiny = 8;
			SPEEDRATIO = 1;
		//yOffset *= CC_CONTENT_SCALE_FACTOR();
	 }else
	 {
		 pDirector->setContentScaleFactor(tinyResource.size.height/designResolutionSize.height); 
		 	 //MARGIN = 21.7 / CC_CONTENT_SCALE_FACTOR();
			fontSizeBig = 10;
			fontSizeSmall = 8;
			fontSizeTiny = 8;
			SPEEDRATIO = 0.8;
		//yOffset *= CC_CONTENT_SCALE_FACTOR();
	 }
    }
	 xMARGIN = frameSize.width / 20 /CC_CONTENT_SCALE_FACTOR();
	 yMARGIN = frameSize.height / 20 /CC_CONTENT_SCALE_FACTOR();
	 
	 //_batchNodes->retain();
    // turn on display FPS
    pDirector->setDisplayStats(false);

    // set FPS. the default value is 1.0/60 if you don't call this
    pDirector->setAnimationInterval(1.0 / 30);

	initStrings();

    for (int i = 0; i<4; i++) {
        int index = (int)CCRANDOM_X_Y(1,9);
        decks[index].selection = true;
    }
	    // create a scene. it's an autorelease object
    CCScene *pScene = CCBattle::scene();

//    CCScene *pScene = ArmorHome::scene();

    // run
    pDirector->runWithScene(pScene);
    pvp=true;
    [KTPlay startWithAppKey:@"2re1HHV"];
    return true;
}

// This function will be called when the app is inactive. When comes a phone call,it's be invoked too
void AppDelegate::applicationDidEnterBackground() {
    CCDirector::sharedDirector()->stopAnimation();

    // if you use SimpleAudioEngine, it must be pause
    // SimpleAudioEngine::sharedEngine()->pauseBackgroundMusic();
}

// this function will be called when the app is active again
void AppDelegate::applicationWillEnterForeground() {
    CCDirector::sharedDirector()->startAnimation();

    // if you use SimpleAudioEngine, it must resume here
    // SimpleAudioEngine::sharedEngine()->resumeBackgroundMusic();
}

void AppDelegate::initStrings()
{
	ccLanguageType currentLanguageType = CCApplication::sharedApplication()->getCurrentLanguage();
	if(currentLanguageType==kLanguageChinese)
	{
		fontname="FangSong_GB2312";
		fontfile = "chn.fnt";
#if (CC_TARGET_PLATFORM == CC_PLATFORM_IOS)
		fontname="Heiti SC";
#endif
        saveString("home1","用户");
		saveString("home2","温馨提示:点击用户名可切换其他用户");
		saveString("home3","关卡");
		saveString("home4","无尽");
		saveString("duel1","点击母舰可以命令全舰攻击|防守");
        saveString("Idle","AI空闲");
        saveString("Counter","AI迎战");
        saveString("Defend","AI防御");
        saveString("Mass","AI屯兵");
        saveString("Rush","AI突袭");
        saveString("HP1","补充能量 ");
        saveString("VF1","加速开火 ");
        saveString("VM1","加速前进 ");
        saveString("AT1","加强攻击 ");
        saveString("VF2","恢复开火速度");
        saveString("VM2","恢复前进速度");
        saveString("AT2","恢复攻击强度");
        saveString("Empty","空道具 ");
        saveString("Gold","金币");
        
		saveString("select1","选择|取消战斗飞机卡片,滑动翻页");
		saveString("select2","达到母舰承载上限，请进行战斗或重新选择战斗飞机卡片");
		saveString("select3","请至少选择一个战斗飞机上场 ");
		saveString("select4","已选/总数");
		saveString("gameover1","font_gameover_title_win.png");
		saveString("gameover2","font_gameover_title_lost.png");
		saveString("help1","\t欢迎来到天使星球。\n\t当人类进入了一个太空殖民时代时，有定居在轨道的行星如月球，也有定居在行星的表面的太空人。 "
                   "在卫星，在月球上，火星殖民地，或小行星提取当地材料使用太阳能。然而，一场可怕的灾难降临了，人们对于权力和资源争夺的欲望杀死了内心深处的宁静善良。 "
                   "战士们，为了正义，登上巡洋舰，与敌人战斗吧！\n\t你有三种类型的巡洋舰可以选择:\n"
                   "\t\t近战攻击巡洋舰，它可以在很短的距离敌人的攻击，\n"
                   "\t\t牵引光巡洋舰可以向在一段很长的距离的地方发射激光。\n"
                   "\t\t群攻型攻击巡洋舰多可以一次攻击范围内多个敌人，很强大。\n"
                   "\t巡洋舰有不同的攻击冷却时间，速度，耐久度，武力。与魔兽争霸一样，每艘巡洋舰需要花费资源、占用人口。 "
                   "\t为了简化游戏，现每1.5秒获得50金币。\n"
                   "\t如果人口达到最大值的60%，你将只能得到60%的常规资源。\n"
                   "\t如果人口达到最大值的80%，你将获得40%。\n"
                   "\t所有巡洋舰目前只需要2秒便可冷却，每个军营只能携带4个种类的太空舰种，好好选择吧。\n"
                   "\n\t新功能：\n"
                   "\t\t1.起始200金币\n"
                   "\t\t2.起始4架飞机\n"
                   "\t\t3.默认为战斗模式 \n"
                   "\t\t4.开启后，立即体验战斗快感！");
		saveString("shop1","购买VIP");
		saveString("shop2","享受游戏吧！");
		saveString("shop3","网络故障");
		saveString("shop4","攻击速度，移动速度，HP均有加成，大家赶紧来试试！ ");
		saveString("shop5","购买开始 ");
		saveString("shop6","购买失败 ");
		saveString("bt1","创建主机 ");
        saveString("bt2","查看主机");
        saveString("bt3","两台设备连接WIFI或蓝牙后，分别点击创建和加入，点可用列表即可对战");
        saveString("bt4","断开连接");

	}else
	{
		fontname="Georgia-Italic";
		fontfile = "Courier.fnt";
		saveString("home1","User");
		saveString("home2","Notice:Click on the name to change user");
		saveString("home3","Lv");
		saveString("home4","Endless");
		saveString("duel1","Click the mother ship to issue ATTACK|DEFEND command.");
        saveString("Idle","AI-Idle");
        saveString("Counter","AI-Counter");
        saveString("Defend","AI-Defend");
        saveString("Mass","AI-Mass");
        saveString("Rush","AI-Rush");
        saveString("HP1","HP^");
        saveString("VF1","FIRE CD^");
        saveString("VM1","MOVE^");
        saveString("AT1","WEAPON^");
        saveString("VF2","FIRE CD=");
        saveString("VM2","MOVE=");
        saveString("AT2","WEAPON=");
        saveString("Empty","NONE");
        saveString("Gold","Diamond");

		saveString("select1","Click on the plane deck, and swipe right to go to next page.");
		saveString("select2","Max planes reached, please start battle or change selected planes.");
		saveString("select3","Please select at least one plane.");
		saveString("select4","selected");
		saveString("gameover1","font_gameover_title_win_en.png");
		saveString("gameover2","font_gameover_title_lost_en.png");
		saveString("help1","\tWelcome to angel planets. \n"
                   "Human enters a period of space habitats. There are free-floating stations that orbit a planet, moon, and some settled down on"
                   "or below the surfaces of planets, moons. Colonies on the Moon, Mars, or asteroids could extract local materials. "
                   "Solar energy in orbit is abundant, reliable, and is commonly used to power satellites. "
                   "Still, people fight and kill for power and resource.\n "
                   "Warriors, it is time to meet our Cruisers, there are three types of cruisers:\n"
                   "\tMelee cruiser with Ion cannons, it can attack the enemy at a short distance, typically 5 kilometers.\n"
                   "\tMelee cruiser with Tractor beam can shoot laser at a long distance, typically 50 kilometers.\n"
                   "\tMelee cruiser with multi projectors can fight multiple enemies at one time and is very powerful.\n"
                   "\nCruisers have different full length, velocity, crew, weapon and armor. "
                   "Melee cruiser with Tractor beam has velocity and weapon cool down drawback."
                   "If all the crew died, then the cruiser would explode. Cruisers take up resource and human resource."
                   "One campaign has 30 engineers who can build cruisers, and Colonies make use of solar energy so routinely colonies get 50 units of resource every 1.5 time unit. "
                   "If the human resource reached 60% of the maximum, you will only get 60% of the routine resource. And if the human resource reached 80% of the maximum, you will get 40%."
                   "Different cruisers need 2 time units to finish building."
                   "The colonies has only 4 playgrounds for the cruisers to start, so you can only make 4 type of cruisers in the battle. Now let°?s fight for our glory.\n"
                   "\t1.You will get 200 coins at the beginning.\n"
                   "\t2.You will have 4 planes at the beginning.\n"
                   "\t3.Human player is in attack mode at the beginning.\n"
                   "\t4.For the start up you will experience the beauty of the battle.\n"
                   );
		saveString("shop1","Donate!");
		saveString("shop2","Enjoy the Game!");
		saveString("shop3","Network Error!");
		saveString("shop4","Move speed, Attack speed, HP will increase by 10%.");
		saveString("shop5","Purchase Start!");
		saveString("shop6","Purchase Fail!");
        
        saveString("bt1","Host Game");
        saveString("bt2","Join Game");
        saveString("bt3","Under wifi or BlueTooth, host a game and join in another device, then click the HOST name on the client.");
        saveString("bt4","Disconnect");

        
	}
	
}

void AppDelegate::saveString(const char* key,const char* value)
{
  #if (CC_TARGET_PLATFORM == CC_PLATFORM_IOS)
    CCUserDefault::sharedUserDefault()->setStringForKey(key,std::string(value));
#else
	std::string str = value;

    GBKToUTF8(str);
	CCUserDefault::sharedUserDefault()->setStringForKey(key,str);
#endif
}
#if (CC_TARGET_PLATFORM == CC_PLATFORM_WIN32)

int AppDelegate::GBKToUTF8(std::string &gbkStr)
{      
    iconv_t iconvH;      
  
    iconvH              = iconv_open("utf-8","gb2312");      
    if(iconvH == 0){      
        return -1;      
    }      
    const char* strChar = gbkStr.c_str();      
    const char** pin    = &strChar;      
  
    size_t strLength    = gbkStr.length();      
    char* outbuf        = (char*)malloc(strLength*4);      
    char* pBuff         = outbuf;      
    memset(outbuf,0,strLength*4);      
    size_t outLength    = strLength*4;      
    if(-1 == iconv(iconvH,pin,&strLength,&outbuf,&outLength)){      
        iconv_close(iconvH);      
        return -1;      
    }      
    gbkStr              =   pBuff;      
    iconv_close(iconvH);      
    return 0;      
}
#endif
