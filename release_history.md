## 关于本次更新

这本质上是一个自用版本，发布的意思是「分享」。

### 1.0.5 - 20230528_160830

1. 更新上游代码至 `opa334/Dopamine:9113105`。（a. 上游合入了我的一个优化；b. 改进了 PPLRW，这将有助于越狱后的整体性能）
2. 恢复对 `/Dev` 的注入。

### 1.0.5 - 20230522_172935

1. 改进越狱次数统计逻辑，尽可能在更多的场合下将数据持久化至磁盘（闪存）。

### 1.0.5 - 20230522_155303

1. 更新上游代码 `opa334/Dopamine:43fab5f`。
2. 上次由我自行续费的反代带宽已接进耗尽；完全耗尽后，在下一个账单周期前，既往版本将无法在应用内检测更新。因此，请尽快升级到新版本。
3. 从此版本开始，应用内更新将只在检测更新环节使用反代（新的反代），而下载将无法再享受反代加速。请自备魔法上网。

### 1.0.5 - 20230517_105601

1. 更新上游代码 `opa334/Dopamine:9e0dd6e`。上游对 `watchdogd` 增加 hook；对满足特定条件的 kernel panic，由 hook catch 住，避免紫屏重启，转为用户空间重启。

### 1.0.5 - 20230516_165312

1. 在点按注销、重启用户空间、重启等三个按钮时，增加一个确认窗口，防止误触中断当前正在进行的工作。

### 1.0.5 - 20230515_112845

1. 考虑到在越狱状态下移除越狱本身是个悖论，在越狱状态下禁用「移除越狱」按钮。实际上，在越狱状态下执行移除越狱，将会造成不确定的行为。

### 1.0.5 - 20230514_215455

1. 修正上游带来的不符合中文语法和中文语言习惯的奇怪翻译。（对，就是 `70ffcb4` 这个提交……）我已经放弃挣扎了，官方版本的翻译随它去吧，我只能尽力保证我的版本的翻译是正常的。

### 1.0.5 - 20230514_152855

1. 考虑到「软重启」较少使用且功能与「重启用户空间」类似，将其收入重启用户空间按钮的 Haptic Menu 当中。从此往后，若想要执行软重启，请长按「重启用户空间」按钮。

### 1.0.5 - 20230514_145011

1. 更新上游代码 `opa334/Dopamine:a867b65`。
2. 回滚 `1.0.4 - 20230509_104422` 中的第一项修改。原修改解决了一些问题，但也带来了新的问题。权衡利弊，决定回滚。

### 1.0.5 - 20230513_101222

1. 更新上游代码 `opa334/Dopamine:1.0.5`。

### 1.0.4 - 20230512_235540

1. 修复上游的一个 bug。这个 bug 影响部分老机型（例如 XR）和部分系统版本（例如 iOS 15.1）。它会导致 New Term 3 以及 SSH 连接不可用。

### 1.0.4 - 20230511_180533

1. 在默认的软件源列表中添加 `https://liam.page/oldabi/`
2. 使用更加安全的 mount 方式
3. 尝试做一些稳定性修复，这应当能提升越狱后系统运行的稳定性。这很难，但总得有人去做。

### 1.0.4 - 20230509_104422

1. 越狱状态 OTA 升级时，在通过 TrollStore Helper 安装新的 IPA 文件之前先刷新一次，以保证 TrollStore 及其安装的 APP 都处在系统态。
2. 非越狱状态 OTA 升级时，全程反代，而后再拉起 TrollStore 安装。

### 1.0.4 - 20230509_081755

1. 更新上游代码 `opa334/Dopamine:1.0.4`。

### 1.0.3 - 20230508_ 112743

1. 更新上游代码 `opa334/Dopamine:8821fd4`。

### 1.0.3 - 20230507_101433

两个重点说明。

