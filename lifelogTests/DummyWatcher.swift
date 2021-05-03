//
//  DummyWatcher.swift
//  lifelogTests
//
//  Created by Shigeru Hagiwara on 2020/10/14.
//  Copyright © 2020 Shigeru Hagiwara. All rights reserved.
//

import Foundation
@testable import lifelog

class DummyWatcher: StatusWatcher {
    func addStatus(_ text: String? = nil) {
        let f = DateFormatter()
        f.setTemplate(.full)
        let now = Date()
        let dateTimeStr = f.string(from: now)
        
        print(dateTimeStr + ": \n" + (text ?? ""))
    }
    func clearExceptLast5Lines() {
        // do nothing
    }
    func setButtonStatus(enable: Bool) {
        // do nothing
    }
}
