//
//  ViewController.swift
//  qupload
//
//  Created by MLeo on 2019/3/7.
//  Copyright © 2019年 iChochy. All rights reserved.
//

import Cocoa
import Quartz

class UploadViewController: NSViewController {
    
    @IBOutlet weak var imagesView: NSImageView!
    
    var fileURL:URL!
    
    var panel:NSPanel!
    
    var acceptsFirstResponder：Bool = true
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSApp.activate(ignoringOtherApps: true)
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(endUpload), name: NSNotification.Name.init(CustomNotification.name.success.rawValue), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(endUpload), name: NSNotification.Name.init(CustomNotification.name.error.rawValue), object: nil)
        
    }
    
    @objc private func endUpload(notification:Notification){
        self.closePanel()
    }
    
    @IBAction func addAction(_ sender: Any) {
        let openPanel = NSOpenPanel.init()
        openPanel.allowedFileTypes = ["jpg","png","gif"]
        openPanel.beginSheetModal(for: self.view.window!) { (result) in
            if (result == NSApplication.ModalResponse.OK){
                self.fileURL = openPanel.url!
                self.imagesView.image = NSImage.init(contentsOf: self.fileURL)
            }
        }
    }
    
    
    @IBAction func updateAction(_ sender: Any) {
        guard let fileURL = self.fileURL  else {
            createAlert()
            return
        }
        FileUploadService.share.uploadWithURL(fileURL: fileURL)
        createPanel()
    }
    
    
    
    private func createAlert(){
        let alert:NSAlert = NSAlert.init()
        alert.messageText = "提示"
        alert.informativeText = "请选择要上传的图片"
        alert.beginSheetModal(for: self.view.window!) { (response) in
            
        }
    }
    
    private func createPanel(){
        panel = NSPanel.init()
        panel.contentView = CustomView.init()
        self.view.window?.beginSheet(panel, completionHandler: { (response) in
            
        })
        
    }
    private func closePanel(){
        guard let panel = panel else {
            return
        }
        self.view.window?.endSheet(panel)
    }
    
    
    
    override func viewWillDisappear() {
        NotificationCenter.default.removeObserver(self)
    }
    
    override var representedObject: Any? {
        didSet {
            // Update the view, if already loaded.
        }
    }
    
    
}

