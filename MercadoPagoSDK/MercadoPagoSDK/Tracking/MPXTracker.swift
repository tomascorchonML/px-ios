//
//  MPXTracker.swift
//  MercadoPagoSDK
//
//  Created by Demian Tejo on 6/1/17.
//  Copyright © 2017 MercadoPago. All rights reserved.
//

import UIKit

@objc internal class MPXTracker: NSObject {
    @objc internal static let sharedInstance = MPXTracker()

    internal static let kTrackingSettings = "tracking_settings"
    internal var public_key: String = ""
    internal var sdkVersion = Utils.getSetting(identifier: "sdk_version") ?? ""

    private static let kTrackingEnabled = "tracking_enabled"
    private var trackListener: PXTrackerListener?
    private var flowDetails: [String: Any]?
    private var flowName: String?
    private var sessionService: SessionService = SessionService()
}

// MARK: Getters/setters.
internal extension MPXTracker {

    internal func setTrack(listener: PXTrackerListener) {
        trackListener = listener
    }

    internal func setFlowDetails(flowDetails: [String: Any]?) {
        self.flowDetails = flowDetails
    }

    internal func setFlowName(name: String?) {
        self.flowName = name
    }

    internal func startNewFlow() {
        sessionService.startNewSession()
    }

    internal func startNewFlow(externalSessionId: String) {
        sessionService.startNewSession(externalSessionId: externalSessionId)
    }

    internal func getSessionID() -> String {
        return sessionService.getSessionId()
    }

    internal func clean() {
        MPXTracker.sharedInstance.flowDetails = [:]
        MPXTracker.sharedInstance.trackListener = nil
    }
}

// MARK: Public interfase.
internal extension MPXTracker {
    internal func trackScreen(screenName: String, properties: [String: Any] = [:]) {
        if let trackListenerInterfase = trackListener {
            var metadata = properties
            if let flowDetails = flowDetails {
                metadata["flow_detail"] = flowDetails
            }
            if let flowName = flowName {
                metadata["flow"] = flowName
            }
            metadata[SessionService.SESSION_ID_KEY] = sessionService.getSessionId()
            trackListenerInterfase.trackScreen(screenName: screenName, extraParams: metadata)
        }
    }

    internal func trackEvent(path: String, properties: [String: Any] = [:]) {
        if let trackListenerInterfase = trackListener {
            var metadata = properties
            if path != TrackingPaths.Events.getErrorPath() {
                if let flowDetails = flowDetails {
                    metadata["flow_detail"] = flowDetails
                }
                if let flowName = flowName {
                    metadata["flow"] = flowName
                }
                metadata[SessionService.SESSION_ID_KEY] = sessionService.getSessionId()
            } else {
                if let extraInfo = metadata["extra_info"] as? [String: Any] {
                    var frictionExtraInfo: [String: Any] = extraInfo
                    frictionExtraInfo["flow_detail"] = flowDetails
                    frictionExtraInfo["flow"] = flowName
                    frictionExtraInfo[SessionService.SESSION_ID_KEY] = sessionService.getSessionId()
                    metadata["extra_info"] = frictionExtraInfo
                } else {
                    var frictionExtraInfo: [String: Any] = [:]
                    frictionExtraInfo["flow_detail"] = flowDetails
                    frictionExtraInfo["flow"] = flowName
                    frictionExtraInfo[SessionService.SESSION_ID_KEY] = sessionService.getSessionId()
                    metadata["extra_info"] = frictionExtraInfo
                }
            }
            trackListenerInterfase.trackEvent(screenName: path, action: "", result: "", extraParams: metadata)
        }
    }
}
