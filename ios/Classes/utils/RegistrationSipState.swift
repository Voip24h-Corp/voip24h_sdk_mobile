//
//  RegistrationSipState.swift
//  voip24h_sdk_mobile
//
//  Created by Phát Nguyễn on 15/08/2022.
//

import Foundation

enum RegisterSipState : String, CaseIterable {
    /// Initial state for registrations.
    case None = "None"
    /// Registration is in progress.
    case Progress = "Progress"
    /// Registration is successful.
    case Ok = "Ok"
    /// Unregistration succeeded.
    case Cleared = "Cleared"
    /// Registration failed.
    case Failed = "Failed"
}
