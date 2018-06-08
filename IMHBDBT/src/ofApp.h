#pragma once

#include "ofxiOS.h"
#include "GPSManager.h"
#include "AudioManager.h"
#include "Debug.h"
#include "Button.h"

class ofApp : public ofxiOSApp {
	
    public:
        void setup();
        void update();
        void draw();
        void exit();
	
        void touchDown(ofTouchEventArgs & touch);
        void touchMoved(ofTouchEventArgs & touch);
        void touchUp(ofTouchEventArgs & touch);
        void touchDoubleTap(ofTouchEventArgs & touch);
        void touchCancelled(ofTouchEventArgs & touch);

        void gotMessage(ofMessage &msg);
    
        void lostFocus();
        void gotFocus();
        void gotMemoryWarning();
        void deviceOrientationChanged(int newOrientation);
    
        Button addNewGPSButton;
    
        void buttonAction(string &btnName);
    
        float debugWindowStartTime;
        float debugWindowEndTime;
        bool bDebugWindowTimeReached;
    
        bool bShowDebugWindow;
        bool bEnableDebugTimer;
    
        void movedEvent(ofxGPS::LocationData &d);
    
        ofxMercatorMap merMap;
    
        ofMesh mesh;
        vector <ofxGPS::LocationData> meshData;
};



