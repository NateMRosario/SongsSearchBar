//
//  SongsTableViewController.swift
//  SongsTableViewSearchBar
//
//  Created by C4Q on 11/6/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import UIKit

class SongsTableViewController: UITableViewController, UISearchBarDelegate, UISearchResultsUpdating {
    
    var songArray = [Song]()
    
    let searchController = UISearchController(searchResultsController: nil)
    
    var filteredSongArr: [Song] {
        guard let searchTerm = searchTerm, searchTerm != "" else {
            return songArray
        }
        guard let scopeTitles = self.searchController.searchBar.scopeButtonTitles else {
            return songArray
        }
        let selectedIndex = self.searchController.searchBar.selectedScopeButtonIndex
        let filteringCriteria = scopeTitles[selectedIndex]
        switch filteringCriteria {
        case "Song":
            return songArray.filter{$0.name.lowercased().contains(searchTerm.lowercased())}
        case "Artist":
            return songArray.filter{$0.artist.lowercased().contains(searchTerm.lowercased())}
        default:
            return songArray
        }
    }
    var searchTerm: String? {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "Search Songs"
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
        searchController.searchBar.scopeButtonTitles = ["Song", "Artist"]
        searchController.searchBar.delegate = self
        songArray = Song.loveSongs
    }
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredSongArr.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let song = filteredSongArr[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "Song Cell", for: indexPath)
        cell.textLabel?.text = song.name
        cell.detailTextLabel?.text = song.artist
        return cell
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        print(searchController.searchBar.text)
        self.searchTerm = searchController.searchBar.text
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchTerm = searchBar.text
    }
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        tableView.reloadData()
    }

}
