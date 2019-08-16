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
    
    @IBAction func quitApp(_ sender: NSMenuItem) {
        NSApplication.shared.terminate(self)
    }
    
    
    @IBAction func openAbout(_ sender: NSMenuItem) {
        NSApp.orderFrontStandardAboutPanel(sender)
    }
    
    @IBAction func openWeb(_ sender: NSMenuItem) {
        guard let url = URL(string: "https://www.ichochy.com") else {
            return
        }
        NSWorkspace.init().open(url)
    }
    
    let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    
    override func awakeFromNib(){
        statusItem.menu = statusMenu
        statusItem.image = NSImage(named: "status")
        statusItem.button?.window?.registerForDraggedTypes([NSPasteboard.PasteboardType.fileURL])
        statusItem.button?.window?.delegate = self
        addObserver()
    }
    
    private func addObserver(){
        NotificationCenter.default.addObserver(self, selector: #selector(openPreferencesWindow), name: Notification.Name.init(CustomNotification.name.configIsEmpty.rawValue), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(setStatusTitle), name: Notification.Name.init(CustomNotification.name.progress.rawValue), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(setStatusTitle), name: Notification.Name.init(CustomNotification.name.error.rawValue), object: nil)
         NotificationCenter.default.addObserver(self, selector: #selector(setStatusTitle), name: Notification.Name.init(CustomNotification.name.success.rawValue), object: nil)
    }
    
    
    @objc private func openPreferencesWindow(){
        let controller = NSStoryboard.init(name: "Main", bundle: nil).instantiateController(withIdentifier: "Preferences") as! NSWindowController
        controller.showWindow(self)
    }
    
    @objc private func setStatusTitle(notification:Notification){
        if notification.name.rawValue == CustomNotification.name.progress.rawValue {
            let value = notification.userInfo?["progress"] as! Float
            DispatchQueue.main.async {
                self.statusItem.image = nil
                self.statusItem.title = String.init(format: "%.0f", value*100)+"%"
            }
        }else{
            self.statusItem.title = nil
            self.statusItem.image = NSImage(named: "status")
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
        FileUploadService.share.uploadWithPasteboard(pasteboard: pasteboard)
        return true
    }
    
    func draggingEnded(_ sender: NSDraggingInfo) {
        self.statusItem.image = NSImage(named: "status")
    }
    
    
}
