//
//  VimeoPlayer.swift
//  CustomMusicPlayer
//
//  Created by Nitin Bhatia on 3/17/21.
//

import Foundation
import AVKit

class VimeoPlayerWrapper:NSObject, VideoEventHandler, AVScreenshotProtocol {
    
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
    
    func takeScreenshot() -> UIImage? {
        guard let asset = selectedAVURLAsset else {
            debugPrint("Found nil while accessing  selectedAVURLAsset.")
            return nil
        }
        var screenShotTime: CMTime = asset.duration
        screenShotTime.value = CMTimeValue(Int(player.time))
        
        if let img = Self.generateThumbnailFromAsset(asset: asset, forTime: player.getCurrentTime()) {
            return img
        } else {
//            //hls or m3u8 url video
            return imageFromCurrentPlayerContext()
        }
        
    }
    
    private func imageFromCurrentPlayerContext()->UIImage? {
        
        let jpegCompressionQuality = 0.7
        let currentTime: CMTime =  player.getCurrentTime()
        guard let buffer: CVPixelBuffer = (player.getPlayerItemVideoOutputObject()).copyPixelBuffer(forItemTime: currentTime, itemTimeForDisplay: nil) else { return nil }
        let ciImage: CIImage = CIImage(cvPixelBuffer: buffer)
        let context: CIContext = CIContext.init(options: nil)
        
        guard let cgImage: CGImage = context.createCGImage(ciImage, from: ciImage.extent) else { return nil }
        let image: UIImage = UIImage.init(cgImage: cgImage)
         guard let jpegImage: Data = image.jpegData(compressionQuality: CGFloat(jpegCompressionQuality)) else { return nil }
        print(jpegImage)
        return image
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
