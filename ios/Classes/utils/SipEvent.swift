//
//  SipEvent.swift
//  voip24h_sdk_mobile
//
//  Created by Phát Nguyễn on 15/08/2022.
//

import Foundation

enum SipEvent : String {
    /// Status registration of sip account
    case AccountRegistrationStateChanged = "AccountRegistrationStateChanged"
    /// Status ring when has action call in, call out
    case Ring = "Ring"
    /// Status up when accept calling
    case Up = "Up"
    /// Status pause calling
    case Paused = "Paused"
    /// Status resume calling
    case Resuming = "Resuming"
    /// Status call missed
    case Missed = "Missed"
    /// Status hangup calling
    case Hangup = "Hangup"
    /// Status call error
    case Error = "Error"
    /// Status call release
    case Released = "Released"
}


let EventAccountRegistrationStateChanged = SipEvent.AccountRegistrationStateChanged.rawValue
let EventRing = SipEvent.Ring.rawValue
let EventUp = SipEvent.Up.rawValue
let EventPaused = SipEvent.Paused.rawValue
let EventResuming = SipEvent.Resuming.rawValue
let EventMissed = SipEvent.Missed.rawValue
let EventHangup = SipEvent.Hangup.rawValue
let EventError = SipEvent.Error.rawValue
let EventReleased = SipEvent.Released.rawValue
