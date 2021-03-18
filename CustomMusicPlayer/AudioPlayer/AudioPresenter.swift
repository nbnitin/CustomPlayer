//
//  AudioPresenter.swift
//  CustomMusicPlayer
//
//  Created by Nitin Bhatia on 3/17/21.
//

import Foundation
//protocol
protocol AudioPresenterProtocol {
    func presentLoader(show: Bool)
    func goBack()
}
class AudioPresenter: AudioPresenterProtocol {
    
    //variables
    weak var viewController: AudioDisplayProtocol?
    
    //MARK: shows the loader
    func presentLoader(show: Bool) {
        self.viewController?.showLoader(show: show)
    }
    
    
    
    //MARK: go back to parent
    func goBack() {
        self.viewController?.goBack()
    }
}
