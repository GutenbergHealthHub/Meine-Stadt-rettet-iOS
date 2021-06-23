//
//  ERSoundManager.swift
//  EcoRescue
//
//  Created by Christoph Erl on 11.07.16.
//  Copyright © 2016 Christoph Erl. All rights reserved.
//

import UIKit
import AVFoundation

class ERSoundManager: NSObject {

    fileprivate var currentSound: ERSound? { didSet { p_setCurrentSound(oldValue) } }
    
    override init() {
        super.init()
    }
    
    // MARK: - Public Methods
    
    func play(sound: ERSound) {
       self.currentSound = sound
    }
    
    func stop() {
        currentSound = nil
    }
    
    // MARK: - Sounds
    
    static let soundHorn    = ERSound(title: String.HORN, file: "horn")
    static let soundSiren   = ERSound(title: String.SIREN, file: "siren")
    static let soundA1      = ERSound(title: String.ALARM + " 1", file: "alarm_1")
    static let soundA2      = ERSound(title: String.ALARM + " 2", file: "alarm_2")
    static let soundA3      = ERSound(title: String.ALARM + " 3", file: "alarm_3")
    static let soundA4      = ERSound(title: String.ALARM + " 4", file: "alarm_4")
    static let soundA5      = ERSound(title: String.ALARM + " 5", file: "alarm_5")
    static let soundA6      = ERSound(title: String.ALARM + " 6", file: "alarm_6")
    static let soundA7      = ERSound(title: String.ALARM + " 7", file: "alarm_7")
    static let soundA8      = ERSound(title: String.ALARM + " 8", file: "alarm_8")
    
    static let sounds       = [soundHorn, soundSiren, soundA1, soundA2, soundA3, soundA4, soundA5, soundA6, soundA7, soundA8]
    
    class func titleForFilename(_ filename: String) -> String? {
        for sound in sounds {
            if sound.filename == filename { return sound.title }
        }
        return nil
    }
    
    // MARK: - Private Methods
    
    fileprivate func p_setCurrentSound(_ oldValue: ERSound?) {
        oldValue?.stop()
        currentSound?.play()
    }
    
}

class ERSound: NSObject {
    
    let title:  String
    let file:   String
    let type:   String
    
    var filename: String { return file + "." + type }
    
    fileprivate let audioPlayer: AVAudioPlayer
    
    init(title: String, file: String, type: String = "wav") {
        self.title  = title
        self.file   = file
        self.type   = type
        
        audioPlayer = try! AVAudioPlayer(contentsOf: Bundle.main.url(forResource: file, withExtension: type)!)
        
        super.init()
    }
    
    func play() {
        audioPlayer.currentTime = 0
        audioPlayer.play()
    }
    
    func stop() {
        audioPlayer.stop()
    }
    
}
