//
//  NetworkManager.swift
//  SSLPinningSample
//
//  Created by Ada on 15/12/20.
//  Copyright © 2020 Pratibha. All rights reserved.
//

import Foundation
import Alamofire

class NetworkManager {
    
    var sessionManager: SessionManager?
    static var sharedManager: NetworkManager = NetworkManager()
    
    private init(){
        
    }
    
    public func pinningWithPublicKey(host: String) {
        let serverTrustPolicy: [String: ServerTrustPolicy] = [host: .pinPublicKeys(
            publicKeys: ServerTrustPolicy.publicKeys(),
            validateCertificateChain: true,
            validateHost: true
            )]
        
        sessionManager = Alamofire.SessionManager(
            configuration: URLSessionConfiguration.default,
            serverTrustPolicyManager: ServerTrustPolicyManager(policies: serverTrustPolicy)
        )
    }
    
    public func pinningWithCertificate(host: String) {
        let certificates: [SecCertificate] = getCertificate(resource: "google", withExtension: ".cer")
        let serverTrustPolicy: [String: ServerTrustPolicy] = [host: .pinCertificates(certificates: certificates, validateCertificateChain: true, validateHost: true)]
        
        sessionManager = Alamofire.SessionManager(configuration: URLSessionConfiguration.default, serverTrustPolicyManager: ServerTrustPolicyManager(policies: serverTrustPolicy))
        
    }
    public func getCertificate(resource: String, withExtension: String) -> [SecCertificate] {
        guard let url  = Bundle.main.url(forResource: resource, withExtension: withExtension)
            else {
             return []
        }
        let localCertificate = try! Data(contentsOf: url) as CFData
        guard let certificate = SecCertificateCreateWithData(nil, localCertificate)
            else {
                return []
        }
        return [certificate]
    }
}
