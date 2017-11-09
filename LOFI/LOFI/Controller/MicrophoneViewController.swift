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
    @IBOutlet weak var circleView: UIView!
    
    var speechRecognizer:SFSpeechRecognizer?
    var recognitionRequest:SFSpeechAudioBufferRecognitionRequest?
    var recognitionTask:SFSpeechRecognitionTask?
    var audioEngine:AVAudioEngine?
    let language = "vi"
    
    var timer:Timer?
    var lastTime:Date?
    
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
        
        timer?.invalidate()
        timer = nil
        lastTime = nil
        
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.checkSpeakTimeout), userInfo: nil, repeats: true)
        
        self.speedResultLb.text = ""
        self.playanimation()
        
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
            /*
            var results = ""
            guard let transcriptions = speedResult?.transcriptions else{return}
            for result in transcriptions{
                results =  results + result.formattedString
            }
            DispatchQueue.main.async {
                self.speedResultLb.text = results
            }
           */
            
            if let bestTranscription = speedResult?.bestTranscription{
                DispatchQueue.main.async {
                    self.lastTime = Date()
                    self.speedResultLb.text = bestTranscription.formattedString
                    self.circleView.layer.removeAllAnimations()
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
    
    @objc func checkSpeakTimeout() {
        let now = Date()
        if let lastTime = lastTime{
            if now.timeIntervalSince(lastTime) > 2 {
                recognitionTask?.cancel()
                recognitionTask = nil
                
                if let message = speedResultLb.text{
                    let convert = message.folding(options: .diacriticInsensitive, locale: Locale(identifier: "en"))
                    BluetoothService.shareInstance.sendMessage(message: convert)
                }
                self.startSpeaking()
            }
        }
    }
    

    func stopSpeaking(){
        timer?.invalidate()
        timer = nil
        recognitionTask?.cancel()
        recognitionTask = nil
        circleView.layer.removeAllAnimations()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func playanimation(){
        
        circleView.clipsToBounds = true
        circleView.layer.borderColor = UIColor.orange.cgColor
        circleView.layer.borderWidth = 3.0
        circleView.layer.cornerRadius = circleView.frame.width/2
        
        let color = CABasicAnimation(keyPath: "borderColor")
        color.fromValue = UIColor.white.cgColor
        color.toValue = UIColor.white.withAlphaComponent(0).cgColor
        
        let shrink = CABasicAnimation(keyPath: "transform.scale")
        shrink.toValue = NSNumber(value: 2)
        
        let width = CABasicAnimation(keyPath: "borderWidth")
        width.fromValue = 3
        width.toValue = 0
        
        let theGroup = CAAnimationGroup()
        theGroup.animations = [color,shrink,width]
        theGroup.duration   = 1.5;
        theGroup.repeatCount = HUGE
        theGroup.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionDefault)
        
        circleView.layer.add(theGroup, forKey: "theGroup")
    }
    
}

@available(iOS 10.0, *)
extension MicrophoneViewController:SFSpeechRecognizerDelegate{
    func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
        
    }
}
