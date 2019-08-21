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
    
    let progress = NSProgressIndicator.init()
    
    override func awakeFromNib(){
        statusItem.menu = statusMenu
        statusItem.image = NSImage(named: "status")
        statusItem.button?.window?.registerForDraggedTypes([NSPasteboard.PasteboardType.fileURL])
        statusItem.button?.window?.delegate = self
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
    
    
    private func addProgress(){
        statusItem.button?.addSubview(progress)
        progress.style = NSProgressIndicator.Style.spinning
        progress.isHidden = true
        progress.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            progress.centerXAnchor.constraint(equalTo: (statusItem.button?.centerXAnchor)!),
            progress.bottomAnchor.constraint(equalTo: ((statusItem.button?.bottomAnchor)!)),
            progress.widthAnchor.constraint(equalToConstant: 10),
            progress.heightAnchor.constraint(equalToConstant: 10)
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
        NotificationCenter.default.addObserver(self, selector: #selector(setStatusTitle), name: Notification.Name.init(CustomNotification.name.progress.rawValue), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(setStatusTitle), name: Notification.Name.init(CustomNotification.name.error.rawValue), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(setStatusTitle), name: Notification.Name.init(CustomNotification.name.success.rawValue), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(setStatus), name: Notification.Name.init(CustomNotification.name.begin.rawValue), object: nil)
    }
    
    @objc private func copyFileURL(_ sender:NSMenuItem){
        PasteboardUtil.setPasteboard(sender.toolTip!)
    }
    
    @objc private func setStatus(){
        DispatchQueue.main.async {
            self.progress.isHidden = false
            self.progress.startAnimation(nil)
        }
    }
    
    @objc private func setStatusTitle(notification:Notification){
        if notification.name.rawValue == CustomNotification.name.progress.rawValue {
            let value = notification.userInfo?["progress"] as! Float
            DispatchQueue.main.async {
                self.statusItem.title = String.init(format: "%.0f", value*100)+"%"
            }
        }else{
            self.statusItem.title = nil
            self.progress.isHidden = true
            self.progress.stopAnimation(nil)
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
        self.statusItem.image = NSImage(named: "status")
    }
    
    
}
