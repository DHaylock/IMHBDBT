//
//  Debug.h
//  IMHBDBT
//
//  Created by David Haylock on 24/05/2018.
//

#ifndef Debug_h
#define Debug_h

#include <stdio.h>
#include "IMHBDMain.h"
#include "GPSManager.h"
#include "AudioManager.h"

class Debug {
    public:
        //--------------------------------------------------------------
        /**
         Create Instance
         
         @return instance
         */
        //--------------------------------------------------------------
        static Debug& instance() {
            static Debug *instance_ = new Debug();
            return *instance_;
        }
    
        //--------------------------------------------------------------
        /**
         Generate The Debug UI

         @param trackID tracknames
         */
        //--------------------------------------------------------------
        void generateUI(vector<string> trackID);
    
        //--------------------------------------------------------------
        /**
         Draw the Debug Screen
         */
        //--------------------------------------------------------------
        void draw();
    
        //--------------------------------------------------------------
        /**
         Set the Buttons Active / Inacgive

         @param enabled state
         */
        //--------------------------------------------------------------
        void setButtonsState(bool enabled);
    
        //--------------------------------------------------------------
        /**
         Add Message to the Log Stash

         @param msg message
         */
        //--------------------------------------------------------------
        void addLogMessage(string msg);
    
        //--------------------------------------------------------------
        /**
         When the Button is Triggered

         @param sender which button
         */
        //--------------------------------------------------------------
        void playBtnListener(string &btnName);

        //--------------------------------------------------------------
        /**
         When the Button is Triggered

         @param sender which button
         */
        //--------------------------------------------------------------
        void stopBtnListener(string &btnName);

        //--------------------------------------------------------------
        /**
         Reset all of the Data in the App

         @param btnName the button
         */
        //--------------------------------------------------------------
        void resetAllBtnListener(string &btnName);
    
    private:
    
        //--------------------------------------------------------------
        /**
         Constructor
         */
        //--------------------------------------------------------------
        Debug();
    
        //--------------------------------------------------------------
        /**
         Deconstructor
         */
        //--------------------------------------------------------------
        ~Debug();
    
    
        deque <string> logs;
        CenteredFont debugFont;
    protected:
//        ofxUICanvas *ui;
    
//        void guiEvent(ofxUIEventArgs &e);
    
        vector <Button*> buttons;
        Button *resetAll;
        vector <string> trackIDs;
};

#endif /* Debug_h */
