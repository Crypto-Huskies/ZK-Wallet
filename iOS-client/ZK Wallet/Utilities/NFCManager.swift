//
//  NFCManager.swift
//  ZK Wallet
//
//  Created by Mahith ‎ on 02/25/24.
//

import Foundation

import CoreNFC

class NFCReader: NSObject, ObservableObject, NFCNDEFReaderSessionDelegate {
    var theactualData = ""
    var nfcSession: NFCNDEFReaderSession?

    func scan(theactualdata: String) {
        theactualData = theactualdata
        nfcSession = NFCNDEFReaderSession(delegate: self, queue: nil, invalidateAfterFirstRead: true)
        nfcSession?.alertMessage = "Hold Your iPhone Near an NFC Card"
        nfcSession?.begin()
    }

    func readerSession(_ session: NFCNDEFReaderSession, didInvalidateWithError error: Error) {
    }

    func readerSession(_ session: NFCNDEFReaderSession, didDetectNDEFs messages: [NFCNDEFMessage]) {
    }

    func readerSession(_ session: NFCNDEFReaderSession, didDetect tags: [NFCNDEFTag]) {
        let str: String = theactualData
        if tags.count > 1 {
            let retryInterval = DispatchTimeInterval.milliseconds(500)
            session.alertMessage = "More than one Tag Detected, please try again."
            DispatchQueue.global().asyncAfter(deadline: .now() + retryInterval, execute: {
                session.restartPolling()
            })
            return
        }
        let tag = tags.first!
        session.connect(to: tag, completionHandler: { (error: Error?) in
            if nil != error {
                session.alertMessage = "Unable To Connect to Tag"
                session.invalidate()
                return
            }
            tag.queryNDEFStatus(completionHandler: { (ndefstatus: NFCNDEFStatus, _: Int, error: Error?) in
                guard error == nil else {
                    session.alertMessage = "Unable To Connect to Tag"
                    session.invalidate()
                    return
                }
                switch ndefstatus {
                case .notSupported:
                    session.alertMessage = "Unable To Connect to Tag"
                    session.invalidate()
                case .readOnly:
                    session.alertMessage = "Unable To Connect to Tag"
                    session.invalidate()
                case .readWrite:
                    tag.writeNDEF(.init(records: [NFCNDEFPayload.wellKnownTypeURIPayload(string: "\(str)")!]),
                                  completionHandler: { (error: Error?) in
                                      if nil != error {
                                          session.alertMessage = "You Have successfully activated your tag!"
                                      } else {
                                          session.alertMessage = "You Have successfully activated your tag!"
                                      }
                                      session.invalidate()
                                  })
                default:
                    session.alertMessage = "You Have successfully activated your tag!"
                    session.invalidate()
                }
            })
        })
    }
}
