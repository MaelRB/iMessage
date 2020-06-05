//
//  LogState.swift
//  iMessage
//
//  Created by Mael Romanin Bluteau on 04/06/2020.
//  Copyright © 2020 Mael Romanin Bluteau. All rights reserved.
//

import Foundation

enum LogState {
    case successed
    case presenting([Discussion])
    case failed(String)
}
