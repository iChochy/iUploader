//
//  CustomView.swift
//  iUpload
//
//  Created by MLeo on 2019/3/29.
//  Copyright © 2019年 iChochy. All rights reserved.
//

import Cocoa

class CustomView: NSView {
    
    init() {
        super.init(frame: NSRect.init())
        addProgress()
    }
    
    required init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        // Drawing code here.
    }
    
    
    private func addProgress(){
        let progress = NSProgressIndicator.init()
        progress.style = NSProgressIndicator.Style.spinning
        progress.startAnimation(nil)
        self.layer?.backgroundColor = NSColor.red.cgColor
        self.addSubview(progress)
        progress.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.widthAnchor.constraint(equalToConstant: 100),
            self.heightAnchor.constraint(equalToConstant: 100),
            progress.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            progress.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            progress.widthAnchor.constraint(equalToConstant: 40),
            progress.heightAnchor.constraint(equalToConstant: 40)
            ])
    }
    
}
