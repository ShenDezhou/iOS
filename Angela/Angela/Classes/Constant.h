//
//  Created by Ray Wenderlich on 10/24/12.
//  Copyright (c) 2012 Razeware LLC. All rights reserved.
//
#pragma once
#include <stdlib.h>
#include "cocos2d.h"
#include "CCControlSlider.h"
#include "CCControlPotentiometer.h"
#if (CC_TARGET_PLATFORM == CC_PLATFORM_IOS)
#import <QuartzCore/CABase.h>
#endif
NS_CC_BEGIN
#if (CC_TARGET_PLATFORM == CC_PLATFORM_IOS)
#define CCRANDOM_X_Y(__X__, __Y__)  (((__Y__) - (__X__)) * (rand() / (float)RAND_MAX) + (__X__))
#else
#define CCRANDOM_X_Y(__X__, __Y__) (((__Y__) - (__X__)) * (rand() / (float)RAND_MAX) + (__X__))
#endif
#define OPPOSITE_TEAM(__TEAM__)  (__TEAM__==1?2:1   )


#if (CC_TARGET_PLATFORM == CC_PLATFORM_IOS)
#define SOUND 1
typedef unsigned int UINT;
typedef bool BOOL;
#define GetTickCount() CACurrentMediaTime() * 1000
#endif

#define SLIDENUM 7
#define BUILDING_NUM 1
#define SPRITE_NUM 8
#define EFFECT_NUM 15

#define	STEP 4
#define BACKGROUND_NUM 5

#define ACCELERATE_MAX 100

typedef struct tagResource{
	cocos2d::CCSize size;
	char directory[100];
}Resource;
static Resource tinyResource  ={ cocos2d::CCSizeMake(480, 320),   "iphone" };
static Resource smallResource  ={ cocos2d::CCSizeMake(960, 640),   "iphonehd" };
static Resource mediumResource =  { cocos2d::CCSizeMake(1024, 768),  "ipad"   };
static Resource largeResource  =  { cocos2d::CCSizeMake(2048, 1536), "ipadhd" };
static Resource ip5Resource  ={ cocos2d::CCSizeMake(1136, 640),   "iphone5" };

static cocos2d::CCSize designResolutionSize = cocos2d::CCSizeMake(480, 320);
static cocos2d::CCSize ip5DesignResolutionSize = cocos2d::CCSizeMake(568, 320);
static cocos2d::CCSize ipadDesignResolutionSize = cocos2d::CCSizeMake(1024, 768);

typedef enum {
    MonsterTypeQuirk = BUILDING_NUM,
    MonsterTypeZap,
    MonsterTypeMunch,
    MonsterTypeDragon,
    MonsterTypePhoenix,
	MonsterTypeCharlie,
	MonsterTypeMiles,
	MonsterTypeNeville
} MonsterType;

typedef enum {
    EffectTypeBullet,
	EffectTypeExplosion,
	EffectTypeFire,
	EffectTypeRing,
	EffectType5Color,
	EffectTypeBoilingFoam,
	EffectTypeBurstPipe,
	EffectTypeFlower,
	EffectTypePhoenix,
	EffectTypeComet,
	EffectTypeLavaFlow,
	EffectTypeGalaxy,
	EffectTypeExplodingRing,
	EffectTypeSpiral,
	EffectTypeUpsidedown
} EffectType;
typedef enum {
 	ItemTypeAttackPoint,
	ItemTypeMaxHitPoint,
	ItemTypeArmorPoint,
	ItemTypeAccuracyPoint,
	ItemTypeMissPoint,
	ItemTypeCriticalPoint,
	ItemTypeDirectDamagePoint,
	ItemTypeMoveSpeed,
	ItemTypeFireSpeed,
	ItemTypeGold,
	ItemTypeExperience,
	ItemTypeLevelUp,
	
} ItemType;

typedef struct FightProperty{
	float HitPoint;
	int maxVelocity;
	int bulletVelocity;
	float Damage;
	float FireRate;
	float Range;
	bool melee;
	bool range;
	bool aoe;
	int FoodCap;
} Fight;

typedef struct DamageProperty{
	bool destroySelf;
	float lastDamageTime;
	//bool notBullet;
} Damage;

typedef struct DeckProperty{
	const char* atlas[2];
	const char* atlas_sel;
	bool selection;
	const char* name;
	const char* sound;
	int price;
	float buildtime;
	bool cooldown;
	cocos2d::extension::CCControlPotentiometer* potentio;
	cocos2d::CCMenuItemSprite* button;
	//cocos2d::SEL_MenuHandler handler;
	Fight fight;
} Deck;

typedef struct EffectProperty{
	char* name;
	char pngname[20];
	CCParticleBatchNode* particle;
} Effect;

NS_CC_END

extern const char* items[];
extern const char* slideratlas[];
extern const char* sliderintro[];
extern const char* atlas_deck[] ;
extern const char* atlas_sel[];
extern const char* atlas[];
extern const char* atlas2[]; 
extern bool selection[];
extern cocos2d::Deck decks[];
extern cocos2d::Deck bullet[];
extern cocos2d::Deck maxDeck[];
extern cocos2d::extension::CCControlSlider* sliders[];
extern int values[2][9];
extern cocos2d::Effect effects[];
extern bool gameresult;
extern const char* backgrounds[];
extern const char* airplanes[];
extern const char* airplanes_atk[];
extern int g_level;
extern int deckscount;
extern bool level_passed[];
extern int xMARGIN;
extern int yMARGIN;
extern int yOffset;
extern bool PAIDUSER;
extern float PAIDRATE;
extern int fontSizeBig;
extern int fontSizeSmall;
extern int fontSizeTiny;
extern cocos2d::ccColor3B fontColor;
extern float SPEEDRATIO;
extern int MAX_SELECTED;
extern bool pvp;
extern const char* fontname;
extern const char* fontfile;
extern int aiIndex;
extern int humanIndex;
extern int role;