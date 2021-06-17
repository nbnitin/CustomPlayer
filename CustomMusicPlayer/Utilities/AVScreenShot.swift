//
//  AVScreenShot.swift
//  CustomMusicPlayer
//
//  Created by Nitin Bhatia on 6/17/21.
//

import Foundation
import AVKit
import UIKit

protocol AVScreenshotProtocol {
  static func generateThumbnailFromAsset(asset: AVAsset, forTime time: CMTime) -> UIImage?
}

extension AVScreenshotProtocol {
    static func generateThumbnailFromAsset(asset: AVAsset, forTime time: CMTime) -> UIImage? {
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        imageGenerator.appliesPreferredTrackTransform = true
        var actualTime: CMTime = CMTime.zero
        imageGenerator.requestedTimeToleranceAfter = CMTime.zero
        imageGenerator.requestedTimeToleranceBefore = CMTime.zero
        do {
            let imageRef = try imageGenerator.copyCGImage(at: time, actualTime: &actualTime)
            let image = UIImage(cgImage: imageRef)
            return image
        } catch let error as NSError {
            print("\(error.description). Time: \(actualTime)")
        }
        debugPrint("Found nil in get Thumbnail")
        return nil
    }
}
