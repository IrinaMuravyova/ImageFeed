//
//  NetworkError.swift
//  ImageFeed
//
//  Created by Irina Muravyeva on 05.02.2026.
//

enum NetworkError: Error {
    case httpStatusCode(Int)
    case urlRequestError(Error)
    case urlSessionError
    case invalidRequest
    case decodingError(Error)
}
