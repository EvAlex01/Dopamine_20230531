//
//  Jailbreak.swift
//  Fugu15
//
//  Created by exerhythm on 03.04.2023.
//

import UIKit
import Fugu15KernelExploit
import CBindings

var fakeRootPath: String? = nil
public func rootifyPath(path: String) -> String? {
    if fakeRootPath == nil {
        fakeRootPath = Bootstrapper.locateExistingFakeRoot()
    }
    if fakeRootPath == nil {
        return nil
    }
    return fakeRootPath! + "/procursus/" + path
}

func getBootInfoValue(key: String) -> Any? {
    guard let bootInfoPath = rootifyPath(path: "/basebin/boot_info.plist") else {
        return nil
    }
    guard let bootInfo = NSDictionary(contentsOfFile: bootInfoPath) else {
        return nil
    }
    return bootInfo[key]
}

func respring() {
    guard let sbreloadPath = rootifyPath(path: "/usr/bin/sbreload") else {
        return
    }
    _ = execCmd(args: [sbreloadPath])
}

func userspaceReboot() {
    UIImpactFeedbackGenerator(style: .soft).impactOccurred()

    // MARK: Fade out Animation

    let view = UIView(frame: UIScreen.main.bounds)
    view.backgroundColor = .black
    view.alpha = 0

    for window in UIApplication.shared.connectedScenes.map({ $0 as? UIWindowScene }).compactMap({ $0 }).flatMap({ $0.windows.map { $0 } }) {
        window.addSubview(view)
        UIView.animate(withDuration: 0.2, delay: 0, animations: {
            view.alpha = 1
        })
    }

    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
        guard let launchctlPath = rootifyPath(path: "/usr/bin/launchctl") else {
            return
        }
        _ = execCmd(args: [launchctlPath, "reboot", "userspace"])
    })
}

func reboot() {
    _ = execCmd(args: [CommandLine.arguments[0], "reboot"])
}

func doLdrestart() {
    UIImpactFeedbackGenerator(style: .soft).impactOccurred()

    // MARK: Fade out Animation

    let view = UIView(frame: UIScreen.main.bounds)
    view.backgroundColor = .black
    view.alpha = 0

    for window in UIApplication.shared.connectedScenes.map({ $0 as? UIWindowScene }).compactMap({ $0 }).flatMap({ $0.windows.map { $0 } }) {
        window.addSubview(view)
        UIView.animate(withDuration: 0.2, delay: 0, animations: {
            view.alpha = 1
        })
    }

    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
        guard let ldrestartPath = rootifyPath(path: "/usr/bin/ldrestart") else {
            return
        }
        _ = execCmd(args: [ldrestartPath])
    })
}

func doReboot() {
    UIImpactFeedbackGenerator(style: .soft).impactOccurred()

    // MARK: Fade out Animation

    let view = UIView(frame: UIScreen.main.bounds)
    view.backgroundColor = .black
    view.alpha = 0

    for window in UIApplication.shared.connectedScenes.map({ $0 as? UIWindowScene }).compactMap({ $0 }).flatMap({ $0.windows.map { $0 } }) {
        window.addSubview(view)
        UIView.animate(withDuration: 0.2, delay: 0, animations: {
            view.alpha = 1
        })
    }

    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
        guard let rebootPath = rootifyPath(path: "/usr/sbin/reboot") else {
            return
        }
        _ = execCmd(args: [rebootPath])
    })
}

func isJailbroken() -> Bool {
    if isSandboxed() { return false } // ui debugging

    var jbdPid: pid_t = 0
    jbdGetStatus(nil, nil, &jbdPid)
    return jbdPid != 0
}

func isBootstrapped() -> Bool {
    if isSandboxed() { return false } // ui debugging

    return Bootstrapper.isBootstrapped()
}

