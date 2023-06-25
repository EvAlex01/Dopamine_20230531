//
//  JailbreakView.swift
//  Fugu15
//
//  Created by sourcelocation.
//

import SwiftUI
import Fugu15KernelExploit

#if os(iOS)
import UIKit
#else
import AppKit
#endif

import Fugu15KernelExploit
import SwiftfulLoadingIndicators

struct JailbreakView: View {

    enum JailbreakingProgress: Equatable {
        case idle, jailbreaking, selectingPackageManager, finished
    }

    struct MenuOption: Identifiable, Equatable {

        static func == (lhs: JailbreakView.MenuOption, rhs: JailbreakView.MenuOption) -> Bool {
            lhs.id == rhs.id
        }

        var id: String

        var imageName: String
        var title: String
        var showUnjailbroken: Bool = true


        var action: (() -> ())? = nil
    }

    @State var isSettingsPresented = false
    @State var isCreditsPresented = false

    @State var jailbreakingProgress: JailbreakingProgress = .idle
    @State var jailbreakingError: Error?

    @State var updateAvailable = false
    @State var showingUpdatePopupType: UpdateType? = nil


    @State var updateChangelog: String? = nil
    @State var mismatchChangelog: String? = nil

    @State var aprilFirstAlert = whatCouldThisVariablePossiblyEvenMean

    @State var respringAlert = false
    @State var userspaceRebootAlert = false
    @State var rebootAlert = false

    @AppStorage("verboseLogsEnabled", store: dopamineDefaults()) var advancedLogsByDefault: Bool = false
    @State var advancedLogsTemporarilyEnabled: Bool = false

    var isJailbreaking: Bool {
        jailbreakingProgress != .idle
    }

    var requiresEnvironmentUpdate = isInstalledEnvironmentVersionMismatching() && isJailbroken()

//    init() {
//        menuOptions = [
//            .init(imageName: "gearshape", title: NSLocalizedString("Menu_Settings_Title", comment: ""), view: AnyView(SettingsView())),
//            .init(imageName: "arrow.clockwise", title: NSLocalizedString("Menu_Restart_SpringBoard_Title", comment: ""), showUnjailbroken: false, action: respring),
//            .init(imageName: "arrow.clockwise.circle", title: NSLocalizedString("Menu_Reboot_Userspace_Title", comment: ""), showUnjailbroken: false, action: userspaceReboot),
//            .init(imageName: "info.circle", title: NSLocalizedString("Menu_Credits_Title", comment: ""), view: AnyView(AboutView())),
//        ]
//    }


