//
//  AppDelegate.swift
//  GYI
//
//  Created by Spencer Curtis on 12/15/16.
//  Copyright © 2016 Spencer Curtis. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
    let popover = NSPopover()
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        
        guard let button = statusItem.button else { return }
        button.image = NSImage(named: NSImage.Name(rawValue: "StatusBarButtonImage"))
        button.action = #selector(togglePopover)
        
        let storyboard = NSStoryboard(name: NSStoryboard.Name(rawValue: "Main"), bundle: nil)
        
        guard let menuPopoverViewController = storyboard.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier(rawValue: "MenuPopoverViewController")) as? MenuPopoverViewController else { return }
        
        popover.behavior = .semitransient
        popover.contentViewController = menuPopoverViewController
        
        DownloadController.shared.popover = self.popover
        
        NotificationCenter.default.addObserver(self, selector: #selector(closePopover(sender:)), name: closePopoverNotification, object: nil)
        togglePopover(sender: self)
        
        
        guard UserDefaults.standard.bool(forKey: DownloadController.shared.autoUpdateYoutubeDLKey) == true else { return }
        DownloadController.shared.updateYoutubeDLExecutable()
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    @objc func togglePopover(sender: Any?) {
        popover.isShown == true ? closePopover(sender: sender) : showPopover(sender: sender)        
    }
    
    func showPopover(sender: Any?) {
        guard let button = statusItem.button else { return }
        popover.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
    }
    
    @objc func closePopover(sender: Any?) {
        popover.performClose(sender)
    }
}

let closePopoverNotification = Notification.Name("closePopover")
