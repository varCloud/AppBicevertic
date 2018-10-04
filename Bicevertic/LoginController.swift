//
//  LoginController.swift
//  Qr-Reader
//
//  Created by Victor Adrian Reyes on 01/08/18.
//  Copyright © 2018 Victor Adrian Reyes. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireXMLRPC
import AEXML

class LoginController: UIViewController {

    var odooConect : OdooConect!;
    override func viewDidLoad() {
        super.viewDidLoad()
        self.odooConect = OdooConect()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func alClickIniciarSesion(_ sender: Any) {
        
       
        let parameters: [Any] = [odooConect.db,odooConect.usernameP,odooConect.password]
       
        AlamofireXMLRPC.request(self.odooConect.login(), methodName: "login" ,parameters:parameters).responseXMLDocument {(response: DataResponse<AEXMLDocument>) -> Void in
            print("resultado del ws \(response.data)")
            //let xml = SWXMLHash.parse(response.result)
            
            switch response.result {
            case .success(let value):
                     print(value.string)
                    let xmlDoc =  AEXMLDocument(root: value.root, options: value.options)
                     
                     // prints the same XML structure as original
                     print(xmlDoc.xml)
                     
                     // prints cats, dogs
                     if let params = xmlDoc.root["params"]["param"]["value"].all{
                     for param in params {
                            if let idUsuario  = param.children[0].value
                            {
                                if (Int(idUsuario)! > 0)
                                {
                                    self.LanzarControllerPrincipal()
                                }
                            }
                        
                        }
                     }
                    break;
            case .failure:
                break
                
            }
        
        }
    }
    
    func LanzarControllerPrincipal()
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "PrincipalController")
        let aObjNavi = UINavigationController(rootViewController: controller)
        aObjNavi.view.tintColor  = UIColor.white
        aObjNavi.navigationBar.barTintColor = UIColor.blue
        self.present(aObjNavi, animated: true, completion: nil)
    
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