1. 从现在起，在未越狱时也可以更新 App。但它基本的原理是获取更新链接，然后拉起 TrollStore 进行安装。因此，若你的设备上没有 TrollStore，你依然只能从网页上下载 IPA 文件后自行安装。此外，TrollStore 的 URL Scheme 可能失效，导致拉起 TrollStore 失败，转而拉起苹果自带的放大镜。请注意，这不是 Dopamine 的问题，是 TrollStore 的问题。遇到此问题时，请检查 TrollStore 的版本是否高于 1.3。若你的回答是「是的」，请考虑向 TrollStore 本身提交 Issue；或者，依旧只是在越狱状态下做 OTA 更新。另外，机制所限，未越狱时的更新无法享受全程反代的功能。
2. 先前，为加快普通用户的更新速度，我自费为下载过程添加了全程反代。但显然，用户量超出了我的想象，下载更新使用的带宽已接近上限。为此，我紧急扩容了反代服务器的带宽容量，但预期只能坚持一周左右时间。再次扩容花费巨大，我也无意为本意只是「娱乐」的项目投入更多资金，也不想为此募捐。因此，我将在恰当的时候将全程反代关闭。**届时，检查更新本身无需魔法上网，但检查到更新之后需要魔法上网才能享受高速下载更新**。
3. 更新上游代码 `opa334/Dopamine:90b76a2`。

### 1.0.3 - 20230506_235500

1. 更新上游代码 `opa334/Dopamine:1.0.3`。

### 1.0.2 - 20230506_142000

1. 兼容 unject 新旧配置文件位置。不使用该功能的用户可以跳过此版本。

### 1.0.2 - 20230506_111500

1. 更新和改进 unject 相关代码。再次致谢：@真皮。
2. 刚才的更新出现了一点问题，我不小心把还在测试中的代码推到 GitHub 了，导致系统范围内全部注入都被关闭。抱歉。但我发誓，现在你们看到的版本是正常的。

### 1.0.2 - 20230505_200000

1. 听说你们不喜欢我画的图标……好吧，我把原版图标左右镜像了一下，现在你们不许说不好看了。

### 1.0.2 - 20230505_102000

1. 更新上游代码 `opa334/Dopamine:844d06c`。

### 1.0.2 - 20230504_203000

1. 在编译版本前加上官方 tag 版本。
2. 为路径映射增加更多保护逻辑。

### 1.0.2 - 20230504_173000

1. 禁用长按箭头跳转 Youtube 的彩蛋（太傻了……

### 1.0.2 - 20230504_120000

1. 改进路径映射代码逻辑，降低误操作致使系统出错的风险。增加提示语。
2. 新增解除路径映射的功能。

### 1.0.2 - 20230504_072000

1. 更新上游代码 `opa334/Dopamine:1.0.2`。

### 1.0.1 - 20230504_003000

1. 更新上游代码 `opa334/Dopamine:1.0.1`；兼容真皮版本的路径映射配置文件。使用真皮版本越狱的，现在可以无缝切换而无需担心丢失路径映射的配置。

### 1.0 - 20230503_180000

1. 更新上游代码 `opa334/Dopamine:d457ec7`；更好的升级体验。

### 1.0 - 20230503_091500

1. 更新上游代码 `opa334/Dopamine:37f5b83`。

### 20230502_093000

1. 更新上游代码 `opa334/Dopamine:9b4792d`，更新路径映射代码，更新升级流程代码。

### 20230426_080000

1. 用更好的方式将反向代理嵌入 OTA 升级流程。这样，普通用户也能享受到最快的更新下载速度。

### 20230425_183000

1. 修复逻辑 bug，在重建环境时，允许用户选择包管理器的功能。
2. 修复部分机型上因地区选择问题导致汉化文件 fallback 到 zh-Hans 的问题。

### 20230425_092500

1. 更新上游代码 `opa334/Dopamine:90ffc04`。

### 20230424_224717

1. 本次更新基于最新越狱引导环境（`opa334/Dopamine:6c85fdc`）。因此，**首次**安装或更新到此类版本，越狱后将删除已有的越狱引导环境；即是说，对于**首次**安装或更新到此类版本并越狱，**你订阅的源和安装的插件将丢失**，请注意备份。
2. 更新对 plist 配置文件的访问方式，使之符合 Apple 的推荐的最佳实践。
3. 解决配置文件中，路径映射默认值被意外删除的问题。
4. 解决反向代理失效的问题。
5. 改进更多汉化。

## 修改版的主要功能

