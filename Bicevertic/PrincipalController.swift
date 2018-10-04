//
//  PrinciapController.swift
//  Qr-Reader
//
//  Created by Victor Adrian Reyes on 04/09/18.
//  Copyright © 2018 Victor Adrian Reyes. All rights reserved.
//

import Alamofire
import AlamofireXMLRPC
import AEXML
import UIKit

class PrincipalController: BaseViewController ,UITableViewDataSource, UITableViewDelegate {
    var odooConect : OdooConect!;
    var odooUtil : OdooUtil!;
    var partnerArrary = [Partner]();
    @IBOutlet var tblClientes: UITableView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSlideMenuButton()
        self.odooConect = OdooConect()
        self.odooUtil  = OdooUtil()
        self.tblClientes.tableFooterView = UIView();
    }
    /*
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.ConsultarClientes();

    }
    */

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.partnerArrary.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        
        let cell = self.tblClientes.dequeueReusableCell(withIdentifier: "cellClientes", for: indexPath)
            as! HeadlineTableViewCell
        cell.lblNombreEmpresa.text = partnerArrary[indexPath.row].display_name;
        cell.lblDireccionEmpresa.text = partnerArrary[indexPath.row].contact_address;
        cell.lblTelefonoEmpresa.text = partnerArrary[indexPath.row].phone;
    
        if  let imageData = Data(base64Encoded: partnerArrary[indexPath.row].image_small, options: .ignoreUnknownCharacters){
            let image = UIImage(data: imageData)
            cell.imgLogoEmpresa.image = image;
        }
        
        
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        cell.layoutMargins = UIEdgeInsets.zero
        cell.preservesSuperviewLayoutMargins = false
        cell.backgroundColor = UIColor.clear
        
        cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, UIScreen.main.bounds.width)
        cell.separatorInset = .zero
        return cell
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.tblClientes.reloadData();
        self.ConsultarClientes()
    }
    

    func ConsultarClientes(){
        
        let conditions:  [Any] = [[["parent_id","=",false]]]
        let parameters: [Any] = [odooConect.db,5,odooConect.password,"res.partner","search_read",conditions]
        
        AlamofireXMLRPC.request(self.odooConect.CallMetodo(), methodName: "execute_kw" ,parameters:parameters).responseXMLDocument {(response: DataResponse<AEXMLDocument>) -> Void in
            
            //print("resultado del ws \(response.data)")
            //print(NSString(data: (response.request?.httpBody)!, encoding: String.Encoding.utf8.rawValue) ?? "sin valor")
            //print(NSString(data: (response.data)!, encoding: String.Encoding.utf8.rawValue) ?? "sin valor")
           
            switch response.result {
            case .success(let value):
                print(value.string)
                let xmlDoc =  AEXMLDocument(root: value.root, options: value.options)
                    self.partnerArrary = self.odooUtil.ObtenerClientes(documento: xmlDoc);
                self.tblClientes.reloadData();
                
                break;
            case .failure:
                
                break
                
            }
            
        }
        
    }
    
    func ObtenerValor(valueDelXml: AEXMLElement , nombrePropiedad: String ) -> Any{
        if let valorActualNodo = valueDelXml["struct"]["member"]["name"].all(withValue: "sale_order_count"){
            for  valor in valorActualNodo{
                if let nodo = valor.parent{
                    return nodo["value"].children[0].value;
                }
            }
        }
        return "sin datos";
        
    }
    
}


class HeadlineTableViewCell: UITableViewCell {
    
    @IBOutlet weak var imgLogoEmpresa: UIImageView!
    @IBOutlet weak var lblTelefonoEmpresa: UILabel!
    @IBOutlet weak var lblDireccionEmpresa: UILabel!
    @IBOutlet weak var lblNombreEmpresa: UILabel!
    
}
