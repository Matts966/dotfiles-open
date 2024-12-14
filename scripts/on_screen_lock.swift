#!/usr/bin/env swift

import Foundation

class ScreenLockObserver {
    init() {
        let dnc = DistributedNotificationCenter.default()

        // listen for screen lock
        let _ = dnc.addObserver(forName: NSNotification.Name("com.apple.screenIsLocked"), object: nil, queue: .main) { _ in
            NSLog("Screen Locked")
            self.disableSleep()
        }

        RunLoop.main.run()
    }

    private func disableSleep() {
        let task = Process()
        task.launchPath = "/bin/bash"
        task.arguments = ["-c", """
            sudo pmset -a disablesleep 1
            (sleep 300; sudo pmset -a disablesleep 0)
        """]
        task.launch()
        task.waitUntilExit()
    }
}

let _ = ScreenLockObserver()