1. 提供汉化（包括中国大陆、中国香港、中国台湾）。对，汉化作者是我（自豪）。
2. 可与官方版本共存。
3. 支持应用内更新越狱包。
4. 支持目录映射，并支持越狱后新增目录映射（而无需重启越狱；位于越狱后的设置中）。
5. 允许用户在越狱成功后点按「用户空间重启以完成越狱」，而不是自动重启。
6. 额外提供「软重启」、「重启」功能按钮。
7. 提供重建越狱引导环境的功能（位于设置中）。
8. 首页加入编译时间，关于页加入编译版本。

------

## About This Update

This modification is disigned to be used only by me myself.

### 1.0.5 - 20230528_160830

1. update source code from upstream `opa334/Dopamine:9113105`. (a. An optimization was merged into the upstream of my code; b. PPLRW has been improved, which will contribute to overall performance after jailbreaking.)
2. Restore injection for `/Dev`.

### 1.0.5 - 20230522_172935

1. Improve the jailbreak count tracking logic and persist data to disk (flash storage) whenever possible in more scenarios.

### 1.0.5 - 20230517_105601

1. update source code from upstream `opa334/Dopamine:9e0dd6e`. The upstream adds hooks to `watchdogd`; for kernel panics that meet certain conditions, the hook catches them, avoiding the purple screen reboot, and switching to userspace reboot.

### 1.0.5 - 20230516_165312

1. When tapping on the buttons for Restart Springboard, Reboot userspace, and Reboot, add a confirmation window to prevent accidental interruption of the ongoing task.

### 1.0.5 - 20230515_112845

1. Considering that removing the jailbreak while in the jailbroken state is itself a paradox, the "Remove Jailbreak" button is disabled while in the jailbroken state. In fact, performing an unjailbreak while in a jailbroken state will result in undefined behavior.

### 1.0.5 - 20230514_215455

