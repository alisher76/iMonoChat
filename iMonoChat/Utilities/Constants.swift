//
//  Constants.swift
//  iMonoChat
//
//  Created by Alisher Abdukarimov on 8/9/17.
//  Copyright © 2017 MrAliGorithm. All rights reserved.
//

import Foundation


typealias CompletionHandler = (_ Success: Bool) -> () 

// URL Constants

let BASE_URL = "https://imonoclechat.herokuapp.com/v1/"
let URL_REGISTER = "\(BASE_URL)account/register"
let URL_LOGIN = "\(BASE_URL)account/login"
let URL_USER_ADD = "\(BASE_URL)user/add"
// segues

let TO_LOGIN = "toLogin"
let  TO_CREATE_ACCOUNT = "toCreateAccount"
let UNWIND = "unwindToChannel"
let TO_AVATAR_PICKER = "toAvatarPicker"
let AVATAR_CELL = "avatarCell"


// user defaults
let TOKEN_KEY = "token"
let LOGGED_IN_KEY = "loggedIn"
let USER_EMAIL = "userEmail"


//Headers

let HEADER = [
    "Content-Type": "application/json; characterset=utf-8"]
