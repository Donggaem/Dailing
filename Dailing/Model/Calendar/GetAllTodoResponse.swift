//
//  AllTodoList.swift
//  Dailing
//
//  Created by 김동겸 on 2022/12/02.
//

import Foundation

struct GetAllTodoResponse: Decodable {
    
    var success: Bool
    var message: String
    var data: [DotObject]
}

struct DotObject: Decodable {
    
    var date: String
    var userList: [String]
}
