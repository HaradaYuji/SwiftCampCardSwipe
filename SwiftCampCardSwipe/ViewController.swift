//
//  ViewController.swift
//  SwiftCampCardSwipe
//
//  Created by 原田悠嗣 on 2019/08/07.
//  Copyright © 2019 原田悠嗣. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    // カードの中心
    var centerOfCard: CGPoint!
    // ユーザーカードの配列
    var personList: [UIView] = []
    // 選択されたカードの数を数える変数
    var selectedCardCount: Int = 0
    // ユーザーの名前の配列
    let nameList: [String] = ["津田梅子","ジョージワシントン","ガリレオガリレイ","板垣退助","ジョン万次郎"]
    // 「いいね」をされた名前の配列
    var likedName: [String] = []

    // ベースカード
    @IBOutlet weak var baseCard: UIView!
    // いいね画像
    @IBOutlet weak var likeImage: UIImageView!
    // ユーザーカード
    @IBOutlet weak var person1: UIView!
    @IBOutlet weak var person2: UIView!
    @IBOutlet weak var person3: UIView!
    @IBOutlet weak var person4: UIView!
    @IBOutlet weak var person5: UIView!

    // ViewControllerのviewがロードされた後に呼び出される。
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "いいね！しよう"
        // personListにperson1から5を追加
        personList.append(person1)
        personList.append(person2)
        personList.append(person3)
        personList.append(person4)
        personList.append(person5)
    }

    // viewが表示される直前に呼ばれる。
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // カウント初期化
        selectedCardCount = 0
        // リスト初期化
        likedName = []
    }

    // viewのレイアウト処理が完了した時に呼ばれる
    override func viewDidLayoutSubviews() {
        // ベースカードの中心を代入
        centerOfCard = baseCard.center
    }

    // 完全に遷移が行われ、スクリーン上からViewControllerが表示されなくなったときに呼ばれる
    override func viewDidDisappear(_ animated: Bool) {
        // ユーザーカードを元に戻す
        resetPersonList()
    }

    // 値の受け渡しの準備
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ToLikedList" {
            let vc = segue.destination as! LikedListTableViewController
            // LikedListTableViewControllerのlikedName(左)にViewCountrollewのLikedName(右)を代入
            vc.likedName = likedName
        }
    }

    func resetPersonList() {
        // 5人の飛んで行ったビューを元の位置に戻す
        for person in personList {
            // 元に戻す処理
            // 位置を戻す
            person.center = self.centerOfCard
            // 角度を戻す
            person.transform = .identity
        }
    }

    // ベースカードを元に戻す処理
    func resetCard() {
        baseCard.center = self.centerOfCard
        baseCard.transform = .identity
    }

    // カードスワイプに関する処理
    @IBAction func swipeCard(_ sender: UIPanGestureRecognizer) {

        // sender.viewでPanGestureRecognizerでスワイプ動作を検知する対象のview（ここではベースカード）を取得可能。
        // 取得したviewを定数に代入。
        let card = sender.view!
        // .translation(in: view)でsenderのオブジェクトがviewから動いた距離を取得
        let point = sender.translation(in: view)
        // 取得できた距離をcard.centerに加算
        card.center = CGPoint(x: card.center.x + point.x, y: card.center.y + point.y)
        // ユーザーカードにもbaseCardと同じ動きをさせる
        personList[selectedCardCount].center = CGPoint(x: card.center.x + point.x, y:card.center.y + point.y)
        // 元々の位置と移動先との差
        let xfromCenter = card.center.x - view.center.x

        // 角度処理
        card.transform = CGAffineTransform(rotationAngle: xfromCenter / (view.frame.width / 2) * -0.785)
        personList[selectedCardCount].transform = CGAffineTransform(rotationAngle: xfromCenter / (view.frame.width / 2) * -0.785)

        // likeImageの表示制御
        if xfromCenter > 0 {
            // goodボタンの表示
            likeImage.image = #imageLiteral(resourceName: "いいね")
            // likeImageを表示させる
            likeImage.isHidden = false
        } else if xfromCenter < 0 {
            // badボタンの表示
            likeImage.image = #imageLiteral(resourceName: "よくないね")
            // likeImageを表示させる
            likeImage.isHidden = false
        }

        // 指を離した場合の処理
        if sender.state == UIGestureRecognizer.State.ended {
            // 離した時点のカードの中心の位置が左から50以内のとき
            if card.center.x < 50 {
                // 左に大きくスワイプしたときの処理
                UIView.animate(withDuration: 0.5, animations: {
                    // 該当のユーザーカードを画面外(マイナス方向)へ飛ばす
                    self.personList[self.selectedCardCount].center = CGPoint(x:self.personList[self.selectedCardCount].center.x - 500, y: self.personList[self.selectedCardCount].center.y)
                    // ベースカードを元に戻す処理
                    self.resetCard()

                })
                // likeImageを隠す
                likeImage.isHidden = true
                // 次のカードへ
                selectedCardCount += 1
                // 画面遷移
                if selectedCardCount >= personList.count {
                    performSegue(withIdentifier: "ToLikedList", sender: self)
                }
                // 離した時点のカードの中心の位置が右から50以内のとき
            } else if card.center.x > self.view.frame.width - 50 {
                // 右に大きくスワイプしたときの処理
                UIView.animate(withDuration: 0.5, animations: {
                    // 該当のユーザーカードを画面外(プラス方向)へ飛ばす
                    self.personList[self.selectedCardCount].center = CGPoint(x:self.personList[self.selectedCardCount].center.x + 500, y: self.personList[self.selectedCardCount].center.y)
                    // ベースカードを元に戻す処理
                    self.resetCard()
                })
                // likeImageを隠す
                likeImage.isHidden = true
                // いいねされたリストに追加
                likedName.append(nameList[selectedCardCount])
                // 次のカードへ
                selectedCardCount += 1
                // 画面遷移
                if selectedCardCount >= personList.count {
                    performSegue(withIdentifier: "ToLikedList", sender: self)
                }

            } else {
                // それ以外は元の位置に戻す
                UIView.animate(withDuration: 0.5, animations: {
                    // ベースカードを元に戻す処理
                    self.resetCard()
                    // ユーザーカードを元の位置に戻す
                    self.personList[self.selectedCardCount].center = self.centerOfCard
                    // ユーザーカードの角度を元の位置に戻す
                    self.personList[self.selectedCardCount].transform = .identity
                })
                // likeImageを隠す
                likeImage.isHidden = true
            }
        }
    }

    // バツボタンを押した処理
    @IBAction func disLikeButtonTapped(_ sender: Any) {

        UIView.animate(withDuration: 0.5, animations: {
            self.resetCard()
            self.personList[self.selectedCardCount].center = CGPoint(x: self.personList[self.selectedCardCount].center.x - 500, y:self.personList[self.selectedCardCount].center.y)
        })
        likeImage.isHidden = true
        selectedCardCount += 1
        if selectedCardCount >= personList.count {
            performSegue(withIdentifier: "ToLikedList", sender: self)
        }
    }

    // ハートボタンを押した処理
    @IBAction func likeButtonTapped(_ sender: Any) {

        UIView.animate(withDuration: 0.5, animations: {
            self.resetCard()
            self.personList[self.selectedCardCount].center = CGPoint(x: self.personList[self.selectedCardCount].center.x + 500, y:self.personList[self.selectedCardCount].center.y)
        })
        likeImage.isHidden = true
        likedName.append(nameList[selectedCardCount])
        selectedCardCount += 1
        if selectedCardCount >= personList.count {
            performSegue(withIdentifier: "ToLikedList", sender: self)
        }
    }
}

