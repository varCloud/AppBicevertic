//
//  OddoUtil.swift
//  Qr-Reader
//
//  Created by Victor Adrian Reyes on 13/09/18.
//  Copyright © 2018 Victor Adrian Reyes. All rights reserved.
//

import Foundation
import AEXML
class OdooUtil
{
    
    func ObtenerClientes (documento : AEXMLDocument) -> [Partner]  {
        
        var indice : Int = 1;
        var partnerArrary = [Partner]()
        if let params = documento.root["params"]["param"]["value"]["array"]["data"]["value"].all{
            for structt in params {
                print("inddice \(indice)")
                indice  = 1;
                if let member = structt["struct"]["member"].all{
                    
                    let partner : Partner  = Partner();
                    for name in member{
                        if (name["name"].value == "display_name") {
                            partner.display_name = name["value"].children[0].value!
                        }else if(name["name"].value == "contact_address"){
                            partner.contact_address = name["value"].children[0].value!
                        }else if(name["name"].value == "commercial_company_name"){
                            partner.commercial_company_name = name["value"].children[0].value!
                        }else if(name["name"].value == "image_small"){
                            partner.image_small = name["value"].children[0].value!
                        }else if(name["name"].value == "phone"){
                            partner.phone = name["value"].children[0].value!
                        }else if(name["name"].value == "id"){
                            partner.id = name["value"].children[0].value!
                        }
                        
                        print("valor name  \(name["name"].value) value \(name["value"].children[0].value)")
                        //print("indice   \(indice)")
                        indice  = indice + 1;
                    }
                    partnerArrary.append(partner)
                }
            }
        }
        return partnerArrary;
        
    }
}
