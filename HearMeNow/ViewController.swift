//
//  ViewController.swift
//  HearMeNow
//
//  Created by Edna Dumas on 4/11/19.
//  Copyright © 2019 Edna Dumas. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, AVAudioPlayerDelegate, AVAudioRecorderDelegate {
    var hasRecording = false
    var soundPlayer : AVAudioPlayer!
    var soundRecorder : AVAudioRecorder!
    var session : AVAudioSession?
    var soundPath : String?

    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    
    @IBAction func recordPressed(_ sender: Any) {
        if(soundRecorder?.isRecording == true)
        {
            soundRecorder?.stop()
            recordButton.setTitle("Record", for: UIControl.State.normal)
            hasRecording = true
        } else {
            session?.requestRecordPermission(){
                granted in
                if(granted == true)
                {
                    self.soundRecorder?.record()
                    self.recordButton.setTitle("Stop", for: UIControl.State.normal)
                }
                else {
                    print("Unable to record")
                }
            }
        }
    }
    
    @IBAction func playPressed(_ sender: Any) {
        if(soundPlayer?.isPlaying == true)
        {
            soundPlayer?.pause()
            playButton.setTitle("Play", for: UIControl.State.normal)
        }
        else if (hasRecording == true)
        {
            let url = NSURL(fileURLWithPath: soundPath!)
            
            let error: NSError? = nil
            
            let soundPlayer = try! AVAudioPlayer(contentsOf: url as URL)
            if(error == nil)
            {
                soundPlayer.delegate = self
                soundPlayer.enableRate = true
                soundPlayer.rate = 0.5
                soundPlayer.play()
            }
            else {
                print("Error initializing player \(String(describing: error))")
            }
            playButton.setTitle("Pause", for: UIControl.State.normal)
            hasRecording = false
        }
        else if (soundPlayer != nil)
        {
            soundPlayer?.play()
            playButton.setTitle("Pause", for: UIControl.State.normal)
        }
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool)
    {
        recordButton.setTitle("Record", for: UIControl.State.normal)
    }
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        playButton.setTitle("Play", for: UIControl.State.normal)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = paths[0]
        
        let soundFilename = documentDirectory.appendingPathComponent("hearmenow.wav")
        
        let settings = [AVFormatIDKey : Int(kAudioFormatAppleLossless), AVEncoderAudioQualityKey : AVAudioQuality.max.rawValue, AVEncoderBitRateKey : 320000, AVNumberOfChannelsKey: 2, AVSampleRateKey: 44100.0 ] as [String : Any]
        
        do{
            try soundRecorder = AVAudioRecorder(url:soundFilename, settings: settings)
            soundRecorder.prepareToRecord()
        } catch let error as NSError {
            print("record error:\(error.localizedDescription)")
        }

    }

}

