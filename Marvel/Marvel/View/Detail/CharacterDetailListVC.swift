//
//  CharacterDetailListVC.swift
//  Marvel
//
//  Created by 김지나 on 2023/09/01.
//

import UIKit

class CharacterDetailListVC: UIViewController, Storyboarded, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var detailTB: UITableView!
    
    weak var coordinator: MainCoordinator?
    var character: Character!
    let cellID = "detailCell"
    var data = [[String: CSSEList]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
        makeData()
    }
    
    func setUI() {
        self.navigationItem.title = character?.name
        
        detailTB.delegate = self
        detailTB.dataSource = self
    }
    
    func makeData() {
        let comic = character.comics
        let series = character.series
        let story = character.stories
        let event = character.events
        
        if (comic?.items!.count)! > 0 {
            let dic = ["comic":comic!]
            data.append(dic)
        }
        if (series?.items!.count)! > 0 {
            let dic = ["series":series!]
            data.append(dic)
        }
        if (story?.items!.count)! > 0 {
            let dic = ["story":story!]
            data.append(dic)
        }
        if (event?.items!.count)! > 0 {
            let dic = ["event":event!]
            data.append(dic)
        }
    }
    
    func findKey(from dic:[String: CSSEList]) -> String {
        var keyString = ""
        
        for (key, _) in dic {
            keyString = key
        }
        
        return keyString
    }
}


// MARK: table
extension CharacterDetailListVC {
    // section
    func numberOfSections(in tableView: UITableView) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return findKey(from: data[section])
    }
    
    // row
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let key = findKey(from: data[section])
        let data = data[section][key]
        let dataItem = data?.items
        return dataItem!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: cellID)
        var content = cell.defaultContentConfiguration()
        let section = indexPath.section
        let index = indexPath.row
        
        let key = findKey(from: data[section])
        let data = data[section][key]
        let dataItem = data?.items
        
        content.text = dataItem![index].name
        cell.contentConfiguration = content
        return cell
    }
}
