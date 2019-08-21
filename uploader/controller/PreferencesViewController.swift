//
//  Preferences.swift
//  qupload
//
//  Created by MLeo on 2019/3/13.
//  Copyright © 2019年 iChochy. All rights reserved.
//

import Cocoa

class PreferencesViewController: NSViewController {

    @IBOutlet weak var accessKeyText: NSTextField!
    @IBOutlet weak var secretKeyText: NSTextField!
    @IBOutlet weak var bucketText: NSTextField!
    @IBOutlet weak var domainText: NSTextField!
    @IBOutlet weak var compressButton: NSButton!
    @IBOutlet weak var rateSlider: NSSlider!
    @IBOutlet weak var rateValue: NSTextFieldCell!
    
    
    @IBAction func compressButtonAction(_ sender: NSButton) {
        if sender.state == NSControl.StateValue.off {
            rateSlider.isEnabled = false
        }else{
            rateSlider.isEnabled = true
        }
    }
    
    
    @IBAction func cancelButton(_ sender: NSButton) {
        closeWindow()
    }
    
    func closeWindow(){
        guard let window = self.view.window else {
            return
        }
        window.close()
    }
    
    
    @IBAction func saveButton(_ sender: NSButton) {
        let accessKey = accessKeyText.stringValue
        let secretKey = secretKeyText.stringValue
        let bucket = bucketText.stringValue
        let domain = domainText.stringValue
        let rate:Double = rateSlider.doubleValue
        let compress:Int = compressButton.state.rawValue
        let config = QNConfig.init(accessKey: accessKey, secretKey: secretKey, bucket: bucket, domain: domain,rate:rate,compress:compress)
        BaseConfig.share.setConfig(config: config)
        closeWindow()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        rateSlider.target = self
        rateSlider.action = #selector(sliderAction)
        
        let value = BaseConfig.share.getDefaultConfig()
        guard let config = value else {
            return
        }
        
        accessKeyText.stringValue = config.accessKey
        secretKeyText.stringValue = config.secretKey
        bucketText.stringValue = config.bucket
        domainText.stringValue = config.domain.absoluteString
        compressButton.state = NSControl.StateValue.init(config.compress)
        rateSlider.doubleValue = config.rate
        setSliderValue(config.rate)
        if compressButton.state == NSControl.StateValue.on {
            rateSlider.isEnabled = true
        }
    }
    
    
    @objc private func sliderAction(_ sender:NSSlider){
        setSliderValue(sender.doubleValue)
        sender.toolTip = "wwwww"
    }
    private func setSliderValue(_ value:Double){
        let value:Int = Int(value*100)
        rateValue.title = "\(value)%"
    }
    
}
