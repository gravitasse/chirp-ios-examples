/*------------------------------------------------------------------------------
 *
 *  ViewController.swift
 *
 *  For full information on usage and licensing, see https://chirp.io/
 *
 *  Copyright © 2011-2018, Asio Ltd.
 *  All rights reserved.
 *
 *----------------------------------------------------------------------------*/

import UIKit
import AVFoundation


class ViewController: UIViewController, UITextViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Add padding to textViews
        self.inputText.textContainerInset = UIEdgeInsets(top: 15, left: 10, bottom: 15, right: 10)
        self.receivedText.textContainerInset = UIEdgeInsets(top: 15, left: 10, bottom: 15, right: 10)

        // Set up some colours for buttons
        self.sendButton.setTitleColor(UIColor.white, for: .disabled)
        let chirpGrey: UIColor = UIColor(red: 84.0 / 255.0, green: 84.0 / 255.0, blue: 84.0 / 255.0, alpha: 1.0)
        let chirpBlue: UIColor = UIColor(red: 43.0 / 255.0, green: 74.0 / 255.0, blue: 201.0 / 255.0, alpha: 1.0)

        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        if let sdk = appDelegate.sdk {

            sdk.sendingBlock = {
                (data : Data?) -> () in
                self.sendButton.isEnabled = false
                self.sendButton.setTitle("SENDING", for: .normal)
                self.sendButton.backgroundColor = chirpGrey
                return;
            }

            sdk.sentBlock = {
                (data : Data?) -> () in
                self.sendButton.isEnabled = true
                self.sendButton.setTitle("SEND", for: .normal)
                self.sendButton.backgroundColor = chirpBlue
                return;
            }

            sdk.receivingBlock = {
                (channel: UInt?) -> () in
                self.sendButton.isEnabled = false
                self.sendButton.setTitle("RECEIVING", for: .normal)
                self.sendButton.backgroundColor = chirpGrey
                self.receivedText.text = "...."
                return;
            }

            sdk.receivedBlock = {
                (data : Data?, channel: UInt?) -> () in
                self.sendButton.isEnabled = true
                self.sendButton.setTitle("SEND", for: .normal)
                self.sendButton.backgroundColor = chirpBlue
                if let data = data {
                    if let payload = String(data: data, encoding: .utf8) {
                        self.receivedText.text = payload
                        print(String(format: "Received: %@", payload))
                    } else {
                        print("Failed to decode payload!")
                    }
                } else {
                    print("Decode failed!")
                }
                return;
            }
        }
    }

    /*
     * Convert inputText to NSData and send to the speakers.
     * Check volume is turned up enough before doing so.
     */
    func sendInput() {
        if AVAudioSession.sharedInstance().outputVolume < 0.1 {
            let errmsg = "Please turn the volume up to send messages"
            let alert = UIAlertController(title: "Alert", message: errmsg, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            if let sdk = appDelegate.sdk {
                let data = self.inputText.text.data(using: .utf8)
                if let data = data {
                    sdk.send(data)
                }
            }
        }
    }

    @IBAction func send(_ sender: Any) {
        self.sendInput()
    }

    /*
     * Clear the inputText on click.
     */
    func textViewDidBeginEditing(_ textView: UITextView) {
        self.inputText.text = ""
    }

    /*
     * Check the length of the data does not exceed
     * the max payload length.
     * Catch any return keys in the inputText view,
     * then close the keyboard and send the data.
     */
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            self.sendInput()
            return false
        }
        let data = self.inputText.text.data(using: .utf8)
        if let data = data {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            if let sdk = appDelegate.sdk {
                if data.count >= sdk.maxPayloadLength, text != "" {
                    return false
                }
            }
        }
        return true
    }

    @IBOutlet var sendButton: UIButton!
    @IBOutlet var inputText: UITextView!
    @IBOutlet var receivedText: UITextView!
}