1. Correct the strange translation brought by the upstream that does not conform to Chinese grammar and Chinese language habits. (Yes, it's commit `70ffcb4`...) I've given up struggling, let the translation of the official version go, I can only do my best to ensure that the translation of my version is normal.

### 1.0.5 - 20230514_152855

1. Considering that "ldrestart" is rarely used and its function is similar to "Reboot Userspace", it is included in the Haptic Menu of the Reboot Userspace button. From now on, if you want to perform a ldrestart, press and hold the "Restart Userspace" button.

### 1.0.5 - 20230514_145011

1. update source code from upstream `opa334/Dopamine:a867b65`。
2. revert the first commit from `1.0.4 - 20230509_104422`. The original modification solved some problems, but also introduced new ones. Weighed the pros and cons and decided to roll back.

### 1.0.5 - 20230513_101222

1. update source code from upstream `opa334/Dopamine:1.0.5`.

### 1.0.4 - 20230512_235540

1. Fix an upstream bug that affects some older models (such as XR) and some system versions (such as iOS 15.1). It causes New Term 3 and SSH connections to be unavailable.

### 1.0.4 - 20230511_180533

1. Append `https://liam.page/oldabi/` to the default source list.
2. Apply a more-safe mount method.
3. Try to do some stability fixes, this should improve the stability of the system running after jailbreaking. It's hard, but someone has to do it.

### 1.0.4 - 20230509_104422

1. In Jailbroken state, OTA updating will trigger a refresh of TrollStore Helper just before installing new IPA file. This ensures TrollStore itself and Apps installed by TrollStore are in the System state.
2. In non-Jailbroken state, download with reverse-proxy and then pull-up TrollStore to install.

### 1.0.4 - 20230509_081755

1. update source code from upstream `opa334/Dopamine:1.0.4`.

### 1.0.3 - 20230508_ 112743

1. update source code from upstream `opa334/Dopamine:8821fd4`.

### 1.0.3 - 20230507_101433

Two key points.

1. From now on, it is possible to update the App even when not jailbroken. But it basically works by fetching the update link and then pulling up the TrollStore to install it. Therefore, if you do not have TrollStore on your device, you can still only download the IPA file from the web and install it yourself. In addition, the URL Scheme of TrollStore may be invalid, resulting in failure to pull up TrollStore, and pull up Apple's built-in magnifying glass instead. When encountering this problem, please check if the version of TrollStore is higher than 1.3. If your answer is "yes", please consider submitting an Issue to TrollStore itself. Note that this is not a Dopamine problem, it's a TrollStore problem. In addition, due to the limitation of the mechanism, the update without jailbreak cannot enjoy the full reverse-proxy function.
2. Previously, in order to speed up the update speed for ordinary users, I added a full reverse-proxy for the download process at my own expense. But obviously, the number of users exceeds my imagination, and the bandwidth used to download updates is close to the limit. For this reason, I urgently expanded the bandwidth capacity of the reverse-proxy server, but it is expected to only last for about a week. Scaling again is expensive, and I have no intention of investing more money in a project that is meant to be "entertainment", nor do I want to raise donations for it. Therefore, I'll turn off the full reverse-proxy. **At that time, checking the update itself does not require a ladder, but after checking the update, you need a ladder to enjoy high-speed download updates**.
3. update source code from upstream `opa334/Dopamine:90b76a2`.

### 1.0.3 - 20230506_235500

1. update source code from upstream `opa334/Dopamine:1.0.3`.

### 1.0.2 - 20230506_142000

1. Compatible with unject old and new config file locations. Users who do not use this feature can skip this release.

### 1.0.2 - 20230506_111500

1. update and improve code related to unject. Again, thanks to @真皮.
2. There was a little problem with the update just now, I accidentally pushed the code that was still under test to GitHub, which caused all injections to be disabled system-wide. Feel sorry. But I swear, the version you see now is working fine.

### 1.0.2 - 20230505_200000

1. Heard you guys didn't like the icon I drew... well, I mirrored the original icon left and right, and now you can't say it's ugly.

### 1.0.2 - 20230505_102000

1. update source code from upstream `opa334/Dopamine:844d06c`.

### 1.0.2 - 20230504_203000

1. Add official version before compile version.
2. Add more protection logic for path-mapping.

### 1.0.2 - 20230504_173000

1. Disable long-press to jump to Youtube...

### 1.0.2 - 20230504_120000

1. Improve logic behind path-mapping codes, which should reduce the risk introduced by mis-operation. Add promopt messages.
2. New feture: now, one could remove path-mapping from GUI.

### 1.0.2 - 20230504_072000

1. update source code from upstream `opa334/Dopamine:1.0.2`.

### 1.0.1 - 20230504_003000

1. update source code from upstream `opa334/Dopamine:1.0.1`; compatible with zp's path mapping config file from now.

### 1.0 - 20230503_180000

1. update source code from upstream `opa334/Dopamine:d457ec7`; better UEX for OTA.

### 1.0 - 20230503_091500

1. update source code from upstream `opa334/Dopamine:37f5b83`.

### 20230502_093000

1. update source code from upstream `opa334/Dopamine:9b4792d`; update code for path mapping; update code for upgrading.

### 20230426_080000

1. Embedding the reverse proxy in a better way into the upgrading process. Now, average users will enjoy a better downloading speed.

### 20230425_183000

1. fix a logic bug that while rebuilding environment, allow user to select package manager.
2. fix the issue that on some iPhone model zh_CN failed to load and fallback to zh-Hans.

### 20230425_092500

1. update source code from upstream `opa334/Dopamine:90ffc04`

### 20230424_224717

1. This update is based on the latest Jailbreak Bootstrap Environment (`opa334/Dopamine:6c85fdc`). Hence, on the **VERY FIRST TIME** that you install/upgrade-to this kind of versions, **YOUR ENVIRONMENT WILL BE REMOVED AND REINSTALLED**. That is, **THE SOURCES YOU'VE SUBSCRIBED AND THE TWEAKS YOU'VE INSTALLED WILL LOSE**. Please kindly and carefully back them up.
2. Update the usage of the plist file, which makes code matching the requirement of Apple's best practice.
3. Fix the problem that accidently deleting the default value of `emableMount` in the plist file.
4. Fix the reverse proxy.
5. Improve Translations.

## About this Mod

1. Offers Chinese translation (Mainland China, Hongkong of China, Taiwan of China).
2. Be able to stay with the official version.
3. Offers the ability to OTA update.
4. Support path bind & mount. Also support hot bind & mount (do not need to reboot and re-jailbreak; find it at settings page after jailbroken).
5. Allow users to reboot userspace by tap button, rather than slightly reboot.
6. Offers ldrestart and reboot buttons.
7. In settings, users could enable "rebuild environment".
8. Add compile time on the first page, and add compile version in about page.

------
