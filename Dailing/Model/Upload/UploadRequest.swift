//
//  UploadRequest.swift
//  Dailing
//
//  Created by 김동겸 on 2022/12/05.
//

import Foundation

struct UploadRequest: Encodable {
    
    var userId: String
    var title: String
    var content: String
    var lat: Float
    var lng: Float
    var image: Data
}
