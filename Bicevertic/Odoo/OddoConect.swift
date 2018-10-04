//
//  OddoConect.swift
//  Qr-Reader
//
//  Created by Victor Adrian Reyes on 01/08/18.
//  Copyright © 2018 Victor Adrian Reyes. All rights reserved.
//

import Foundation

class OdooConect
{
    var url: String = "http://45.58.40.30:8068/";
    var objetos: String = "xmlrpc/2/object";
    var common: String = "xmlrpc/2/common";
    var db : String = "demofe"
    var usernameP : String = "demo";
    var password : String  = "$demo123*";

    func login() -> String
    {
        return self.url+self.common
    }
    
    func CallMetodo()->String{
        return self.url+self.objetos
    }
    
    
}
