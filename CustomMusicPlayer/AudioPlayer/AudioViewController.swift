//
//  AudioViewController.swift
//  CustomMusicPlayer
//
//  Created by Nitin Bhatia on 3/17/21.
//

import UIKit
import AVFoundation

protocol AudioDisplayProtocol: class {
    func showLoader(show: Bool)
    func goBack()
}

let AUDIO_DELETE_BUTTON_CONTENT_EDGE_IPAD : CGFloat = 6.2

class AudioViewController: UIViewController, AudioDisplayProtocol {
    
    //outlets
    @IBOutlet var captureButtonContainer: UIView!
    @IBOutlet var capturedImageContainer: UIView!
    @IBOutlet var gradientView: GradientView!
    @IBOutlet var closeButton: UIButton!
    @IBOutlet var deleteButton: CustomButton!
    @IBOutlet var bottomBarBottomConstraint: NSLayoutConstraint!
    @IBOutlet var brandImageBottomConstraint: NSLayoutConstraint!
    @IBOutlet var controlContainerHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var videoTitleLabel: UILabel!
    @IBOutlet weak var brandImage: UIImageView!
    @IBOutlet weak var videoPlayerView: UIView!
    @IBOutlet weak var currentTime: UILabel!
    @IBOutlet weak var endTime: UILabel!
    @IBOutlet weak var videoSlider: CustomSlider!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var controlsContainerView: RoundedView!
    @IBOutlet weak var bottomBarView: RoundedView!
    @IBOutlet weak var playPauseButton: UIButton!
    @IBOutlet weak var likeButton: CustomButton!
    @IBOutlet weak var inspectButton: CustomButton!
    @IBOutlet weak var videoLoadingImageView: UIImageView!
    @IBOutlet weak var gestureHandlingView: UIView!
    @IBOutlet weak var bottomBarHeightConstraint: NSLayoutConstraint!
    @IBOutlet var errorContainer: UIView!
    @IBOutlet var nextButton: CustomButton!
    @IBOutlet var previousButton: CustomButton!
    
    @IBOutlet var musicSampleImage: UIImageView!
    //variables
    var router: (AudioRouterProtocol & AudioDataPassing)?
    var interactor: AudioIntertactorProtocol?
    var isDataLoaded = false
    var didVideoCompleted = false
    var isSeeking = false
    var adjustmentValue: Float = 0
    var oldVideoControlHeightConstraintConstant : CGFloat = 0
    var oldBottomBarHeightConstraintConstant : CGFloat = 0
    var oldBrandImageBottomConstraintConstant : CGFloat = 0
    var timer : Timer!
    var isFirstTime : Bool = true
    var urlToPlay : URL!
    
