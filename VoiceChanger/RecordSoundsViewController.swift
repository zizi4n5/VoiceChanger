//
//  RecordSoundsViewController.swift
//  VoiceChanger
//
//  Created by Ahmed El-Kollaly on 9/2/17.
//  Copyright © 2017 Ahmed El-Kollaly. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController,AVAudioRecorderDelegate {
    
    //Properties
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var recordLabel: UILabel!
    @IBOutlet weak var stopButton: UIButton!
    enum PlayingState {case playing,notPlaying}
    
    var audioRecorder :AVAudioRecorder!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureUI(.notPlaying)
    }
    //Mark -Configure UI
    func configureUI(_ playingState:PlayingState){
        switch playingState {
        case .playing:
            recordButton.isEnabled = false
            stopButton.isEnabled = true
            recordLabel.text = "Recording ..."
        case .notPlaying:
            recordButton.isEnabled = true
            stopButton.isEnabled = false
            recordLabel.text = "Tap to record"
        }
    }
    //Mark -Start Recording
    @IBAction func startRecording(_ sender: Any) {
        configureUI(.playing)
        
        
        //Create the file URL of the recored audio
        let sysPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        let recordingFileName = "recording.wave"
        let pathArray :[String] = [sysPath,recordingFileName]
        let fileURL = URL(string: pathArray.joined(separator: "/"))
        
        //Get the shared audio session
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord, with: .defaultToSpeaker)
        
        
        //Provides audio recording capability
        try! audioRecorder = AVAudioRecorder(url: fileURL!, settings: [:])
        
        audioRecorder.isMeteringEnabled = true
        audioRecorder.delegate = self
        audioRecorder.prepareToRecord()
        audioRecorder.record()
        
        
        
    }
    //Mark - Stop Recording
    @IBAction func stopRecording(_ sender: Any) {
        configureUI(.playing)
        audioRecorder.stop()
        let session = AVAudioSession.sharedInstance()
        try! session.setActive(false)
    }
    //Mark -After Recording Has Finished
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        
        if flag {
           
            performSegue(withIdentifier: "stop", sender: audioRecorder.url)
            
        }else{
            print("Audio is finished unsccessfully")
        }

    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "stop"{
            
            let playSounds = segue.destination as! PlaySoundsViewController
            let audioFileURL = sender as! URL
            playSounds.audioFileURL = audioFileURL

            
        }
    }
}

