//
//  GameViewController.swift
//  QuestionBoomFinalize
//
//  Created by Кирилл on 17.09.16.
//  Copyright © 2016 Кирилл. All rights reserved.
//

import SpriteKit
import AVFoundation
import GameKit

class GameViewController: UIViewController, AdProtocol, GKGameCenterControllerDelegate{
    
    
    var backGroundMusicPlayer = AVAudioPlayer()
    
    var backgroundMusic: BackgroundMusic = .menu
    
    var musicOff = true
    
    var soundOff = true
    
    var removeAds = false
    
    func haveSound() -> Bool {
        return !soundOff
    }
    
    func haveMusic() -> Bool {
        return !musicOff
    }
    
    func pausePlayer() {
        if !self.musicOff{
        backGroundMusicPlayer.pause()
        }
    }
    
    func resumePlayer() {
        if !self.musicOff{
        backGroundMusicPlayer.prepareToPlay()
        backGroundMusicPlayer.play()
        }
    }
    
    
    func removeAdverstiments() {
        self.removeAds = true
    }
    
    func initGameCenter() {
        
        // Check if user is already authenticated in game center
        if GKLocalPlayer.localPlayer().isAuthenticated == false {
            
            // Show the Login Prompt for Game Center
            GKLocalPlayer.localPlayer().authenticateHandler = {(viewController, error) -> Void in
                if viewController != nil {
                    self.present(viewController!, animated: true, completion: nil)
                    
                }
            }
        }else{
            print("dont logged in")
        }
        
    }
    
    func showAlert(_ alert: UIAlertController) {
        present(alert, animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let userDefaults = UserDefaults.standard
        
        musicOff = userDefaults.bool(forKey: "musicOff")
        soundOff = userDefaults.bool(forKey: "soundOff")
        removeAds = userDefaults.bool(forKey: "removeAds")

        
        let sizeRect = UIScreen.main.bounds
        let width = sizeRect.size.width * UIScreen.main.scale
        let height = sizeRect.size.height * UIScreen.main.scale
        

        let scene = StartGameScene(size: CGSize(width: width, height: height))

        scene.adDelegate = self

        let skView = self.view as! SKView
        
        /* Sprite Kit applies additional optimizations to improve rendering performance */
        skView.ignoresSiblingOrder = true
        
        /* Set the scale mode to scale to fit the window */
        scene.scaleMode = .aspectFill
        scene.start = true
        skView.presentScene(scene)
        print("hello")
        
    }
    
    
    
    override var shouldAutorotate : Bool {
        return true
    }
    
    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .landscape
        } else {
            return .all
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    override var prefersStatusBarHidden : Bool {
        return true
    }
    

    
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismiss(animated: true, completion: nil)
    }
    
    func arcadeGameCenter(_ score: Int) {
        if GKLocalPlayer.localPlayer().isAuthenticated{
            let scoreReporter = GKScore(leaderboardIdentifier: "ArcadeGameSceneRecord", player: GKLocalPlayer.localPlayer())
            scoreReporter.value = Int64(score)
            GKScore.report([scoreReporter], withCompletionHandler:{ error in
                let gcViewController = GKGameCenterViewController()
                gcViewController.gameCenterDelegate = self
                gcViewController.viewState = GKGameCenterViewControllerState.leaderboards
                gcViewController.leaderboardIdentifier = "ArcadeGameSceneRecord"
                
                // Show leaderboard
                self.present(gcViewController, animated: true, completion: nil)
            })
        }
    }
    
    func singleGameCenter(_ score: Int){
        if GKLocalPlayer.localPlayer().isAuthenticated{
            let scoreReporter = GKScore(leaderboardIdentifier: "SingleGameSceneRecord", player: GKLocalPlayer.localPlayer())
            scoreReporter.value = Int64(score)
            GKScore.report([scoreReporter], withCompletionHandler:{ error in
            let gcViewController = GKGameCenterViewController()
            gcViewController.gameCenterDelegate = self
            gcViewController.viewState = GKGameCenterViewControllerState.leaderboards
            gcViewController.leaderboardIdentifier = "SingleGameSceneRecord"
            
            // Show leaderboard
            self.present(gcViewController, animated: true, completion: nil)
        })
    }
    }
    
    
    
    
}

extension GameViewController{
    
    func turnSound(_ value: Bool) {
        soundOff = !value
    }
    
    func turnMusic(_ value: Bool) {
        if value{
            musicOff = false
            switch backgroundMusic {
            case .game:
                inGameBackgroundMusic()
            case .menu:
                menuBacgroundMusic()
            }
        }else{
            musicOff = true
            backGroundMusicPlayer.stop()
        }
    }
    
    func menuBacgroundMusic() {
        if !musicOff{
            let musicFileUrl = Bundle.main.url(forResource: "Game Menu", withExtension: "mp3")
            
            
            do{
                backGroundMusicPlayer = try AVAudioPlayer(contentsOf: musicFileUrl!)
                backgroundMusic = .menu
                backGroundMusicPlayer.numberOfLoops = -1
                backGroundMusicPlayer.prepareToPlay()
                backGroundMusicPlayer.play()
            }
            catch let error as NSError{
                print(error.localizedDescription)
            }
            
        }
    }
    
    func inGameBackgroundMusic() {
        if self.backgroundMusic == .menu{
            if !musicOff{
                let musicFileUrl = Bundle.main.url(forResource: "Music in game", withExtension: "mp3")
                
                
                do{
                    backGroundMusicPlayer = try AVAudioPlayer(contentsOf: musicFileUrl!)
                    backgroundMusic = .game
                    backGroundMusicPlayer.numberOfLoops = -1
                    backGroundMusicPlayer.prepareToPlay()
                    backGroundMusicPlayer.play()
                }
                catch let error as NSError{
                    print(error.localizedDescription)
                }
                
            }
        }
    }
    
    
}



protocol AdProtocol {
    func initGameCenter()
    func haveSound() -> Bool
    func haveMusic() -> Bool
    func pausePlayer()
    func resumePlayer()
    func turnSound(_ value: Bool)
    func turnMusic(_ value: Bool)
    func menuBacgroundMusic()
    func inGameBackgroundMusic()
    func showAlert(_ alert: UIAlertController)
    func arcadeGameCenter(_ score: Int)
    func singleGameCenter(_ score: Int)
    func removeAdverstiments()
}

enum AdType {
    case rewarded
    case `default`
}

enum BackgroundMusic {
    case menu
    case game
}
