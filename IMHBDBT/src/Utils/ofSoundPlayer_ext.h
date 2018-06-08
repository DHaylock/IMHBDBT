//
//  ofSoundPlayer_ext.h
//  It Must Have Been Dark By Then
//
//  Created by David Haylock on 23/05/2018.
//

#ifndef ofSoundPlayer_ext_h
#define ofSoundPlayer_ext_h

#include "IMHBDMain.h"

class ofSoundPlayer_ext: public ofSoundPlayer {

    public:
    
        ofSoundPlayer_ext() {
            ofAddListener(ofEvents().update, this, &ofSoundPlayer_ext::update);
        }
    
        void playTrack() {
            this->setVolume(0.0f);
            this->setPosition(0.0);
            this->play();
            notified = false;
        }
    
        void setTrackID(string id) {
            this->trackID = id;
        }
    
        void fadeVolume(float level,float duration) {
            previousVolume = currentVolume;
            newVolume = level;
            this->duration = duration;
            initTime = ofGetElapsedTimef();
            endTime = initTime + duration;
        }
    
        void update(ofEventArgs &evt) {
            
            
            auto now = ofGetElapsedTimef();
            
            currentVolume = ofxeasing::map_clamp(now,
                                                  initTime,
                                                  endTime,
                                                  previousVolume,
                                                  newVolume,
                                                  &ofxeasing::linear::easeInOut);
            
            this->setVolume(currentVolume);
            
//            cout << trackID << " " << currentVolume << endl;
            
            if(!this->isPlaying() && !notified) {
                ofNotifyEvent(trackFinished,trackID,this);
                notified = true;
            }
        }
    
    
        ofEvent<string> trackFinished;
    private:
        bool notified = true;
    
        float duration = 0.0f;
        float newVolume = 0.0;
        float currentVolume = 0.0f;
        float previousVolume = 0.0f;
        float initTime;
        float endTime;
        string trackID;
};

#endif /* ofSoundPlayer_ext_h */
