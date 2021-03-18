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
        performPlay(url:URL(string: "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4")!)
    }
    @IBAction func playAudio(_ sender: Any) {
        performPlay(url:URL(string: "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3")!)
    }
    
    private func performPlay(url:URL){
        let sb = UIStoryboard(name: "Player", bundle: nil)
        let vc = sb.instantiateInitialViewController() as? AudioViewController
        //http://techslides.com/demos/sample-videos/small.mp4
        //http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4
        //https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3
        vc?.urlToPlay = url
        AppUtility.lockOrientation(.landscape, andRotateTo: .landscapeLeft)
        self.present(vc!, animated: true, completion: nil)
    }
}
