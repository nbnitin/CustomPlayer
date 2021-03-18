//
//  AudioRouter.swift
//  CustomMusicPlayer
//
//  Created by Nitin Bhatia on 3/17/21.
//

import Foundation
import Foundation
import UIKit

protocol AudioRouterProtocol {
    
}

protocol AudioDataPassing
{
    var dataStore: AudioDetailDataStore? { get }
}

class AudioRouter: AudioRouterProtocol, AudioDataPassing {
    
    weak var viewController: AudioViewController?
    var dataStore: AudioDetailDataStore?
    
    
    
    
}