func jailbreak(completion: @escaping (Error?) -> ()) {
    do {
        var wifiFixupNeeded = false
        var sleepNeeded = false
        if #available(iOS 15.4, *) {
            // No Wifi fixup needed
        }
        else {
            wifiFixupNeeded = wifiIsEnabled()
            sleepNeeded = true
        }

        if wifiFixupNeeded {
            setWifiEnabled(false)
            Logger.log("Disabling Wi-Fi", isStatus: true)
        }

        if sleepNeeded {
            Logger.log("Log_Start_Jailbreaking", isStatus: true)
            sleep(5)
        }

        Logger.log("Launching kexploitd", isStatus: true)

        try Fugu15.launchKernelExploit(oobPCI: Bundle.main.bundleURL.appendingPathComponent("oobPCI")) { msg in
            DispatchQueue.main.async {
                var toPrint: String
                let verbose = !msg.hasPrefix("Status: ")
                if !verbose {
                    toPrint = String(msg.dropFirst("Status: ".count))
                }
                else {
                    toPrint = msg
                }

                Logger.log(toPrint, isStatus: !verbose)
            }
        }

        if #available(iOS 15.4, *) {
            // No Wifi fixup needed
        }
        else {
            setWifiEnabled(true)
            Logger.log("Enabling Wi-Fi", isStatus: true)
        }

        try Fugu15.startEnvironment()

        DispatchQueue.main.async {
            Logger.log(NSLocalizedString("Jailbreak_Done", comment: ""), type: .success, isStatus: true)
            completion(nil)
        }
    } catch {
        DispatchQueue.main.async {
            Logger.log("\(error.localizedDescription)", type: .error, isStatus: true)
            completion(error)
            NSLog("Fugu15 error: \(error)")
        }
    }
}

func removeJailbreak() {
    dopamineDefaults().removeObject(forKey: "selectedPackageManagers")
    _ = execCmd(args: [CommandLine.arguments[0], "uninstall_environment"])
    if isJailbroken() {
        reboot()
    }
}

func jailbrokenUpdateTweakInjectionPreference() {
    _ = execCmd(args: [CommandLine.arguments[0], "update_tweak_injection"])
}

func changeMobilePassword(newPassword: String) {
    guard let dashPath = rootifyPath(path: "/usr/bin/dash") else {
        return;
    }
    guard let pwPath = rootifyPath(path: "/usr/sbin/pw") else {
        return;
    }
    _ = execCmd(args: [dashPath, "-c", String(format: "printf \"%%s\\n\" \"\(newPassword)\" | \(pwPath) usermod 501 -h 0")])
}


func changeEnvironmentVisibility(hidden: Bool) {
    if hidden {
        _ = execCmd(args: [CommandLine.arguments[0], "hide_environment"])
    }
    else {
        _ = execCmd(args: [CommandLine.arguments[0], "unhide_environment"])
    }

    if isJailbroken() {
        jbdSetFakelibVisible(!hidden)
    }
}

func isEnvironmentHidden() -> Bool {
    return !FileManager.default.fileExists(atPath: "/var/jb")
}

func update(tipaURL: URL) {
    // guard let jbctlPath = rootifyPath(path: "/basebin/jbctl") else {
    //     return;
    // }
    // _ = execCmd(args: [jbctlPath, "update", "tipa", tipaURL.path])
    DispatchQueue.global(qos: .userInitiated).async {
        jbdUpdateFromTIPA(tipaURL.path, true)
    }
}

func installedEnvironmentVersion() -> String {
    if isSandboxed() { return "1.0.3" } // ui debugging

    return getBootInfoValue(key: "basebin-version") as? String ?? "1.0"
}

func isInstalledEnvironmentVersionMismatching() -> Bool {
    return installedEnvironmentVersion() != Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
}

func updateEnvironment() {
    jbdUpdateFromBasebinTar(Bundle.main.bundlePath + "/basebin.tar", true)
}

// debugging
func isSandboxed() -> Bool {
    !FileManager.default.isWritableFile(atPath: "/var/mobile/")
}

func bindMount(path: String) {
    if path.count > 0 && !(path.starts(with:"/var/jb/")) {
        _ = execCmd(args: ["/var/jb/basebin/jbctl", "bindmount_path", path])
    }
}

func bindUnmount(path: String) {
    if path.count > 0 && !(path.starts(with:"/var/jb/")) {
        _ = execCmd(args: ["/var/jb/basebin/jbctl", "bindunmount_path", path])
    }
}

func isPathMappingEnabled() -> Bool {
    let dpDefaults = dopamineDefaults()
    let enableMount = dpDefaults.bool(forKey: "pathMappingEnabled")
    let isMappingPlistExists = FileManager.default.fileExists(
        atPath: "/var/mobile/Library/Preferences/page.liam.prefixers.plist")

    return enableMount && isMappingPlistExists;
}
