//
//  FeedModel.swift
//  CustomMusicPlayer
//
//  Created by Nitin Bhatia on 3/17/21.
//

import Foundation
class Feed: Codable {
    var mediaContentId: String?
    var personalContentId: String?
    var userContentActionId: String?
    var contentUrl, thumbnailUrl: String?
    var highThumbnailUrl: String?
    var source, contentType, tags: String?
    var channelID, videoID, pixabayImageID, unsplashImageID: String?
    var title: String?
    var timestamp: Double?
    var userId, familyId, deviceId, deviceType: String?
    var nextPageToken, prevPageToken: String?
    var imageCategory: String?
    var appName, appPackageName, appDevName, appVersion: String?
    var appIcon, sourceURL: String?
    var webformatURL: String?
    var epubDownloadLink: String?
    var pdfDownloadLink, welcomeDescription, bookId, viewability: String?
    var saleability, textToSpeechPermission, key: String?
    var contentFilter: String? //TODO remove this
    var sharedWith, sharedWithId, sharedWithRelation, sharedFrom, sharedFromId: String?
    var url: String?
}

enum FeedType: String, CaseIterable, Codable {
    case video
    case audio
   

    func toString() -> String {
        switch self {
            case .audio: return FeedType.audio.rawValue
            
            case .video: return FeedType.video.rawValue
        }
    }
}

extension StringProtocol {
    var firstUppercased: String { return prefix(1).uppercased() + dropFirst() }
    var firstCapitalized: String { return prefix(1).capitalized + dropFirst() }
}
