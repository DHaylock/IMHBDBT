#include "ofApp.h"

//--------------------------------------------------------------
void ofApp::setup() {
    
    bDebugWindowTimeReached = true;
    bShowDebugWindow = true;
    bEnableDebugTimer = false;
    
    debugWindowStartTime = ofGetElapsedTimeMillis();
    debugWindowEndTime = (1000 * 5); // 10 seconds
    
    //https://gizmodo.com/how-precise-is-one-degree-of-longitude-or-latitude-1631241162
    merMap.setScreenDimensions(ofGetWindowWidth(),
                 ofGetWindowHeight());
    
    // Stop the App from sleeping
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    
    // This is a debug event listener
    ofAddListener(ofEvents().messageEvent,this,&ofApp::gotMessage);
    
    // Setup the HTTP Unit
//    HTTPManager::instance().setRoutes("http://localhost:3000", "/api/v1/add", "kjfajfoaienf;a");
    
    // Setup the GPS
    GPSManager::instance().init();
    
    // Load the Audio Files
    AudioManager::instance().loadTracks("chapters");
    
    // Get the Names of the Zones
    GPSManager::instance().setGEOFenceNames(AudioManager::instance().getTrackNames());
    ofAddListener(GPSManager::instance().movedEvent, this, &ofApp::movedEvent);
    
    Debug::instance().generateUI(AudioManager::instance().getTrackNames());
    Debug::instance().setButtonsState(bShowDebugWindow);
    mesh.clear();
    mesh.setMode(OF_PRIMITIVE_POINTS);
}

//--------------------------------------------------------------
void ofApp::update(){
    ofSoundUpdate();
    
    if (bEnableDebugTimer) {
        float timer = ofGetElapsedTimeMillis() - debugWindowStartTime;
        
        if(timer >= debugWindowEndTime && !bDebugWindowTimeReached) {
            bShowDebugWindow = !bShowDebugWindow;
            
            Debug::instance().setButtonsState(bShowDebugWindow);
            bDebugWindowTimeReached = true;
        }
    }
}

//--------------------------------------------------------------
void ofApp::draw(){

    float exp = 20 + 10 * abs(sin(ofGetElapsedTimef()));
    ofPoint user = merMap.getScreenLocationFromLatLon(GPSManager::instance().getCurrentLocation().latitude, GPSManager::instance().getCurrentLocation().longitude);
    ofSetColor(52, 152, 219);
    ofDrawCircle(user.x,user.y, exp);
    
    for(int i = 0; i < GPSManager::instance().getGEOfences().size(); i++) {
        ofPoint p = merMap.getScreenLocationFromLatLon(GPSManager::instance().getGEOfences()[i].lat, GPSManager::instance().getGEOfences()[i].lng);
        ofSetColor(0, 0, 0);
        ofDrawCircle(p.x, p.y, 20);
    }

    if(bShowDebugWindow) {
        Debug::instance().draw();
    }
    ofSetColor(255,0,0);
    for (int i = 0; i < meshData.size(); i++) {
        mesh.addVertex(merMap.getScreenLocationFromLatLon(meshData[i].latitude, meshData[i].longitude));
    }
    
    mesh.draw();
}

//--------------------------------------------------------------
void ofApp::exit(){
    // Tell the Server we are turning off
//    HTTPManager::instance().request(DEACTIVATED);
    
    // Remove the listener
    ofRemoveListener(ofEvents().messageEvent,this,&ofApp::gotMessage);
}

//--------------------------------------------------------------
void ofApp::touchDown(ofTouchEventArgs & touch){

    bEnableDebugTimer = true;
    bDebugWindowTimeReached = false;
    debugWindowStartTime = ofGetElapsedTimeMillis();
}

//--------------------------------------------------------------
void ofApp::touchMoved(ofTouchEventArgs & touch){
    
}

//--------------------------------------------------------------
void ofApp::touchUp(ofTouchEventArgs & touch){
    bEnableDebugTimer = false;
    bDebugWindowTimeReached = true;
}

//--------------------------------------------------------------
void ofApp::touchDoubleTap(ofTouchEventArgs & touch){
    GPSManager::instance().addGEOfence();
}

//--------------------------------------------------------------
void ofApp::touchCancelled(ofTouchEventArgs & touch){
    
}

//--------------------------------------------------------------
void ofApp::gotMessage(ofMessage &msg) {
    Debug::instance().addLogMessage(msg.message);
}

//--------------------------------------------------------------
void ofApp::lostFocus(){
    SystemMessage("ofApp","Lost Focus");
}

//--------------------------------------------------------------
void ofApp::gotFocus(){
    SystemMessage("ofApp","Got Focus");
}

//--------------------------------------------------------------
void ofApp::gotMemoryWarning(){

}

//--------------------------------------------------------------
void ofApp::deviceOrientationChanged(int newOrientation){

}

//--------------------------------------------------------------
void ofApp::movedEvent(ofxGPS::LocationData &d) {
    
    // This creates a moving window
    float leftLng = d.longitude - 0.005;
    float bottomLat = d.latitude - 0.01;
    float rightLng = d.longitude + 0.005;
    float topLat = d.latitude + 0.01;

    merMap.update(leftLng, bottomLat, rightLng, topLat);
    
    meshData.push_back(d);
    mesh.clear();
}