    // MARK: Object lifecycle
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup() {
        let viewController = self
        let interactor = AudioInteractor()
        let presenter = AudioPresenter()
        let router = AudioRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //setting up other view related, like giving tap gesture to view to toggle video controls, setting up like button accordingly, also it send mark played event to server, also toggling brand icon
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handlePlayerViewTap))
        tapGesture.numberOfTapsRequired = 1
        gestureHandlingView.addGestureRecognizer(tapGesture)
        let sliderTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(sliderTapped(gestureRecognizer:)))
        self.videoSlider.addGestureRecognizer(sliderTapGestureRecognizer)
        
        let videoLoadingTGR = UITapGestureRecognizer(target: self, action: #selector(videoLoadingImageTapped))
        self.videoLoadingImageView.addGestureRecognizer(videoLoadingTGR)
        self.containerView.isHidden = false
        brandImage.isHidden = true
        
       
        
        let videoSliderHeightToBe = (controlContainerHeightConstraint.constant * 18) / 100
        videoSlider.frame.size.height = videoSliderHeightToBe
        oldBrandImageBottomConstraintConstant = brandImageBottomConstraint.constant
        
        if urlToPlay.absoluteString.contains("mp4") || urlToPlay.absoluteString.contains("m3u8") {
            musicSampleImage.isHidden = true
            gradientView.isHidden = true
        } else {
            captureButtonContainer.isHidden = true
        }
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        captureButtonContainer.beizerRound(corners:[.bottomRight , .topRight])
    }
    
    //MARK: view did appear, here we are controlling the brand icon which to show as per the url or content provider. If video is locally recorded and running from my gallery then no brand icon and title should be displayed
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.showLoader(show: false)
        
        if !isDataLoaded {
            isDataLoaded = !isDataLoaded
            interactor?.loadVideoPlayer(parent: videoPlayerView, viewController: self, urlToPlay: self.urlToPlay)
        }
        
        oldBottomBarHeightConstraintConstant = bottomBarHeightConstraint.constant
        oldVideoControlHeightConstraintConstant = controlsContainerView.frame.height
        
        
        videoTitleLabel.text = "Sample Audio/ Video"
        
        
        if videoTitleLabel.text == "" {
            videoTitleLabel.text = "No Title"
            videoTitleLabel.isHidden = true
        }
    }
    
    //MARK: handle timer to toggle the video controls and bottom bar
    func resetTimer(){
        
        if isSeeking {
            return
        }
        
        if ( timer != nil ) {
            timer.invalidate()
        }
        
        if ( !self.playPauseButton.isSelected || self.inspectButton.isSelected == true ) {
            return
        }
        
        timer = Timer.scheduledTimer(withTimeInterval: 0.11, repeats: false, block: {_ in
            self.animateControls(hide: true)
        })
    }
    
    //MARK: toggle video controls
    @objc func handlePlayerViewTap() {
        animateControls(hide: false)
    }
    
    //MARK: slider tapped and seek video to the time as per where slider tapped by user
    @objc func sliderTapped(gestureRecognizer: UIGestureRecognizer) {
        animateControls(hide: false)
        isSeeking = true
        interactor?.pauseVideo()
        let pointTapped: CGPoint = gestureRecognizer.location(in: self.view)
        let positionOfSlider: CGPoint = videoSlider.frame.origin
        let widthOfSlider: CGFloat = videoSlider.frame.size.width
        let newValue = ((pointTapped.x - positionOfSlider.x) * CGFloat(videoSlider.maximumValue) / widthOfSlider)
        videoSlider.setValue(Float(newValue), animated: true)
        interactor?.seek(time: Double(newValue))
        interactor?.playVideo()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
            self.isSeeking = false
            self.resetTimer()
        })
    }
    
    //MARK: tries to play video
    @objc func videoLoadingImageTapped() {
        interactor?.playVideo()
    }
    
    //MARK: toggle loader
    func showLoader(show: Bool) {
        DispatchQueue.main.async {
            if show {
                //self.view.startLoading()
            } else {
                //self.view.stopLoading()
            }
        }
    }
    
   
    
    //MARK: close the video and go back to parent view
    @IBAction func closeVideoAction(_ sender: UIButton) {
        //        youtubePlayerView?.stopVideo()
        interactor?.videoPlayer?.closeVideo()
        goBack()
    }
    
    //MARK: moves to parent view
    func goBack(){
        AppUtility.lockOrientation(.all, andRotateTo: .portrait)
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK: video control action
    @IBAction func videoControlAction(_ sender: UIButton) {
        isSeeking = true
        if sender.tag == 3 {
            sender.isSelected = !sender.isSelected
            if didVideoCompleted {
                interactor?.replayVideo()
            } else {
                interactor?.toggleVideo()
            }
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.25) {
                
                self.playPauseButton.isSelected = sender.isSelected
                
                self.resetTimer()
            }
            
        } else if sender.tag == 2 {
            interactor?.moveWith(time: -5)
        } else if sender.tag == 4 {
            interactor?.moveWith(time: 5)
        }
        isSeeking = false
    }
    
    //MARK: handles video slider action
    @IBAction func videoSliderAction(_ sender: CustomSlider,event: UIEvent) {
        
        if let touchEvent = event.allTouches?.first {
            switch touchEvent.phase {
            case .began:
                isSeeking = true
                interactor?.pauseVideo()
                
                if timer != nil {
                    self.timer.invalidate()
                }
                animateControls(hide: false)
                break
            case .moved:
                // handle drag moved
                interactor?.seek(time: Double(sender.value))
            case .ended:
                // handle drag ended
                isSeeking = false
                self.resetTimer()
                interactor?.playVideo()
            default:
                break
            }
        }
    }
    
    //MARK: toggle video control and bottom view
    private func hideShowVideoViews() {
        UIView.animate(withDuration: 0.3) {
            self.controlsContainerView.isHidden = !self.controlsContainerView.isHidden
            self.bottomBarView.isHidden = !self.bottomBarView.isHidden
        }
    }
    
    //MARK: close captured image container
    @IBAction func closeCapturedImageContainerButtonAction(_ sender: Any) {
        interactor?.playVideo()
        capturedImageContainer.isHidden = true
        captureButtonContainer.isHidden = false
    }
    
    //MAKR: takes video's screenshot
    @IBAction func takeScreenShot(_ sender: Any) {
        interactor?.pauseVideo()
        capturedImageContainer.isHidden = false
        let capturedImage = interactor?.videoPlayer?.takeScreenshot()
        (capturedImageContainer.subviews.first as? UIImageView)?.image = capturedImage
        captureButtonContainer.isHidden = true
    }
}

