#charset "us-ascii"
//
// conditionalDefault.t
//
//	A TADS3/adv3 module implementing a fall-through mechanism for
//	dobjFor(Default).
//
//	Without this module, the order of precedence is:
//
//		dobjFor(All)	if defined, will always be called and will
//				be called first
//
//		dobjFor(Default)	if defined, will be called if
//					defined directly on the object AND
//					and action-specific dobjFor() handler
//					is NOT defined directly on the object.
//					that is, dobjFor(Default) will not
//					override an inherited dobjFor([Action])
//		dobjFor([Action])	if defined, will be called if none
//					of the above applies
//
//	With the module, the order is:
//
//		dobjFor(All)		as in stock adv3
//		dobjFor(Default)	if defined and has precedence as per
//					the stock adv3 order of precedence
//		dobjFor([Action])	if defined, will be called EITHER
//					if defined directly on the object (as
//					in stock adv3) OR if dobjFor(Default)
//					used ignoreDefault
//
//
// USAGE
//
//	Given the object definition:
//
//		pebble: Thing '(small) (round) pebble' 'pebble'
//			"A small, round pebble. "
//
//			foozle = nil
//
//			dobjFor(Default) {
//				verify() {
//					if(foozle == true)
//						illogicalNow('The pebble is
//							foozled. ');
//					else
//						ignoreDefault;
//				}
//			}
//		;
//
//	In this example, all actions using the pebble as a direct object
//	will fail verification with the message "The pebble is foozled."
//	if the pebble's foozle property is true.  If the foozle property
//	is not true, then the pebble will behave as if the dobjFor(Default)
//	stanza was not defined.
//
//	Any additional action handlers added directly to the pebble will
//	have precedence over the dobjFor(Default) stanza, and so those
//	actions will not be affected by the default.
//
//
#include <adv3.h>
#include <en_us.h>

#include "conditionalDefault.h"

// Module ID for the library
conditionalDefaultModuleID: ModuleID {
        name = 'Conditional Default Library'
        byline = 'Diegesis & Mimesis'
        version = '1.0'
        listingOrder = 99
}

modify Action
	// Boolean flag.  If true, individual verify properties will
	// be called even if the default property has precedence.
	conditionalDefault = nil

	// Set the conditional default flag
	setConditionalDefault() { conditionalDefault = true; }

	// This is logically equivalent to the stock adv3 method, with
	// the one addition of the check for the conditionalDefault flag.
	callCatchAllProp(obj, actionProp, defProp, allProp) {
		obj.(allProp)();
		if(!obj.propHidesProp(actionProp, defProp)) {
			obj.(defProp)();

			// If the conditionalDefault flag is set, we return
			// nil even though we called the default property.
			// This is the only logical difference from the
			// stock method.
			if(conditionalDefault)
				return(nil);
			else
				return(true);
		} else {
			return(nil);
		}
	}
;
