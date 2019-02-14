# Chirp + PayPal

Peer-to-peer payments with anyone nearby using PayPal REST API and Chirp.

See the [blog](https://blog.chirp.io/chirp-paypal) for more details.

![PayPalSend](/Assets/PayPalSend.gif)
![PayPalReceive](/Assets/PayPalReceive.gif)

## Setup

- Sign up at [developers.chirp.io](https://developers.chirp.io)
- Run `pod install` inside the example project folder and open the `.xcworkspace`
- Copy/paste your Chirp application `key`, `secret` and `config` string into the Credentials file

- Log in at PayPal developers page, and create an app
- Copy/Paste the `clientId` and `clientSecret` into Credentials.swift
