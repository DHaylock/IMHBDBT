//
//  IMHBDMain.h
//  It Must Have Been Dark By Then
//
//  Created by David Haylock on 23/05/2018.
//

#pragma once
#include "ofMain.h"
#include "GEOfence.h"
#include "ofxEasing.h"
#include "CenteredFont.h"
#include "Button.h"
#include "ofxMercatorMap.h"
#include <regex>

//-----------------------------------------------------
/**
 Logging Message System
 
 @param s_Class Class / Manager Message Sent from
 @param s_Message message
 */
//-----------------------------------------------------
template<typename T>
void SystemMessage(T s_Class,T s_Message) {
    string msg = string(s_Class) + " | " + string(s_Message);
    ofSendMessage(msg);
}

//-----------------------------------------------------
enum HTTP_TYPE {
    GET_NAME = 0,
    ACTIVATED,
    DEACTIVATED,
    PLACED_GPS,
    ENTERED_GPS,
    EXITTED_GPS
};
