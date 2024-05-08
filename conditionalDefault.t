#charset "us-ascii"
//
// conditionalDefault.t
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
