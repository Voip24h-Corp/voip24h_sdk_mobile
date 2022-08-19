package voip24h.sdk.mobile.voip24h_sdk_mobile.utils

enum class SipEvent(val value: String) {
    AccountRegistrationStateChanged("AccountRegistrationStateChanged"),
    Ring("Ring"),
    Up("Up"),
    Paused("Paused"),
    Resuming("Resuming"),
    Missed("Missed"),
    Hangup("Hangup"),
    Error("Error"),
    Released("Released")
}

val EventAccountRegistrationStateChanged = SipEvent.AccountRegistrationStateChanged.value
val EventRing = SipEvent.Ring.value
val EventUp = SipEvent.Up.value
val EventPaused = SipEvent.Paused.value
val EventResuming = SipEvent.Resuming.value
val EventMissed = SipEvent.Missed.value
val EventHangup = SipEvent.Hangup.value
val EventError = SipEvent.Error.value
val EventReleased = SipEvent.Released.value