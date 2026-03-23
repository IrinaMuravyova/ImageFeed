//
//  Constants.swift
//  ImageFeed
//
//  Created by Irina Muravyeva on 27.01.2026.
//

enum Constants {
    static let accessKey = "hk6gqwZ2Y2utMoo2GkNq1cMdxos00AMG3MbiFvXRRcE"
    static let secretKey = "h4IIEYtZU5n5GOU9JSCh4ESxgT3vxolJCfQhAExfidA"
    static let redirectURI = "urn:ietf:wg:oauth:2.0:oob"
    static let accessScope = "public+read_user+write_likes"
    
    static let defaultBaseURLString = "https://api.unsplash.com/"
    static let unsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"
}

struct AuthConfiguration {
    let accessKey: String
    let secretKey: String
    let redirectURI: String
    let accessScope: String
    let defaultBaseURLString: String
    let authURLString: String

    init(accessKey: String, secretKey: String, redirectURI: String, accessScope: String, authURLString: String, defaultBaseURLString: String) {
        self.accessKey = accessKey
        self.secretKey = secretKey
        self.redirectURI = redirectURI
        self.accessScope = accessScope
        self.defaultBaseURLString = defaultBaseURLString
        self.authURLString = authURLString
    }
    
    static var standard: AuthConfiguration {
       return AuthConfiguration(accessKey: Constants.accessKey,
                                secretKey: Constants.secretKey,
                                redirectURI: Constants.redirectURI,
                                accessScope: Constants.accessScope,
                                authURLString: Constants.unsplashAuthorizeURLString,
                                defaultBaseURLString: Constants.defaultBaseURLString)
   }
}
