//
//  StatusMenuController.swift
//  qupload
//
//  Created by MLeo on 2019/3/14.
//  Copyright © 2019年 iChochy. All rights reserved.
//

import Cocoa

class StatusMenuController:NSObject,NSWindowDelegate,NSDraggingDestination {
    
    
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
        setStatusTitle()
        
    }
    

    private func hundleNotification(){
        NotificationCenter.default.addObserver(forName: Notification.Name.init(CustomNotification.name.notification.rawValue), object: nil, queue: nil) { (notification) in
            DispatchQueue.main.async {
                self.openPreferencesWindow()
            }
        }
    }
    
    private func openPreferencesWindow(){
        let window = NSStoryboard.init(name: "Main", bundle: nil).instantiateController(withIdentifier: "Preferences") as! NSWindowController
        window.showWindow(self)
    }
    
    private func setStatusTitle(){
        NotificationCenter.default.addObserver(forName: Notification.Name.init(CustomNotification.name.progress.rawValue), object: nil, queue: nil) { (notification) in
            let value = notification.userInfo?["progress"] as! Float
            DispatchQueue.main.async {
                self.statusItem.image = nil
                guard 1.0 != value else {
                    self.statusItem.title = nil
                    self.statusItem.image = NSImage(named: "status")
                    return
                }
                self.statusItem.title = String.init(format: "%.0f", value*100)+"%"
            }
        }
    }
    
    func draggingEntered(_ sender: NSDraggingInfo) -> NSDragOperation {
        return NSDragOperation.copy
    }
    
    func performDragOperation(_ sender: NSDraggingInfo) -> Bool {
        let pasteboard = sender.draggingPasteboard
        FileUploadService.share.uploadWithPasteboard(pasteboard: pasteboard)
        return true
    }
    
}
