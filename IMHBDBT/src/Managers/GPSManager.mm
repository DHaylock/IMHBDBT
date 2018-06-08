//
//  GPSManager.cpp
//  It Must Have Been Dark By Then
//
//  Created by David Haylock on 23/05/2018.
//

#include "GPSManager.h"
#include <regex>

// Earth Radius
static double ER = 6371.0;

//--------------------------------------------------------------
GPSManager::GPSManager() {
    // Inited the Manager
    SystemMessage("GPSManager", "Initialized GPS Manager");
}

//--------------------------------------------------------------
void GPSManager::init() {
    
    // If the GPS unit exists kill it and restart
    if (gps != nullptr) {
        gps = nullptr;
        SystemMessage("GPSManager", "Restarting GPS");
    }
    
    // Create New GPS module
    gps = new ofxGPS();
    
    // Add Listeners
    ofAddListener(gps->newLocationDataEvent, this, &GPSManager::newLocationData);
    ofAddListener(gps->newHeadingDataEvent, this, &GPSManager::newHeadingData);
    
    // Start the Services
    gps->startHeading();
    gps->startLocation();
    GEOfenceCounter = 0;
}

//--------------------------------------------------------------
GPSManager::~GPSManager() {
    // Deconstructor
}

//--------------------------------------------------------------
void GPSManager::addGEOfence() {
    
    string newGEOFenceName = regex_replace(trackID[GEOfenceCounter],std::regex("1"),"2");
    
    stringstream ss;
    ss << "New GEOfence";
    ss << "Id: " << newGEOFenceName;
    ss << "Lat: " << currentLocation.latitude;
    ss << " Lng: " << currentLocation.longitude << endl;
    
    SystemMessage("GPSManager", ss.str().c_str());
    
    AudioManager::instance().playTrack(trackID[GEOfenceCounter]);
    
    geofences.push_back(GEOfence(newGEOFenceName, currentLocation.latitude, currentLocation.longitude, 50, true));
    
    if(GEOfenceCounter < trackID.size()) {
        GEOfenceCounter++;
    }
}

//--------------------------------------------------------------
void GPSManager::clearGEOFences() {
    geofences.clear();
    GEOfenceCounter = 0;
    SystemMessage("GPSManager", "Clearing GEOfences");
}

//--------------------------------------------------------------
void GPSManager::setGEOFenceNames(vector<std::string> trackID) {
    this->trackID = trackID;
}

//--------------------------------------------------------------
bool compareByDistance(const GEOfence &a,const GEOfence &b) {
    return a.distance < b.distance;
}

//--------------------------------------------------------------
void GPSManager::newLocationData(const ofxGPS::LocationData &d) {
    this->currentLocation = d;
    
    ofNotifyEvent(movedEvent, currentLocation,this);
    
    for (int i = 0; i < geofences.size(); i++) {
        computeDistanceOfFence(geofences[i],d);
    }
    
    sort(geofences.begin(), geofences.end(),compareByDistance);
}

//--------------------------------------------------------------
void GPSManager::computeDistanceOfFence(GEOfence &g,const ofxGPS::LocationData d) {
    const double gLat = g.lat;
    const double gLng = g.lng;
    
    const double deltaP = (ofDegToRad(gLat) - ofDegToRad(d.latitude));
    const double deltaL = (ofDegToRad(gLng) - ofDegToRad(d.longitude));
    
    const double theta = sin(deltaP/2) *
                         sin(deltaP/2) +
                         cos(ofDegToRad(d.latitude)) *
                         cos(ofDegToRad(gLat)) *
                         sin(deltaL/2) *
                         sin(deltaL/2);
    
    const double alpha = 2 * atan2(sqrt(theta), sqrt(1-theta));
    const double distance = ER * alpha;
    
    g.distance = distance;
    
    // How far away we want to trigger the event from
    static float threshold = 0.1f;
    if(g.distance < threshold && !g.entered) {
        AudioManager::instance().playTrack(g.id);
        g.entered = true;
    }
    else if(g.distance > threshold && g.entered) {
        g.entered = false;
    }
}

//--------------------------------------------------------------
void GPSManager::newHeadingData(const ofxGPS::HeadingData &d) {
    this->currentHeading = d;
}

//--------------------------------------------------------------
deque <GEOfence> GPSManager::getGEOfences() {
    return geofences;
}

//--------------------------------------------------------------
ofxGPS::LocationData GPSManager::getCurrentLocation() {
    return currentLocation;
}

//--------------------------------------------------------------
GEOfence GPSManager::getClosestGEOfence() {
    if (geofences.empty())
        return GEOfence("NULL", 0, 0, 0, false);
    
    return geofences.front();
}

//--------------------------------------------------------------
void GPSManager::resetAll() {
    geofences.clear();
    GEOfenceCounter = 0;
}
