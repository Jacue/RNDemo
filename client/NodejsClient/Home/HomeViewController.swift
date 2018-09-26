//
//  HomeViewController.swift
//  NodejsClient
//
//  Created by Jacue on 2018/9/25.
//  Copyright © 2018年 Jacue. All rights reserved.
//

import UIKit

class HomeViewController: UITableViewController {
    
    var users: [User] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupNavigationRightItem()
        
        NetworkClient.getRecords(success: { (userInfo) in
            self.users = userInfo
            self.tableView.reloadData()
        }) { (error) in
            
        }
    }
    
    
    func setupNavigationRightItem() {
        let addItem = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: #selector(addAction))
        self.navigationItem.rightBarButtonItem = addItem
    }
    
    @objc func addAction() {
        let alertController = UIAlertController.init(title: "提示", message: nil, preferredStyle: .alert)
        alertController.addTextField { (textField) in
            textField.placeholder = "请输入姓名"
        }
        alertController.addTextField { (textField) in
            textField.placeholder = "请输入学校名称"
        }
        alertController.addAction(UIAlertAction.init(title: "确定", style: .default, handler: { (action) in
            guard let userName = alertController.textFields?.first?.text else {
                return
            }
            guard let schoolName = alertController.textFields?.last?.text else {
                return
            }
            let params = ["userName": userName, "schoolName": schoolName]
            NetworkClient.addRecord(params: params, success: { (response) in
                if let code = response["code"] as? Int32, code == 200 {
                    guard let data = try? JSONSerialization.data(withJSONObject: params) else {
                        return
                    }
                    guard let user = try? JSONDecoder().decode(User.self, from: data) else {
                        return
                    }
                    self.users.insert(user, at: 0)
                    self.tableView.reloadData()
                }
            }, failure: { (error) in
                
            })
        }))
        self.present(alertController, animated: true, completion: nil)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return users.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let userInfo = users[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath) as! HomeCell
        cell.userNameLabel.text = userInfo.userName
        cell.schoolNameLabel.text = userInfo.schoolName
        
        return cell
    }

    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }

    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }

    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
