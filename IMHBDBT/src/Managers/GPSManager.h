//
//  GPSManager.h
//  It Must Have Been Dark By Then
//
//  Created by David Haylock on 23/05/2018.
//

#ifndef GPSManager_h
#define GPSManager_h

#include <stdio.h>
#include "ofxGPS.h"
#include "IMHBDMain.h"
#include "HTTPManager.h"
#include "AudioManager.h"

class GPSManager {
  
    public:
        //--------------------------------------------------------------
        /**
         Create Instance
         
         @return instance
         */
        //--------------------------------------------------------------
        static GPSManager& instance() {
            static GPSManager *instance_ = new GPSManager();
            return *instance_;
        }

        //--------------------------------------------------------------
        void init();
    
        //--------------------------------------------------------------
        /**
         Generate a new GPS Zone
         */
        //--------------------------------------------------------------
        void addGEOfence();
    
        //--------------------------------------------------------------
        /**
         Clear All GEOfences
         */
        //--------------------------------------------------------------
        void clearGEOFences();
    
        //--------------------------------------------------------------
        /**
         Set the Track ID's

         @param trackID list of track ids from the audio manager
         */
        //--------------------------------------------------------------
        void setGEOFenceNames(vector <string> trackID);
    
        //--------------------------------------------------------------
        /**
         Listen for New heading Data
         
         @param d Location Data
         */
        //--------------------------------------------------------------
        void newHeadingData(const ofxGPS::HeadingData &d);
    
        //--------------------------------------------------------------
        /**
         Listen for New Location Data

         @param d Location Data
         */
        //--------------------------------------------------------------
        void newLocationData(const ofxGPS::LocationData &d);
    
        // Well Use this instead of the native core location
        ofxGPS* gps = nullptr;
    
        ofxGPS::LocationData currentLocation;
        ofxGPS::HeadingData currentHeading;
    
        //--------------------------------------------------------------
        /**
         Get the Current Fences Created

         @return 
         */
        //--------------------------------------------------------------
        deque <GEOfence> getGEOfences();
    
        //--------------------------------------------------------------
        /**
         Get the Current Locaiton

         @return loaction data
         */
        //--------------------------------------------------------------
        ofxGPS::LocationData getCurrentLocation();
    
        //--------------------------------------------------------------
        /**
         Singular

         @param d current location
         */
        //--------------------------------------------------------------
        void computeDistanceOfFence(GEOfence &g,const ofxGPS::LocationData d);
    
        //--------------------------------------------------------------
        /**
         Get the Closest Fence

         @return geofence
         */
        //--------------------------------------------------------------
        GEOfence getClosestGEOfence();
    
        //--------------------------------------------------------------
        /**
         Reset all containers
         */
        //--------------------------------------------------------------
        void resetAll();
    
        ofEvent <ofxGPS::LocationData> movedEvent;
    
    private:
        GPSManager();
        ~GPSManager();
    
        deque <GEOfence> geofences;
    
        int GEOfenceCounter = 0;
        vector <string> trackID;
};

#endif /* GPSManager_h */
