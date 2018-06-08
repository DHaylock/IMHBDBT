//
//  AudioManager.cpp
//  It Must Have Been Dark By Then
//
//  Created by David Haylock on 23/05/2018.
//

#include "AudioManager.h"

//--------------------------------------------------------------
void AudioManager::loadTracks(std::string folder) {
    
    SystemMessage("AudioManager", "Loading Tracker from folder");
    audioDirectory.listDir(folder);
    audioDirectory.allowExt("mp3");
    audioDirectory.sort();
    trackDirectoryEmpty = false;
    
    if (audioDirectory.size() == 0) {
        trackDirectoryEmpty = true;
        SystemMessage("AudioManager", "No Audio Files");
        return;
    }
   
    
    for (int i = 0; i < audioDirectory.size(); i++) {
        string track = audioDirectory.getName(i).substr(0,audioDirectory.getName(i).size()-4);
    
        trackNames.push_back(track);
        ofSoundPlayer_ext * newTrack;
        newTrack = new ofSoundPlayer_ext();
        newTrack->load(audioDirectory.getPath(i));
        SystemMessage("AudioManager", "Loading File");
        newTrack->setTrackID(track);
    
        ofAddListener(newTrack->trackFinished,this,&AudioManager::trackHasFinished);
    
        tracks.insert(pair<string,ofSoundPlayer_ext*>(track,newTrack));
    }
    
    ofAddListener(ofEvents().update,this,&AudioManager::update);
}

//--------------------------------------------------------------
void AudioManager::playTrack(std::string trackID,float level, float duration) {
    if (!trackDirectoryEmpty) {
    
        if (queue.empty()) {
            string ss = "Play Track : " + trackID;
            SystemMessage("AudioManager", ss.c_str());
            tracks.at(trackID)->playTrack();
            tracks.at(trackID)->fadeVolume(level, duration);
            
            queue.push_front(trackID);
        }
        else {
            string ss = "Track Added to Queue : " + trackID;
            SystemMessage("AudioManager", ss.c_str());
            queue.push_front(trackID);
        }
    }
}

//--------------------------------------------------------------
void AudioManager::fadeTrack(std::string trackID,float level, float duration) {
    if (!trackDirectoryEmpty) {
        tracks.at(trackID)->fadeVolume(level, duration);
    }
}

//--------------------------------------------------------------
void AudioManager::stopTrack(std::string trackID) {
    if (!trackDirectoryEmpty) {
        tracks.at(trackID)->stop();
        deque<string>::iterator it;
    
        it = find(queue.begin(), queue.end(), trackID);
    
        if (it != queue.end()) {
            auto index = distance(queue.begin(), it);
            cout << "Found " << trackID << " At index: " <<  index << endl;
            queue.erase(queue.begin()+index);
        }
    }
}

//--------------------------------------------------------------
void AudioManager::trackHasStarted(std::string &trackID) {
    string ss = "Track Started: " + trackID;
    SystemMessage("AudioManager", ss.c_str());
}

//--------------------------------------------------------------
void AudioManager::trackHasFinished(std::string &trackID) {
    string ss = "Track Finished: " + trackID;
    SystemMessage("AudioManager", ss.c_str());
    
    deque<string>::iterator it;
    it = find(queue.begin(), queue.end(), trackID);
    if (it != queue.end()) {
        auto index = distance(queue.begin(), it);
        cout << "Found " << trackID << " At index: " <<  index << endl;
        queue.erase(queue.begin()+index);
    }

    if (!queue.empty()) {
        string ss = "Playing Queued Track : " + queue.front();
        SystemMessage("AudioManager", ss.c_str());
        tracks.at(queue.front())->playTrack();
        tracks.at(queue.front())->fadeVolume(1.0, 2.0);
    }
}

//--------------------------------------------------------------
void AudioManager::clearQueue() {
    queue.clear();
}

//--------------------------------------------------------------
vector<string> AudioManager::getTrackNames() {
    return trackNames;
}

//--------------------------------------------------------------
void AudioManager::update(ofEventArgs &e) {
    
}
