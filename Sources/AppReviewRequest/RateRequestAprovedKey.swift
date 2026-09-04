//
//  File.swift
//  AppReviewRequest
//
//  Created by Kanstantsin Ausianovich on 03/09/2026.
//

import Sharing

public extension SharedReaderKey where Self == AppStorageKey<Bool>.Default {
    static var rateRequestAproved: Self {
        Self[.appStorage("rateRequestAproved"), default: false]
    }
}
