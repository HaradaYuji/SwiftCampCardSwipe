//
//  LikedListTableViewController.swift
//  SwiftCampCardSwipe
//
//  Created by 原田悠嗣 on 2019/08/07.
//  Copyright © 2019 原田悠嗣. All rights reserved.
//

import UIKit

class LikedListTableViewController: UITableViewController {

    // 受け渡されるいいねリストを格納する変数
    var likedName: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "いいね！リスト"
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // likedNameの配列の要素数を返す
        return likedName.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        // LikedListのリストを表示
        cell.textLabel?.text = likedName[indexPath.row]

        return cell
    }
}
