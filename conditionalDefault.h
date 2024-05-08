//
// conditionalDefault.h
//

#define illogicalDefault(msg, params...) \
	gAction.setConditionalDefault(); \
	illogicalNow(msg, ##params)

#define CONDITIONAL_DEFAULT_H
