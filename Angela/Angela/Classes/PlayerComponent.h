#pragma once
#include "cocos2d.h"
#include "Component.h"
#include "Constant.h"

NS_CC_BEGIN
#define MAX_PEOPLE 30
#define COINS_PER_INTERVAL 50
#define INIT_COINS 400
enum PeopleOverload{
	Effecient,
	Warning,
	Overload
};
class PlayerComponent:public Component
{
public:
	bool attacking;
	int coins;
	double lastCoinDrop;
	int people;
	int maxPeople;
	PeopleOverload overload;
	PlayerComponent();
	inline bool init(){ return true;}
  
  	~PlayerComponent();
	CCString* ClassName();

	 // implement the "static node()" method manually
      CREATE_FUNC(PlayerComponent);
	void RefreshOverload();
	void RefreshCoins();
};
NS_CC_END

