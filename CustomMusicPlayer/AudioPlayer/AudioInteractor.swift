//
//  AudioInteractor.swift
//  CustomMusicPlayer
//
//  Created by Nitin Bhatia on 3/17/21.
//

import UIKit
import Photos

//view control protocol
protocol AudioIntertactorProtocol {    
    func loadVideoPlayer(parent: UIView, viewController: VideoEventDelegate,urlToPlay:URL)
    func playVideo()
    func pauseVideo()
    func toggleVideo()
    func moveWith(time: Double)
    func seek(time: Double)
    func replayVideo()
    var videoPlayer: VideoEventHandler? { get set }
}

//protocols for data store
protocol AudioDetailDataStore {
    //var urlToPlay: URL? { get set }
}

class AudioInteractor: AudioIntertactorProtocol, AudioDetailDataStore {
    
    
    //variables
    var presenter: AudioPresenterProtocol?
    var videoPlayer: VideoEventHandler?

    


//MARK: audio related function's action

    //MARK: load audio player according, for youtube there is a library to extract the loadable url from youtube encrypted url that's here we are deciding which layer to load as per the url
    func loadVideoPlayer(parent: UIView, viewController: VideoEventDelegate,urlToPlay:URL) {
            videoPlayer = VimeoPlayerWrapper()
            videoPlayer?.delegate = viewController
            videoPlayer?.loadVideoPlayer(parent: parent, url: urlToPlay)
    }
    
    //MARK: plays the video
    func playVideo() {
        videoPlayer?.playVideo()
        videoPlayer?.delegate?.videoPlayerDidPause(isVideoPause: false)
    }
    
    //MARK: pause the vide
    func pauseVideo() {
        videoPlayer?.pauseVideo()
        videoPlayer?.delegate?.videoPlayerDidPause(isVideoPause: true)
    }
    
    //MARK: toggle video
    func toggleVideo() {
        videoPlayer?.toggleVideo()
    }
    
    //MARK: jump the video to given time
    func seek(time: Double) {
        videoPlayer?.seek(time: time)
    }
    
    //MARK: replays the video
    func replayVideo() {
        videoPlayer?.replayVideo()
    }
    
    //MARK: move video with the time
    func moveWith(time: Double) {
        videoPlayer?.moveWith(time: time)
    }
    
   
}
