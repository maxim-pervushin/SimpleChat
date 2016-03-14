//
// Created by Maxim Pervushin on 05/03/16.
// Copyright (c) 2016 Maxim Pervushin. All rights reserved.
//

import Foundation

struct ServerConfiguration {

    let name: String
    let backendURL: NSURL

    init(name: String, backendURL: NSURL) {
        self.name = name
        self.backendURL = backendURL
    }
}

extension ServerConfiguration: Hashable {

    var hashValue: Int {
        return name.hashValue ^ backendURL.hashValue
    }
}

func ==(lhs: ServerConfiguration, rhs: ServerConfiguration) -> Bool {
    return lhs.name == rhs.name && lhs.backendURL == rhs.backendURL
}
