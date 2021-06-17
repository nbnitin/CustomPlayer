//
//  ViewController.swift
//  CustomMusicPlayer
//
//  Created by Nitin Bhatia on 3/17/21.
//

import UIKit

class ViewController: UIViewController {

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
    }

    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
    }

    @IBAction func playVideo(_ sender: Any) {
        //use this for HLS or m3u8 videos
        //http://demo.unified-streaming.com/video/tears-of-steel/tears-of-steel.ism/.m3u8
        
        //for mp4 videos
       // http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4
        
        performPlay(url:URL(string: "http://demo.unified-streaming.com/video/tears-of-steel/tears-of-steel.ism/.m3u8")!,isViewOld: false)
    }
    @IBAction func playAudio(_ sender: Any) {
        performPlay(url:URL(string: "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3")!,isViewOld: false)
    }
    
    @IBAction func playVideoInOldView(_ sender: Any) {
        performPlay(url:URL(string: "http://demo.unified-streaming.com/video/tears-of-steel/tears-of-steel.ism/.m3u8")!,isViewOld: true)
    }
    
    @IBAction func playAudioInOldView(_ sender: Any) {
        performPlay(url:URL(string: "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3")!,isViewOld: true)
    }
    
    private func performPlay(url:URL,isViewOld:Bool){
        let sb = UIStoryboard(name: "Player", bundle: nil)
        
        if isViewOld {
            presentOldView(sb: sb, url: url)
        } else {
            presentNewView(sb: sb, url: url)
        }
        
    }
    
    private func presentNewView(sb:UIStoryboard,url:URL){
        let vc = sb.instantiateViewController(withIdentifier: "AudioViewControllerNewView") as? AudioViewControllerNewView
        //http://techslides.com/demos/sample-videos/small.mp4
        //http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4
        //https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3
        vc?.urlToPlay = url
        AppUtility.lockOrientation(.landscape, andRotateTo: .landscapeLeft)
        vc?.modalPresentationStyle = .fullScreen
        self.present(vc!, animated: true, completion: nil)
    }
    
    private func presentOldView(sb:UIStoryboard,url:URL){
        let vc = sb.instantiateViewController(identifier: "AudioViewController") as? AudioViewController
        //http://techslides.com/demos/sample-videos/small.mp4
        //http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4
        //https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3
        vc?.urlToPlay = url
        AppUtility.lockOrientation(.landscape, andRotateTo: .landscapeLeft)
        vc?.modalPresentationStyle = .fullScreen
        self.present(vc!, animated: true, completion: nil)
    }
}

