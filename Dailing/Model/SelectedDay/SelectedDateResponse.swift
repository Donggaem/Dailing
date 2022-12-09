//
//  SelectedDayResponse.swift
//  Dailing
//
//  Created by 김동겸 on 2022/12/06.
//

import Foundation

struct SelectedDateResponse: Decodable {
    
    var success: Bool
    var message: String
    var data: [UserObject]
}

struct UserObject: Decodable {
    
    var userId: String
    var name: String
    var profile: String
    var post: [PostObject]
}

struct PostObject: Decodable{
   
    var uuid: String
    var title: String
    var content: String
    var image: String
    var lat: Double
    var lng: Double
    var createdAt: String
}