//MARK: video player event delegate
extension AudioViewController: VideoEventDelegate {
    
    func videoPlayerDidPause(isVideoPause: Bool) {
        // self.resetTimer()
        self.playPauseButton.isSelected = !isVideoPause
    }
    
    func videoPlayerDidReady(duration: Float64 ) {
        self.containerView.isHidden = false
        self.endTime.text =  Int(floor(duration)).stringFromSeconds()
        //debugPrint("Duration Test: \(Float(duration) / Float(100) * 2)")
        // adjustmentValue = Float(duration) / Float(100) * 2
        self.videoSlider.maximumValue = Float(Int(duration)) //+ adjustmentValue
        
    }
    
    func videoPlayerDidUpdatePlaying(isVideoLoading: Bool) {
        playPauseButton.isSelected = true
        
        if isVideoLoading {
            self.videoLoadingImageView.isHidden = false
            playPauseButton.isHidden = true
            interactor?.playVideo()
        } else {
            self.videoLoadingImageView.isHidden = true
            playPauseButton.isHidden = false
        }
    }
    
    func videoPlayerDidUpdateTime(currentTime: Int) {
        self.didVideoCompleted = false
        
        if playPauseButton.isHidden || !videoLoadingImageView.isHidden {
            playPauseButton.isHidden = false
            videoLoadingImageView.isHidden = true
        }
        self.videoSlider.value = Float(currentTime)
        
        if videoSlider.value <= 0 {
            //disabling previous button and enabling next button, video is just started
            previousButton.isEnabled = false
            nextButton.isEnabled = true
        } else if videoSlider.value > 0 && videoSlider.value <  (self.videoSlider.maximumValue - adjustmentValue) {
            //enabling both previous button and next button, during video is playing
            previousButton.isEnabled = true
            nextButton.isEnabled = true
        } else {
            //disabling next button and enabling previous button, video reaches to end and finished playing
            nextButton.isEnabled = false
        }
        
        self.currentTime.text = Int(videoSlider.value).stringFromSeconds() //Int(currentTime).stringFromSeconds()
        
        if ( playPauseButton.isSelected  ) {
            
            if ( isFirstTime ) {
                DispatchQueue.main.asyncAfter(deadline: .now()+2, execute: {
                    self.resetTimer()
                })
                self.isFirstTime = false
            }
            
        }
        
        if self.videoSlider.value >= (self.videoSlider.maximumValue - adjustmentValue) && self.videoSlider.value > 0 {
            self.didVideoCompleted = true
            playPauseButton.isSelected = false
        }
    }
    
    //MARK: animates the control
    func animateControls(hide:Bool){
        
        if ( hide ) {
            self.controlContainerHeightConstraint.constant = 0
            self.bottomBarHeightConstraint.constant = 0
            self.brandImageBottomConstraint.constant = -(oldVideoControlHeightConstraintConstant)
            UIView.animate(withDuration: 0.20, delay: 0.1, options: .curveEaseInOut, animations: {
                self.controlsContainerView.alpha = 0.0
                self.bottomBarView.alpha = 0.0
                self.viewDidLayoutSubviews()
            }, completion: nil)
        } else {
            
            if timer != nil {
                timer.invalidate()
            }
            self.controlContainerHeightConstraint.constant = 0
            self.bottomBarHeightConstraint.constant = oldBottomBarHeightConstraintConstant
            self.brandImageBottomConstraint.constant = oldBrandImageBottomConstraintConstant
            UIView.animate(withDuration: 0.10, animations: {
                self.controlsContainerView.alpha = 1.0
                self.bottomBarView.alpha = 1.0
                self.viewDidLayoutSubviews()
            },completion: {_ in
                DispatchQueue.main.asyncAfter(deadline: .now()+3, execute: {
                    self.resetTimer()
                })
            })
        }
    }
    
    //MARK: video can not be played due to either reason, in this case we are showing error message
    func cantPlayVideoPresentError() {
        showLoader(show: false)
        
        if timer != nil {
            self.timer.invalidate()
        }
        self.errorContainer.isHidden = false
        self.animateControls(hide: true)
    }
    
}


extension UIView {
    func beizerRound(corners:UIRectCorner,size:CGSize=CGSize(width: 100, height: 100)){
        let rectShape = CAShapeLayer()
        rectShape.bounds = self.frame
        rectShape.position = self.center
        rectShape.path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: size).cgPath
        self.layer.mask = rectShape
    }
}
