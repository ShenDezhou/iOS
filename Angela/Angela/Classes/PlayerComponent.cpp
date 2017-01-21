#include "PlayerComponent.h"

USING_NS_CC;
PlayerComponent::PlayerComponent()
{
	people = 0;
	maxPeople = MAX_PEOPLE;
	attacking = false;
	coins = INIT_COINS;
	lastCoinDrop = 0;

}
PlayerComponent::~PlayerComponent(){}
CCString* PlayerComponent::ClassName()
{
	return CCString::create("PlayerComponent");
}

void PlayerComponent::RefreshOverload()
{
	if(this->people / float(this->maxPeople) < 0.6)
	{
		this->overload = Effecient;
	}else if(this->people / float(this->maxPeople) < 0.8)
	{
		this->overload = Warning;
	}else
		this->overload = Overload;

}

void PlayerComponent::RefreshCoins()
{
	this->lastCoinDrop =  GetTickCount();
	switch(this->overload)
	{
	case Effecient:
		this->coins += COINS_PER_INTERVAL;
		break;
	case Warning:
		this->coins += COINS_PER_INTERVAL*0.7;
		break;
	case Overload:
		this->coins += COINS_PER_INTERVAL*0.4;
		break;
	default:
		this->coins += COINS_PER_INTERVAL;
		break;
	}
	
 

}