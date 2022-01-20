//
//  EmptyStateMapper.swift
//  DNApp
//
//  Created by Asaduzzaman Shuvro on 16/9/20.
//  Copyright © 2020 no.dn.dn. All rights reserved.
//

import Foundation
import UIKit

fileprivate protocol ErrorMessageType : Error {
    var message: String {get}
    init(message: String)
    func getMessage() -> String
}

extension ErrorMessageType {
    func getMessage() -> String {
        return self.message
    }
}

//------------------------------------------
//MARK:- Component Initialization Error
//------------------------------------------
struct ComponentInitializationError:  ErrorMessageType {
     let message: String
    
    init(message: String) {
        self.message = message
    }
    
    func getMessage() -> String {
        return self.message
    }
}

struct JSONParsingError: ErrorMessageType {
    var message: String
    
    init(message: String) {
        self.message = message
    }
}

class ErrorStateMapper {
    static let shared: ErrorStateMapper = ErrorStateMapper()
    
    func getViewModel(for error: DnAppError?) -> EmptyStateViewModel {
       
        switch error {
        case .noInternet?:
            return EmptyStateViewModel(title: "Nettverksfeil", description: "Noe er galt med nettverksforbindelsen. Kontakt nettverksleverandøren din eller prøv igjen.", iconImage: UIImage(named: "iconNetworkError")?.withRenderingMode(.alwaysTemplate), refreshButtonTitle: "Try again")
        default:
            return EmptyStateViewModel(title: "Noe gikk galt", description: "En ukjent feil har oppstått. Forsøk å starte appen på nytt. Hvis det ikke hjelper, sjekk at du har siste versjon av appen.", iconImage: UIImage(named: "iconGeneralError")?.withRenderingMode(.alwaysTemplate), refreshButtonTitle: "Try again")
        }
    }
    
}

enum DnAppError: Error {
    case noInternet
    case badUrl
    case requestTimeOut
    case other
    case httpError(HTTPURLResponse, Data?)
}

extension Error {
    func extractErrorType() -> DnAppError {
        if let error =  self as? URLError {
            if error.code == .notConnectedToInternet {
                return .noInternet
            }
        }
        return .other
    }
    
    var asDnAppError: DnAppError?  {
        return self as? DnAppError
    }
    
}



struct EmptyStateViewModel {
    let title: String
    let description: String
    let iconImage: UIImage?
    let refreshButtonTitle: String
}
