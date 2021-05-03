//
//  StatusLabelSettable.swift
//  save-health-data
//
//  Created by Shigeru Hagiwara on 2020/09/15.
//  Copyright © 2020 Shigeru Hagiwara. All rights reserved.
//

import Foundation

public protocol StatusWatcher {
    func addStatus(_ text: String?)
    func clearExceptLast5Lines()
    func setButtonStatus(enable: Bool)
}
