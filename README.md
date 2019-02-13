# Chirp iOS Examples

A selection of example iOS apps using Chirp.

## Setup

For all of the example apps you will need to

- Sign up at [developers.chirp.io](https://developers.chirp.io)
- Run `pod install` inside the example project folder and open the `.xcworkspace`
- Copy/paste your Chirp application `key`, `secret` and `config` string into the Credentials file

----

## Swift

### Chirp Messenger

Chirp Messenger uses your device's speaker and microphone to send and receive messages via audio.

To be compatible with Chirp Messenger on other platforms, e.g., [messenger.chirp.io](https://messenger.chirp.io),
the `16khz-mono` protocol should be used.

![MessengerGIF](/Assets/Messenger.gif)

----

### Chirp + PayPal

Peer-to-peer payments with anyone nearby using PayPal REST API and Chirp.

See the [blog](https://blog.chirp.io/chirp-paypal)

For this tutorial you will also need to

- Log in at PayPal developers page, and create an app
- Copy/Paste the `clientId` and `clientSecret` into AppDelegate.swift

----

## Objective-C

### Chirp + TOTP

Send time based one time only passwords using sound.

See the [blog](https://blog.chirp.io/chirp-totp-generation-and-transmission-6044410526a7)

----
