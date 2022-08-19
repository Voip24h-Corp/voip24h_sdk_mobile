//
//  SipConfiguration.swift
//  voip24h_sdk_mobile
//
//  Created by Phát Nguyễn on 12/08/2022.
//

import Foundation
import linphonesw


class SipConfiguaration: Decodable {
    
    var ext: String!
    var password: String!
    var domain: String!
    var port: Int = 5060
    var transportType: String = ""
    var isKeepAlive: Bool = false
    
    
    func toLpTransportType() -> TransportType {
        switch(transportType) {
            case "Tcp":
                return TransportType.Tcp
            case "Ddp":
                return TransportType.Udp
            case "Tls":
                return TransportType.Tls
            default:
                return TransportType.Udp
        }
    }
    
    private enum CodingKeys : String, CodingKey {
        case ext = "extension", password, domain, port, transportType, isKeepAlive
    }
}
