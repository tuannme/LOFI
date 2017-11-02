//
//  MicrophoneViewController.swift
//  LOFI
//
//  Created by TuanNM on 10/30/17.
//  Copyright © 2017 Nguyen Manh Tuan. All rights reserved.
//

import UIKit
import Speech

@available(iOS 10.0, *)
class MicrophoneViewController: UIViewController {

    @IBOutlet weak var speedResultLb: UILabel!
    
    var speechRecognizer:SFSpeechRecognizer?
    var recognitionRequest:SFSpeechAudioBufferRecognitionRequest?
    var recognitionTask:SFSpeechRecognitionTask?
    var audioEngine:AVAudioEngine?
    let language = "vi"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SFSpeechRecognizer.requestAuthorization { (authStatus) in
            switch authStatus{
            case .authorized:
                self.speechRecognizer = SFSpeechRecognizer.init(locale: Locale(identifier: self.language))
                self.speechRecognizer?.delegate = self
                print("authorized")
                break
            case .denied:
                print("denied")
                break
            case .notDetermined:
                print("notDetermined")
                break
            case .restricted:
                print("restricted")
                break
            }
        }
    }
    
    func startSpeaking() {
        
        guard let speechRecognizer = speechRecognizer else{return}
        if recognitionTask != nil{
            recognitionTask?.cancel()
            recognitionTask = nil
        }
        
        let audioSession = AVAudioSession.sharedInstance()
        
        do{
            try audioSession.setCategory(AVAudioSessionCategoryRecord)
            try audioSession.setMode(AVAudioSessionModeMeasurement)
            try audioSession.setActive(true, with: .notifyOthersOnDeactivation)
        }catch let error{
            print("audio error \(error)")
        }
        
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        guard let recognitionRequest = recognitionRequest else{return}
        
        recognitionRequest.shouldReportPartialResults = true
        
        audioEngine = AVAudioEngine()
        
        recognitionTask = speechRecognizer.recognitionTask(with: recognitionRequest, resultHandler: { (speedResult, error) in
            
            if let transcription = speedResult?.transcriptions{
                print(transcription.count)
            }
            
            if let bestTranscription = speedResult?.bestTranscription{
                DispatchQueue.main.async {
                    self.speedResultLb.text = bestTranscription.formattedString
                    
                    self.audioEngine?.stop()
                    self.audioEngine = nil
                    self.recognitionRequest = nil
                    self.recognitionTask = nil
                    self.startSpeaking()
                    
                }
            }
            
        })
        
        
        let inputNode = audioEngine?.inputNode
        let recordingFormat = inputNode?.outputFormat(forBus: 0)
        inputNode?.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat, block: { (buffer, time) in
            self.recognitionRequest?.append(buffer)
        })
        
        audioEngine?.prepare()
        
        do{
            try audioEngine?.start()
        }catch let error{
            print("audioEngine start error \(error)")
        }
    }
    
    
    func stopSpeaking(){
        recognitionTask?.cancel()
        recognitionTask = nil
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

@available(iOS 10.0, *)
extension MicrophoneViewController:SFSpeechRecognizerDelegate{
    func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
        
    }
}
