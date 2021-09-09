//
//  RecordsSoundsViewController.swift
//  PitchPerfect
//
//  Created by C. Jordan Ball III on 9/7/21.
//

import UIKit
import AVFoundation

class RecordsSoundsViewController: UIViewController, AVAudioRecorderDelegate {
    
    var audioRecorder: AVAudioRecorder!
    
    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopRecordingButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stopRecordingButton.isEnabled = false;
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
    }

    @IBAction func recordAudio(_ sender: UIButton) {
        configUI(recording: true);
//        recordingLabel.text = "Recording in Progress";
//        stopRecordingButton.isEnabled = true;
//        recordButton.isEnabled = false;
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String;
        let recordingName = "recordedVoice.wav";
        let pathArray = [dirPath, recordingName];
        let filePath = URL(string: pathArray.joined(separator: "/"));
        print("Recording: filePath: \(filePath!)");
        
        let session = AVAudioSession.sharedInstance();
        try! session.setCategory(AVAudioSession.Category.playAndRecord, options: .defaultToSpeaker);
        
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:]);
        audioRecorder.delegate = self;
        audioRecorder.isMeteringEnabled = true;
        audioRecorder.prepareToRecord();
        audioRecorder.record();

    }
    
    @IBAction func stopRecording(_ sender: UIButton) {
        configUI(recording: false);
//        recordingLabel.text = "Tap to Record";
//        stopRecordingButton.isEnabled = false;
//        recordButton.isEnabled = true;
        audioRecorder.stop();
        let audioSession = AVAudioSession.sharedInstance();
        try! audioSession.setActive(false);
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
        } else {
            print("recording failed");
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "stopRecording" {
            let playSoundsVC = segue.destination as! PlaySoundsViewController;
            let recordedAudioURL = sender as! URL;
            playSoundsVC.recordedAudioURL = recordedAudioURL;
        }
    }
    
    func configUI(recording: Bool) {
        recordButton.isEnabled = recording ? false : true;
        stopRecordingButton.isEnabled = recording ? true : false;
        recordingLabel.text = recording ? "Recording in Progress" : "Tap to Record"
    }
}
