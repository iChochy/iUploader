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
    
    var acceptsFirstResponder：Bool = true
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSApp.activate(ignoringOtherApps: true)
        
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
//        guard let fileURL = self.fileURL  else {
//            return
//        }
//        FileUploadService.share.uploadWithURL(fileURL: fileURL)
        
        
        let panel = NSPanel.init()
        let view = NSView.init()
        let text = NSTextField.init(string: "222222")
        let progress = NSProgressIndicator.init()
        view.addSubview(text)
        view.addSubview(progress)
        panel.contentView = view
        self.view.window?.beginSheet(panel, completionHandler: { (response) in
            print("222")
        })
        self.view.window?.endSheet(panel)
//        NSPanel.init().beginSheet(self.view.window!) { (response) in
//            print("222")
//        }
    }
    

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

