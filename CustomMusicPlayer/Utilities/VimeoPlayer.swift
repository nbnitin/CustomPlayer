//
//  VimeoPlayer.swift
//  CustomMusicPlayer
//
//  Created by Nitin Bhatia on 3/17/21.
//

import Foundation
import AVKit

class VimeoPlayerWrapper:NSObject, VideoEventHandler {
    
    private var player = RegularPlayer()
    private var selectedAVURLAsset: AVURLAsset?
    private var isVideoLoading = false
    weak var delegate: VideoEventDelegate?
    
    func loadVideoPlayer(parent: UIView, url: URL) {
        loadAVAsset(parent: parent, avAsset: AVURLAsset(url: url))
    }
    
    func loadAVAsset(parent: UIView, avAsset: AVAsset) {
        DispatchQueue.main.async {
            self.selectedAVURLAsset = avAsset as? AVURLAsset
            self.player.view.frame = UIScreen.main.bounds
            self.player.delegate = self
            parent.addSubview(self.player.view)
            self.player.set(avAsset)
            self.playVideo()
        }
    }
    
    
    func playVideo() {
        debugPrint("Playing from Vimeo")
        player.play()
    }
    
    func pauseVideo() {
        debugPrint("Pausing from Vimeo")
        player.pause()
    }
    
    func toggleVideo() {
        debugPrint("Toggling from vimeo")
        if player.playing {
            player.pause()
        } else {
            player.play()
        }
    }
    func closeVideo() {
        //TODO: Check how can stop Vimeo Video
        pauseVideo()
        
    }
    
    func moveWith(time: Double) {
        player.seek(to: player.time + time)
    }
    
    func seek(time: Double) {
        player.seek(to: time)
    }
    
    
    
    func replayVideo() {
        player.seek(to: 0)
        player.play()
    }
    
    deinit {
        debugPrint("Vimeo Deinitializer called")
    }
}

extension VimeoPlayerWrapper: PlayerDelegate {
    func playerDidUpdateState(player: Player, previousState: PlayerState) {
        if player.state == .ready {
            debugPrint("In Ready")
            let duration : CMTime = selectedAVURLAsset!.duration
            let seconds : Float64 = CMTimeGetSeconds(duration)
            delegate?.videoPlayerDidReady(duration: seconds)
        }
        if player.playing {
           debugPrint("In Playing")
        }
        if player.state == .loading {
            isVideoLoading = true
            debugPrint("In Loading")
            delegate?.videoPlayerDidUpdatePlaying(isVideoLoading: isVideoLoading)
        }

    }
    
    func playerDidUpdatePlaying(player: Player) {
        debugPrint("In Update Playing")
    }
    
    func playerDidUpdateTime(player: Player) {
        debugPrint("In Update Time")
        if isVideoLoading {
            isVideoLoading = false
            delegate?.videoPlayerDidUpdatePlaying(isVideoLoading: isVideoLoading)
        }
        delegate?.videoPlayerDidUpdateTime(currentTime: Int(player.time))
    }
    
    func playerDidUpdateBufferedTime(player: Player) {
        debugPrint("In buffereing")
        debugPrint(player.bufferedTime)
    }
}