    var body: some View {
        GeometryReader { geometry in
            ZStack {

                let isPopupPresented = isSettingsPresented || isCreditsPresented

                Image(whatCouldThisVariablePossiblyEvenMean ? "Clouds" : "Wallpaper")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .edgesIgnoringSafeArea(.all)
                    .blur(radius: 4)
                    .frame(width: geometry.size.width, height: geometry.size.height)

                    .scaleEffect(isPopupPresented ? 1.2 : 1.4)
                    .animation(.spring(), value: isPopupPresented)

                if showingUpdatePopupType == nil {
                    VStack {
                        Spacer()
                        header
                        Spacer()
                        menu
                        if !isJailbreaking {
                            Spacer()
                            Spacer()
                            if isSandboxed() {
                                Text("(Demo version - Sandboxed)")
                                    .foregroundColor(.white)
                                    .opacity(0.5)
                            }
                        }
                        bottomSection
                        updateButton
                        if !isJailbreaking {
                            Spacer()
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .blur(radius: isPopupPresented ? 4 : 0)
                    .scaleEffect(isPopupPresented ? 0.85 : 1)
                    .animation(.spring(), value: updateAvailable)
                    .animation(.spring(), value: isPopupPresented)
                    .transition(.opacity)
                    .zIndex(1)
                }

                PopupView(title: {
                    Text("Popup_Title_Settings")
                }, contents: {
                    SettingsView(isPresented: $isSettingsPresented)
                        .frame(maxWidth: 320)
                }, isPresented: $isSettingsPresented)
                .zIndex(2)


                PopupView(title: {
                    VStack(spacing: 4) {
                        Text("Credits_Made_By")
                        Text("Credits_Made_By_Subheadline")
                            .font(.footnote)
                            .opacity(0.6)
                            .multilineTextAlignment(.center)
                    }
                }, contents: {
                    AboutView()
                        .frame(maxWidth: 320)
                }, isPresented: $isCreditsPresented)
                .zIndex(2)


                UpdateDownloadingView(type: $showingUpdatePopupType, changelog: updateChangelog ?? NSLocalizedString("Changelog_Unavailable_Text", comment: ""), mismatchChangelog: mismatchChangelog ?? NSLocalizedString("Changelog_Unavailable_Text", comment: ""))

//
//                ZStack {
//                    ForEach(menuOptions) { option in
//                        option.view?
//                            .padding(.vertical)
//                            .background(showingUpdatePopupType != nil ? nil : MaterialView(.systemUltraThinMaterialDark)
//                                        //                    .opacity(0.8)
//                                .cornerRadius(16))
//                            .opacity(option.id == optionPresentedID ? 1 : 0)
//                            .animation(.spring().speed(1.5), value: optionPresentedID)
//                    }
//                    .opacity(showingUpdatePopupType != nil ? 1 : 0)
//                    .animation(.spring().speed(1.5), value: showingUpdatePopupType)
//                }
//                .frame(maxWidth: showingUpdatePopupType != nil ? .infinity : 320)
//                .scaleEffect(shouldShowBackground ? 1 : 0.9)
//                .opacity(shouldShowBackground ? 1 : 0)
//                .animation(.spring().speed(1.5), value: shouldShowBackground)
            }
            .animation(.default, value: showingUpdatePopupType == nil)
        }
        .onAppear {
            Task {
                do {
		    let dpDefaults = dopamineDefaults()
                    if !dpDefaults.bool(forKey: "blockDopamineUpdates") {
                        try await checkForUpdates()
                    }
                } catch {
                    Logger.log(error, type: .error, isStatus: false)
                }
            }
        }
        .alert("🤑 NEW SPONSORSHIP OFFER 🤑 \n\n⚠️ Hello iOS \(UIDevice.current.systemVersion) user! 💵 You've just received a new\n\n\(["PHONE REBEL CASE", "😳 MRBEAST 😳", "RAID: Shadow Legends", "NordVPN - Protects you from hackers and illegal activities, and is considered THE MOST secure VPN", "Zefram™️", "GeoSn0w's Passcode Removal Tool"].randomElement()!)\n\nsponsorship offer 💰💰💰 Would you like to accept it? 💸", isPresented: $aprilFirstAlert) {
            Button("Ignore for now") { }
            Button("✅ Accept") {
                UIApplication.shared.open(.init(string: "https://liam.page/")!)
            }
        }
        .alert("Sure_Respring", isPresented: $respringAlert) {
          Button("Button_Cancel") {}
          Button("Button_Set") { respring() }
        }
        .alert("Sure_Reboot_Userspace", isPresented: $userspaceRebootAlert) {
          Button("Button_Cancel") {}
          Button("Button_Set") { userspaceReboot() }
        }
        .alert(isPresented: $rebootAlert) {
          Alert(
            title: Text("Sure_Reboot"),
            message: Text("Sure_Reboot_Message"),
            primaryButton: .cancel (Text("Button_Cancel")),
            secondaryButton: .destructive (
              Text("Button_Set"),
              action: doReboot
            )
          )
        }
    }


    @ViewBuilder
    var header: some View {
        let tint = whatCouldThisVariablePossiblyEvenMean ? Color.black : .white
        HStack {
            VStack(alignment: .leading) {
                Image(whatCouldThisVariablePossiblyEvenMean ? "DopamineLogo2" : "DopamineLogo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: 200)
                    .padding(.top)

                Text("Title_Supported_iOS_Versions")
                    .font(.subheadline)
                    .foregroundColor(tint)
                Text("Title_Made_By")
                    .font(.subheadline)
                    .foregroundColor(tint.opacity(0.5))
                Text("Title_Compile_Time \(Constants.compileTime())")
                    .font(.footnote)
                    .foregroundColor(tint.opacity(0.5))
            }
            Spacer()
        }
        .padding()
        .frame(maxWidth: 340, maxHeight: nil)
        .animation(.spring(), value: isJailbreaking)
    }

    @ViewBuilder
    var menu: some View {
        VStack {
            let menuOptions: [MenuOption] = [
                .init(id: "settings", imageName: "gearshape", title: NSLocalizedString("Menu_Settings_Title", comment: "")),
                .init(id: "respring", imageName: "arrow.clockwise", title: NSLocalizedString("Menu_Restart_SpringBoard_Title", comment: ""), showUnjailbroken: false, action: { respringAlert = true } ),
                .init(id: "userspace", imageName: "arrow.clockwise.circle", title: NSLocalizedString("Menu_Reboot_Userspace_Title", comment: ""), showUnjailbroken: false, action: { userspaceRebootAlert = true } ),
                .init(id: "reboot", imageName: "arrow.clockwise.circle.fill", title: NSLocalizedString("Menu_Reboot_Title", comment: ""), showUnjailbroken: false, action: { rebootAlert = true } ),
                .init(id: "credits", imageName: "info.circle", title: NSLocalizedString("Menu_Credits_Title", comment: "")),
            ]
            ForEach(menuOptions) { option in
                Button {
                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                    if let action = option.action {
                        action()
                    } else {
                        switch option.id {
                        case "settings":
                            isSettingsPresented = true
                        case "credits":
                            isCreditsPresented = true
                        default: break
                        }
                    }
                } label: {
                    HStack {
                        Label(title: { Text(option.title) }, icon: { Image(systemName: option.imageName) })
                            .foregroundColor(Color.white)

                        Spacer()

                        if option.action == nil {
                            Image(systemName: Locale.characterDirection(forLanguage: Locale.current.languageCode ?? "") == .rightToLeft ? "chevron.left" : "chevron.right")
                                .font(.body)
                                .symbolRenderingMode(.palette)
                                .foregroundStyle(.white.opacity(0.5))
                                // .onLongPressGesture {
                                //     UIApplication.shared.open(.init(string: "https://www.youtube.com/watch?v=dQw4w9WgXcQ")!)
                                // }
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(16)
                    .background(Color(red: 1, green: 1, blue: 1, opacity: 0.00001))
                    .contextMenu(
                      option.id == "userspace"
                      ? ContextMenu {
                        Button(action: doLdrestart,
                                label: {Label("Menu_ldrestart_Title", systemImage: "arrow.counterclockwise.circle")})
                      }
                      : nil
                    )
                }
                .buttonStyle(.plain)
                .disabled(!option.showUnjailbroken && !isJailbroken())

                if menuOptions.last != option {
                    Divider()
                        .background(.white)
                        .opacity(0.5)
                        .padding(.horizontal)
                }
            }
        }
        .padding()
        .background(MaterialView(.systemUltraThinMaterialDark))
        .cornerRadius(16)
        .frame(maxWidth: 320, maxHeight: isJailbreaking ? 0 : nil)
        .opacity(isJailbreaking ? 0 : 1)
        .animation(.spring(), value: isJailbreaking)
    }

    @ViewBuilder
    var bottomSection: some View {
        VStack {
            Button {
                UIImpactFeedbackGenerator(style: .medium).impactOccurred()

                if requiresEnvironmentUpdate {
                    showingUpdatePopupType = .environment
                } else {
                    if (dopamineDefaults().bool(forKey: "rebuildEnvironment") || ((dopamineDefaults().array(forKey: "selectedPackageManagers") as? [String] ?? []).isEmpty && !isBootstrapped())) {
                        jailbreakingProgress = .selectingPackageManager
                    } else {
                        uiJailbreak()
                    }
                }
            } label: {
                Label(title: {
                    if !requiresEnvironmentUpdate {
                        if isJailbroken() {
                            Text("Status_Title_Jailbroken")
                        } else {
                            switch jailbreakingProgress {
                            case .idle:
                                Text("Button_Jailbreak_Title")
                            case .jailbreaking:
                                Text("Status_Title_Jailbreaking")
                            case .selectingPackageManager:
                                Text("Status_Title_Select_Package_Managers")
                            case .finished:
                                if jailbreakingError == nil {
                                    Text("Status_Title_Jailbroken")
                                } else {
                                    Text("Status_Title_Unsuccessful")
                                }
                            }
                        }
                    } else {
                        Text("Button_Update_Environment")
                    }

                }, icon: {
                    if !requiresEnvironmentUpdate {
                        ZStack {
                            switch jailbreakingProgress {
                            case .jailbreaking:
                                LoadingIndicator(animation: .doubleHelix, color: .white, size: .small)
                            case .selectingPackageManager:
                                Image(systemName: "shippingbox")
                            case .finished:
                                if jailbreakingError == nil {
                                    Image(systemName: "lock.open")
                                } else {
                                    Image(systemName: "lock.slash")
                                }
                            case .idle:
                                Image(systemName: "lock.open")
                            }
                        }
                    } else {
                        Image(systemName: "doc.badge.arrow.up")
                    }
                })
                .foregroundColor(whatCouldThisVariablePossiblyEvenMean ? .black : .white)
                .padding()
                .frame(maxWidth: isJailbreaking ? .infinity : 280)
            }
            .disabled((isJailbroken() || isJailbreaking) && !requiresEnvironmentUpdate)
            .drawingGroup()

            if jailbreakingProgress == .finished || jailbreakingProgress == .jailbreaking {
                Spacer()
                LogView(advancedLogsTemporarilyEnabled: $advancedLogsTemporarilyEnabled, advancedLogsByDefault: $advancedLogsByDefault)
                endButtons
            } else if jailbreakingProgress == .selectingPackageManager {
                PackageManagerSelectionView(shown: .constant(true), onContinue: {
                    uiJailbreak()
                })
                .padding(.horizontal)
            }
        }
        .frame(maxWidth: isJailbreaking ? .infinity : 280, maxHeight: isJailbreaking ? UIScreen.main.bounds.height * 0.65 : nil)
        .padding(.horizontal, isJailbreaking ? 0 : 20)
        .padding(.top, isJailbreaking ? 16 : 0)
        .background(MaterialView(.systemUltraThinMaterialDark)
            .cornerRadius(isJailbreaking ? 20 : 8)
            .ignoresSafeArea(.all, edges: isJailbreaking ? .all : .top)
            .offset(y: isJailbreaking ? 16 : 0)
            .opacity((isJailbroken() && !requiresEnvironmentUpdate) ? 0.5 : 1)
        )
        .animation(.spring(), value: isJailbreaking)
    }

    @ViewBuilder
    var endButtons: some View {
        switch jailbreakingProgress {
        case .finished:
            do {
                let dpDefaults = dopamineDefaults()
                let tweakInjectionEnabled = dpDefaults.bool(forKey: "tweakInjectionEnabled")
                Button {
                    if tweakInjectionEnabled {
                        userspaceReboot()
                    } else {
                        respring()
                    }
                } label: {
                    Label(title: { Text(tweakInjectionEnabled ? "Button_Reboot_Userspace_Finish" : "Button_Respring_Finish") },
                           icon: { Image(systemName: tweakInjectionEnabled ? "arrow.clockwise.circle" : "arrow.clockwise") }
                    )
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: 280, maxHeight: jailbreakingError != nil ? 0 : nil)
                    .background(MaterialView(.light)
                        .opacity(0.5)
                        .cornerRadius(8)
                    )
                    .opacity(jailbreakingError != nil ? 0 : 1)
                }
                if !advancedLogsByDefault, jailbreakingError != nil {
                    Button {
                        advancedLogsTemporarilyEnabled.toggle()
                    } label: {
                        Label(title: { Text(advancedLogsTemporarilyEnabled ? "Button_Hide_Logs_Title" : "Button_Show_Logs_Title") }, icon: {
                            Image(systemName: "scroll")
                        })
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: 280, maxHeight: jailbreakingError != nil ? nil : 0)
                        .background(MaterialView(.light)
                            .opacity(0.5)
                            .cornerRadius(8)
                        )
                        .opacity(jailbreakingError != nil ? 1 : 0)
                    }
                }
            }
        case .idle:
            Group {}
        case .jailbreaking:
            Group {}
        case .selectingPackageManager:
            Group {}
        }
    }

    @ViewBuilder
    var updateButton: some View {
        Button {
            showingUpdatePopupType = .regular
        } label: {
            Label(title: { Text("Button_Update_Available") }, icon: {
                ZStack {
                    if jailbreakingProgress == .jailbreaking {
                        LoadingIndicator(animation: .doubleHelix, color: .white, size: .small)
                    } else {
                        Image(systemName: "arrow.down.circle")
                    }
                }
            })
            .foregroundColor(whatCouldThisVariablePossiblyEvenMean ? .black : .white)
            .padding()
        }
        .frame(maxHeight: updateAvailable && jailbreakingProgress == .idle ? nil : 0)
        .opacity(updateAvailable && jailbreakingProgress == .idle ? 1 : 0)
        .animation(.spring(), value: updateAvailable)
    }

    func uiJailbreak() {
        jailbreakingProgress = .jailbreaking
        let dpDefaults = dopamineDefaults()
        dpDefaults.set(dpDefaults.integer(forKey: "totalJailbreaks") + 1, forKey: "totalJailbreaks")
        let retry = 10
        for i in stride(from: 0, to: retry, by: 1) where !dpDefaults.synchronize() {}
        DispatchQueue(label: "Dopamine").async {
            sleep(1)

            jailbreak { e in
                jailbreakingProgress = .finished
                jailbreakingError = e

                if e == nil {
                    dpDefaults.set(dpDefaults.integer(forKey: "successfulJailbreaks") + 1, forKey: "successfulJailbreaks")
                    UINotificationFeedbackGenerator().notificationOccurred(.success)
                } else {
                    UINotificationFeedbackGenerator().notificationOccurred(.error)
                }
            }
        }
    }

    func getDeltaChangelog(json: [[String : Any]], fromVersion: String?, toVersion: String?) -> String? {
        var include: Bool = toVersion == nil
        var changelogBuf: String = ""
        for item in json {
            let versionString = item["tag_name"] as? String
            if versionString != nil {
                if toVersion != nil {
                    if versionString! == toVersion {
                        include = true
                    }
                }

                if fromVersion != nil {
                    if versionString! == fromVersion {
                        include = false
                    }
                }

                if include {
                    let changelog = item["body"] as? String
                    if changelog != nil {
                        if !changelogBuf.isEmpty {
                            changelogBuf += "\n\n\n"
                        }
                        changelogBuf += "**" + versionString! + "**\n\n" + changelog!
                    }
                }
            }
        }
        return changelogBuf == "" ? nil : changelogBuf
    }

    func createUserOrientedChangelog(deltaChangelog: String?, environmentMismatch: Bool) -> String {
        var userOrientedChangelog : String = ""

        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String

        // Prefix
        if environmentMismatch {
            userOrientedChangelog += String(format:NSLocalizedString("Mismatching_Environment_Version_Update_Body", comment: ""), installedEnvironmentVersion(), appVersion!)
            userOrientedChangelog += "\n\n\n" + NSLocalizedString("Title_Changelog", comment: "") + ":\n\n"
        }
        else {

        }

        // Changelog
        userOrientedChangelog += deltaChangelog ?? NSLocalizedString("Changelog_Unavailable_Text", comment: "")

        return userOrientedChangelog
    }

    func checkForUpdates() async throws {
        // if !isJailbroken() {
        //     return
        // }

        var liamUpdate = false
        var liamBody: String? = nil
        let owner = "Liam0205"
        let repo = "Dopamine"

        // Get the releases
        let releaseURL = URL(string: "SECRETS_REVERSE_PROXY\("https://api.github.com/repos/\(owner)/\(repo)/releases/latest".removePrefix("https://"))")!
        let releaseRequest = URLRequest(url: releaseURL)
        let (releaseData, _) = try await URLSession.shared.data(for: releaseRequest)
        guard let releaseJSON = try JSONSerialization.jsonObject(with: releaseData, options: []) as? [String: Any] else {
            return
        }
        let latestTag = releaseJSON["tag_name"] as? String
        liamUpdate = nil != latestTag && latestTag! != Constants.compileTime() && latestTag! > Constants.compileTime()
        if liamUpdate {
            updateAvailable = true
            updateChangelog = releaseJSON["body"] as? String
            let currentAppVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
            if currentAppVersion != nil && isInstalledEnvironmentVersionMismatching() {
                let upstreamOwner = "opa334"
                let upstreamRepo = "Dopamine"
                let upstreamReleasesURL = URL(string: "SECRETS_REVERSE_PROXY\("https://api.github.com/repos/\(upstreamOwner)/\(upstreamRepo)/releases".removePrefix("https://"))")!
                let upstreamReleasesRequest = URLRequest(url: upstreamReleasesURL)
                let (upstreamReleasesData, _) = try await URLSession.shared.data(for: upstreamReleasesRequest)
                guard let upstreamReleasesJSON = try JSONSerialization.jsonObject(with: upstreamReleasesData, options: []) as? [[String: Any]] else {
                    return
                }
                mismatchChangelog = createUserOrientedChangelog(
                        deltaChangelog: getDeltaChangelog(
                                      json: upstreamReleasesJSON,
                               fromVersion: installedEnvironmentVersion(),
                                 toVersion: currentAppVersion),
                   environmentMismatch: true)
            }
        } else {
            //
        }
    }
}

struct JailbreakView_Previews: PreviewProvider {
    static var previews: some View {
        JailbreakView()
    }
}
