//
//  StatusMenuController.swift
//  qupload
//
//  Created by MLeo on 2019/3/14.
//  Copyright © 2019年 iChochy. All rights reserved.
//

import Cocoa

class StatusMenuController:NSWindow,NSWindowDelegate,NSDraggingDestination {
    
    
    @IBOutlet weak var statusMenu: NSMenu!
    
    @IBOutlet weak var historyRecordItem: NSMenuItem!
    
    let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    
    var progress = NSProgressIndicator.init()
    
    override func awakeFromNib(){
        addStatusBar()
        addProgress()
        addObserver()
    }
    
    
    
    @IBAction func openWeb(_ sender: NSMenuItem) {
        guard let url = URL(string: "https://www.ichochy.com") else {
            return
        }
        NSWorkspace.init().open(url)
    }
    
    @IBAction func pasteboardMonitorSwitch(_ sender: NSMenuItem){
        if sender.state.rawValue == 0 {
            PasteboardMonitor.share.open()
            sender.state = NSControl.StateValue(rawValue: 1)
        }else{
            PasteboardMonitor.share.close()
            sender.state = NSControl.StateValue(rawValue: 0)
        }
    }
    
    
    private func addStatusBar(){
        statusItem.menu = statusMenu
        let button = statusItem.button!
        button.image = NSImage(named: "status")
        button.window?.registerForDraggedTypes([NSPasteboard.PasteboardType.fileURL])
        button.window?.delegate = self
        let size = button.frame.size
        NSLayoutConstraint.activate([
            button.widthAnchor.constraint(equalToConstant: size.width),
            button.heightAnchor.constraint(equalToConstant: size.height)
            ])
    }
    
    private func addProgress(){
        let button = statusItem.button!
        progress.style = NSProgressIndicator.Style.spinning
        progress.controlSize = .small
        progress.minValue = 0
        progress.maxValue = 1
        progress.isHidden = true
        button.addSubview(progress)
        progress.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            progress.centerXAnchor.constraint(equalTo: button.centerXAnchor),
            progress.centerYAnchor.constraint(equalTo: button.centerYAnchor)
            ])
    }
    
    private func addHistoryRecordItem(){
        let filehistory = FileStorageService.share.getHistory()
        guard let files = filehistory else {
            return
        }
        let menu = NSMenu.init();
        files.forEach { (file) in
            let item = NSMenuItem ()
            item.toolTip = file.fileName
            item.target = self
            item.title = ""
            if (itemImage(file.fileData) != nil){
                item.image = itemImage(file.fileData)
            }else{
                item.title = file.fileName
            }
            item.action = #selector(copyFileURL)
            menu.addItem(item)
        }
        historyRecordItem.submenu = menu
        historyRecordItem.isEnabled = true
        historyRecordItem.isHidden = false
    }
    
    private func itemImage(_ data:Data) -> NSImage?{
        let file = NSImage.init(data: data)
        guard let image = file else {
            return nil
        }
        let size = image.size
        let deafault:CGFloat = 80
        if size.width > size.height{
            image.size = NSSize.init(width: deafault, height: size.height*deafault/size.width)
        }else{
            image.size = NSSize.init(width: size.width*deafault/size.height, height: deafault)
        }
        return image
    }
    
    
    
    private func addObserver(){
        NotificationCenter.default.addObserver(self, selector: #selector(uploadStatus), name: Notification.Name.init(CustomNotification.name.progress.rawValue), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(uploadStatus), name: Notification.Name.init(CustomNotification.name.error.rawValue), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(uploadStatus), name: Notification.Name.init(CustomNotification.name.success.rawValue), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(beginStatus), name: Notification.Name.init(CustomNotification.name.begin.rawValue), object: nil)
    }
    
    @objc private func copyFileURL(_ sender:NSMenuItem){
        PasteboardUtil.setPasteboard(sender.toolTip!)
    }
    
    @objc private func beginStatus(){
        DispatchQueue.main.async {
            self.statusItem.button?.image = nil
            self.progress.isIndeterminate = true
            self.progress.isHidden = false
            self.progress.startAnimation(nil)
        }
    }
    
    @objc private func uploadStatus(notification:Notification){
        if notification.name.rawValue == CustomNotification.name.progress.rawValue {
            let value = notification.userInfo?["progress"] as! Float
            DispatchQueue.main.async {
                self.progress.isIndeterminate = false
                self.progress.doubleValue  = Double(value)
            }
        }else{
            DispatchQueue.main.async {
                self.progress.stopAnimation(nil)
                self.statusItem.button?.image = NSImage(named: "status")
            }
            addHistoryRecordItem()
        }
    }
    
    func draggingEntered(_ sender: NSDraggingInfo) -> NSDragOperation {
        if FileUploadService.share.availableFile(pasteboard: sender.draggingPasteboard){
            return NSDragOperation.copy
        }
        self.statusItem.image = NSImage(named: "status_invalid")
        return NSDragOperation.generic
    }
    
    
    func prepareForDragOperation(_ sender: NSDraggingInfo) -> Bool {
        return FileUploadService.share.availableFile(pasteboard: sender.draggingPasteboard)
    }
    
    func performDragOperation(_ sender: NSDraggingInfo) -> Bool {
        let pasteboard = sender.draggingPasteboard
        FileUploadService.share.asyncUploadWithPasteboard(pasteboard: pasteboard)
        return true
    }
    
    func draggingEnded(_ sender: NSDraggingInfo) {
        if self.statusItem.button?.image != nil{
            self.statusItem.button?.image = NSImage(named: "status")
        }

    }
    
    
}
