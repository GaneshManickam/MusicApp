//
//  ViewController.swift
//  MusicApp
//
//  Created by Ganesh Manickam on 5/10/17.
//  Copyright © 2017 mobileappexpert. All rights reserved.
//

import UIKit
import MediaPlayer
import AVFoundation


@available(iOS 10.1, *)
class ViewController: UIViewController,MPMediaPickerControllerDelegate {

    @IBOutlet var titleLbl: UILabel!
    @IBOutlet var backwardButton: UIButton!
    @IBOutlet var forwardButton: UIButton!
    @IBOutlet var playButton: UIButton!
    var mediaPicker: MPMediaPickerController?
    var myMusicPlayer: MPMusicPlayerController?
    var mediaQueue : MPMusicPlayerMediaItemQueueDescriptor?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        playButton.tag = 0
        myMusicPlayer = MPMusicPlayerController()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func mediaPicker(_ mediaPicker: MPMediaPickerController, didPickMediaItems mediaItemCollection: MPMediaItemCollection)
    {
        //User selected a/an item(s).
        for sng in mediaItemCollection.items {
            print("Add \(sng) to a playlist, prep the player, etc.")
        }
       
        if let player = myMusicPlayer{
            player.beginGeneratingPlaybackNotifications()
            player.setQueue(with: mediaItemCollection)
            player.play()
            self.updateNowPlayingItem()
            playButton.tag = 1
           // mediaPicker.dismiss(animated: true, completion: nil)
        }
        
        
    }
    
    func mediaPickerDidCancel(_ mediaPicker: MPMediaPickerController)
    {
     print("Cancel Clicked")
     mediaPicker.dismiss(animated: true, completion: nil)
    }
    func updateNowPlayingItem()
    {
        if let nowPlayingItem=self.myMusicPlayer!.nowPlayingItem{
            let nowPlayingTitle=nowPlayingItem.title
            print("\(nowPlayingTitle)")
           self.titleLbl.text=nowPlayingTitle
        }else{
            print("Nothing Played")
            self.titleLbl.text="Nothing Played"
        }
    }
    func nowPlayingItemIsChanged(notification: NSNotification){
        
        print("Playing Item Is Changed")
        
        let key = "MPMusicPlayerControllerNowPlayingItemPersistentIDKey"
        
        let persistentID =
            notification.userInfo![key] as? NSString
        
        if let id = persistentID{
            print("Persistent ID = \(id)")
        }

    }
    @IBAction func musicPickerClicked(_ sender: Any) {
        self.mediaPicker = MPMediaPickerController(mediaTypes: .anyAudio)
        
        if let picker = self.mediaPicker{
            
            print("Successfully instantiated a media picker")
            picker.delegate = self
            self.view.addSubview(picker.view)
            self.present(picker, animated: true, completion: nil)
            
        } else {
            print("Could not instantiate a media picker")
        }
    }

    
    @IBAction func backwardClicked(_ sender: Any) {
        if let player = myMusicPlayer{
            if playButton.tag == 1 || playButton.tag == 2
            {
                player.skipToPreviousItem()
                updateNowPlayingItem()
            }
        }

    }
    @IBAction func forwardClicked(_ sender: Any) {
        if let player = myMusicPlayer{
            if playButton.tag == 1 || playButton.tag == 2
            {
                player.skipToNextItem()
                updateNowPlayingItem()
            }
        }
    }
    @IBAction func playClicked(_ sender: Any) {
        if let player = myMusicPlayer{
            if playButton.tag == 1
            {
                print("pause")
                player.pause()
                playButton.tag = 2
                self.playButton.setImage(UIImage(named:"pause.png"), for: .normal)
            }
            else if playButton.tag == 2
            {
                print("play")
                player.play()
                playButton.tag = 1
                self.playButton.setImage(UIImage(named:"play-button.png"), for: .normal)
            }
            updateNowPlayingItem()
        }
    }
}

