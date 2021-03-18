//
//  VideoEventHandler.swift
//  CustomMusicPlayer
//
//  Created by Nitin Bhatia on 3/17/21.
//

import Foundation
import UIKit

protocol VideoEventHandler: class {
    var delegate: VideoEventDelegate? { get set }
    func loadVideoPlayer(parent: UIView, url: URL)
    func playVideo()
    func pauseVideo()
    func toggleVideo()
    func closeVideo()
    func replayVideo()
    func seek(time: Double)
    func moveWith(time: Double)
}

protocol VideoEventDelegate: class {
    func videoPlayerDidReady(duration: Float64)
    func videoPlayerDidUpdatePlaying(isVideoLoading: Bool)
    func videoPlayerDidUpdateTime(currentTime: Int)
    func cantPlayVideoPresentError()
    func videoPlayerDidPause(isVideoPause:Bool)
}

extension Int {
    func stringFromSeconds() -> String {
        let seconds = self % 60
        let minutes = (self / 60) % 60
        let hours = self / 3600
        if hours == 0 {
            return String(format: "%0.2d:%0.2d", minutes, seconds)
        }
        return String(format: "%0.2d:%0.2d:%0.2d", hours, minutes, seconds)
    }
}
