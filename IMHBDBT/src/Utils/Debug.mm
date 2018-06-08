//
//  Debug.cpp
//  IMHBDBT
//
//  Created by David Haylock on 24/05/2018.
//

#include "Debug.h"

//--------------------------------------------------------------
Debug::Debug() { }

//--------------------------------------------------------------
Debug::~Debug() { }

//--------------------------------------------------------------
void Debug::generateUI(vector<std::string> trackID) {
    debugFont.load("frabk.ttf",28);
    
    int initX = 15;
    int initY = 15;
    int width = (ofGetWidth()/2) - 30;
    int height = 50;
    
    for (int i = 0; i < trackID.size(); i++) {
        buttons.push_back(new Button(initX, initY + (i*(height+10)), width, height, "Play " + trackID[i], ofColor::white, debugFont, false));
        ofAddListener(buttons.back()->pressed,this,&Debug::playBtnListener);
        buttons.push_back(new Button(initX + 10 + width, initY + (i*(height+10)), width, height, "Stop "+trackID[i], ofColor::white, debugFont, false));
        ofAddListener(buttons.back()->pressed,this,&Debug::stopBtnListener);
    }

    buttons.push_back(new Button(initX,ofGetHeight()-height,ofGetWidth()-30,50,"Reset",ofColor::red,debugFont,false));
    ofAddListener(buttons.back()->pressed,this,&Debug::resetAllBtnListener);
}

//--------------------------------------------------------------
void Debug::addLogMessage(std::string msg) {
    if (logs.size() > 15) {
        logs.pop_back();
    }
    logs.push_front(msg);
}

//--------------------------------------------------------------
void Debug::setButtonsState(bool enabled) {
    for (int i = 0; i < buttons.size(); i++) {
        buttons[i]->setEnabled(enabled);
    }
}

//--------------------------------------------------------------
void Debug::draw() {
    ofPushStyle();
    ofSetColor(50, 50, 50, 175);
    ofDrawRectangle(0, 0, ofGetWidth(), ofGetHeight());
    
    ofSetColor(ofColor::white);
    for(int i = 0; i < logs.size(); i++) {
        debugFont.drawString(logs[i], 10, (ofGetHeight()/2)+(i*35)+45);
    }
    
    stringstream ss;
    ss << "Closest Fence " << GPSManager::instance().getClosestGEOfence().id << endl;
    ss << "Distance " << GPSManager::instance().getClosestGEOfence().distance << endl;
    debugFont.drawStringCentered(ss.str(), ofGetWidth()/2, ofGetHeight()/2);
    ofPopStyle();
    
    for (int i = 0; i < buttons.size(); i++) {
        buttons[i]->draw();
    }
}

//--------------------------------------------------------------
void Debug::playBtnListener(std::string &btnName) {
    string b = ofSplitString(btnName, " ")[1];
    cout << b << endl;
    AudioManager::instance().playTrack(b);
}

//--------------------------------------------------------------
void Debug::stopBtnListener(std::string &btnName) {
    string b = ofSplitString(btnName, " ")[1];
    cout << b << endl;
    AudioManager::instance().stopTrack(b);
}

//--------------------------------------------------------------
void Debug::resetAllBtnListener(std::string &btnName) {
    GPSManager::instance().clearGEOFences();
    logs.clear();
}
