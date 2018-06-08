//
//  AudioManager.h
//  It Must Have Been Dark By Then
//
//  Created by David Haylock on 23/05/2018.
//

#ifndef AudioManager_h
#define AudioManager_h

#include <stdio.h>
#include "IMHBDMain.h"
#include "ofSoundPlayer_ext.h"

class AudioManager {
    public:
    
        //--------------------------------------------------------------
        /**
         Create Instance

         @return instance
         */
        //--------------------------------------------------------------
        static AudioManager& instance() {
            static AudioManager *instance_ = new AudioManager();
            return *instance_;
        }
    
        //--------------------------------------------------------------
        /**
         Load the Tracks in the Folder

         @param folder which folder
         */
        //--------------------------------------------------------------
        void loadTracks(string folder);
    
        //--------------------------------------------------------------
        /**
         Plays the track with the specified ID

         @param trackID track identifier
         @param level what level to fade to
         @param duration how long to fade over
         */
        //--------------------------------------------------------------
        void playTrack(string trackID,float level = 1.0f, float duration = 1.0f);
    
        //--------------------------------------------------------------
        /**
         Fade the track

         @param trackID track identifier
         @param .0f level
         @param .0f duration
         */
        //--------------------------------------------------------------
        void fadeTrack(string trackID,float level = 1.0f, float duration = 1.0f);
    
        //--------------------------------------------------------------
        /**
         Stops the track with the specified ID

         @param trackID track identifier
         */
        //--------------------------------------------------------------
        void stopTrack(string trackID);
    
        //--------------------------------------------------------------
        /**
         Notify us when the track starts playing
         
         @param trackID which track?
         */
        //--------------------------------------------------------------
        void trackHasStarted(string &trackID);
    
        //--------------------------------------------------------------
        /**
         Notify us when the track finishes

         @param trackID which track?
         */
        //--------------------------------------------------------------
        void trackHasFinished(string &trackID);

        //--------------------------------------------------------------
        /**
         Get the Track Names

         @return list of strings
         */
        //--------------------------------------------------------------
        vector <string> getTrackNames();
    
        //--------------------------------------------------------------
        /**
         Clear the Audio Queue
         */
        //--------------------------------------------------------------
        void clearQueue();
    
        //--------------------------------------------------------------
        /**
         Update automatically

         @param e arguement
         */
        //--------------------------------------------------------------
        void update(ofEventArgs &e);
    
    private:
        map<string,ofSoundPlayer_ext*> tracks;
    
        ofDirectory audioDirectory;
        vector <string> trackNames;
    
        deque<string> queue; // Playlist
    
        bool trackDirectoryEmpty = false;
};

#endif /* AudioManager_h */
