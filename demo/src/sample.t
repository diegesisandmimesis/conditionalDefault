#charset "us-ascii"
//
// sample.t
// Version 1.0
// Copyright 2022 Diegesis & Mimesis
//
// This is a very simple demonstration "game" for the conditionalDefault
// library.
//
// It can be compiled via the included makefile with
//
//	# t3make -f makefile.t3m
//
// ...or the equivalent, depending on what TADS development environment
// you're using.
//
// This "game" is distributed under the MIT License, see LICENSE.txt
// for details.
//
#include <adv3.h>
#include <en_us.h>

#include "conditionalDefault.h"

versionInfo: GameID;
gameMain: GameMainDef initialPlayerChar = me;

modify playerActionMessages
	cantFiddleWithCards = '{You/He} can\'t fiddle with the cards
		during a game. '

	cantNotInGame = '{You/He} can\'t do that because {you/he} {are}n\'t
		playing a game. '

	alreadyShuffled = 'The cards have already been shuffled. '
	alreadyDealt = 'The cards have already been dealt. '

	cantShuffleThat = '{You/He} can\'t shuffle {that dobj/him}. '
	okayShuffle = '{You/He} shuffle{s} the cards. '

	cantDealThat = '{You/He} can\'t deal {that dobj/him}. '
	okayDeal = '{You/He} deal{s} the cards. '

	okayToggleGame = '{You/He} are now <<((deck.gameFlag) ? '' : 'not')>>
		playing a game. '
;

startRoom: Room 'Void' "This is a featureless void. ";
+me: Person;
+deck: Thing 'deck (of) cards' 'deck of cards'
	"It's a deck of playing cards. "

	gameFlag = nil
	shuffleFlag = nil
	dealFlag = nil

	dobjFor(Default) {
		verify() {
			if(gameFlag == true)
				illogicalNow(&cantFiddleWithCards);
			else
				ignoreDefault;
		}
	}

	dobjFor(Examine) { verify() { inherited(); } }
	dobjFor(Shuffle) {
		verify() {
			if(gameFlag == nil)
				illogicalNow(&cantNotInGame);
			if(shuffleFlag == true)
				illogicalNow(&alreadyShuffled);
		}
		action() {
			defaultReport(&okayShuffle);
			shuffleFlag = true;
		}
	}
	dobjFor(Deal) {
		verify() {
			if(gameFlag == nil)
				illogicalNow(&cantNotInGame);
			if(dealFlag == true)
				illogicalNow(&alreadyDealt);
		}
		action() {
			defaultReport(&okayDeal);
			dealFlag = true;
		}
	}
;

DefineTAction(Shuffle);
VerbRule(Shuffle) 'shuffle' singleDobj : ShuffleAction
        verbPhrase = 'shuffle/shuffling (what)'
;
modify Thing
	dobjFor(Shuffle) { verify() { illogical(&cantShuffleThat); } }
;

DefineTAction(Deal);
VerbRule(Deal) 'deal' singleDobj : DealAction
        verbPhrase = 'deal/dealing (what)'
;
modify Thing
	dobjFor(Deal) { verify() { illogical(&cantDealThat); } }
;

DefineSystemAction(ToggleGame)
	execSystemAction() {
		deck.gameFlag = !deck.gameFlag;
		defaultReport(&okayToggleGame);
	}
;
VerbRule(ToggleGame) 'toggle' 'game' : ToggleGameAction
	verbPhrase = 'toggle/toggling game'
;
