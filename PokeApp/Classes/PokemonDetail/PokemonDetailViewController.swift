//
//  PokemonDetailViewController.swift
//  PokeApp
//
//  Created by ahmad zen on 30/11/20.
//  Copyright © 2020 ahmadzen. All rights reserved.
//

import UIKit
import SVProgressHUD
import RxSwift

class PokemonDetailViewController: BaseViewController {
    enum Mode {
        case stats, evolutions
    }

    fileprivate enum Section: Int {
        case header, info
    }

    @IBOutlet var tableView: UITableView!
    @IBOutlet var backgroundView: UIView!
    @IBOutlet var backgroundTopConstraint: NSLayoutConstraint!

    @IBOutlet var sectionHeaderView: UIView!
    @IBOutlet var sectionHeaderTabsView: UIView!
    @IBOutlet fileprivate var statsButton: UIButton!
    @IBOutlet fileprivate var evolutionButton: UIButton!

    var mainColor = UIColor.white
    var tabsHeaderPosition: CGFloat = 0

    var viewModel: PokemonDetailViewModel!

    var tableMode: Mode = .stats {
        didSet {
            self.tableView.reloadData()
            self.setupHeaderButtons()
            DispatchQueue.main.async {
                if self.tableView.numberOfRows(inSection: 0) > 0 {
                    self.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
                } else {
                    self.tableView.scrollRectToVisible(CGRect.zero, animated: true)
                }
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationBarStyle = .transparent

        tableView.tableFooterView = UIView()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 1000.0
        registerCell()

        backgroundView.roundCorners(corners: [.topLeft, .topRight], radius: 48)
        backgroundTopConstraint.constant = 120
        // tableView.contentInset.top = 0
        navigationItem.leftBarButtonItem = UIBarButtonItem(withImage: UIImage(named: "chevron_down_icn"), target: self, action: #selector(dismissAction))

        dataBinding()

        SVProgressHUD.show()
        viewModel.detail()
    }

    func setupHeaderButtons() {
        var color1 = UIColor.black
        let color2 = UIColor.white
        if mainColor != .white {
            color1 = mainColor
        }
        sectionHeaderTabsView.roundCorners(corners: [.topLeft, .topRight], radius: 48)
        statsButton.setTitleColor(color1, for: .normal)
        statsButton.backgroundColor = color2
        statsButton.layer.cornerRadius = 20
        evolutionButton.setTitleColor(color1, for: .normal)
        evolutionButton.backgroundColor = color2
        evolutionButton.layer.cornerRadius = 20

        switch tableMode {
        case .stats:
            statsButton.setTitleColor(color2, for: .normal)
            statsButton.backgroundColor = color1
        case .evolutions:
            evolutionButton.setTitleColor(color2, for: .normal)
            evolutionButton.backgroundColor = color1
        }
    }

    @objc func dismissAction() {
        dismiss(animated: true, completion: nil)
    }

    func registerCell() {
        tableView.register(UINib(nibName: "PokemonDetailTitleTableViewCell", bundle: nil), forCellReuseIdentifier: "PokemonDetailTitleTableViewCell")
        tableView.register(UINib(nibName: "PokemonDetailStatsTableViewCell", bundle: nil), forCellReuseIdentifier: "PokemonDetailStatsTableViewCell")
        tableView.register(UINib(nibName: "PokemonDetailEvolutionTableViewCell", bundle: nil), forCellReuseIdentifier: "PokemonDetailEvolutionTableViewCell")
    }

    func dataBinding() {
        viewModel.pokemonDetail.asObservable().subscribe(onNext: { [weak self] detail in
            SVProgressHUD.dismiss()
            if let detail = detail {
                if let type = detail.types.filter({ $0.slot == 1 })[safe: 0] {
                    let color = UIColor(named: type.name.capitalized) ?? .white
                    self?.mainColor = color
                    self?.view.backgroundColor = color
                    self?.navigationBarStyle = .custom(color: color)
                    self?.setNavigationBarStyle()
                }
                self?.tableView.reloadData()
                self?.setupHeaderButtons()
                if detail.pokemonDescription.isFullyEmpty {
                    self?.viewModel.getDescription()
                }
            }
        }).disposed(by: disposeBag)

        viewModel.evolutionChain.asObservable().subscribe(onNext: { [weak self] evolutions in
            if let self = self, self.tableMode == .evolutions {
                self.tableView.reloadData()
            }
            }).disposed(by: disposeBag)
    }

    @IBAction fileprivate func statsAction(_ sender: Any) {
        tableMode = .stats
    }

    @IBAction fileprivate func evolutionAction(_ sender: Any) {
        tableMode = .evolutions
    }
}

extension PokemonDetailViewController {
    open func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentOffsetY = scrollView.contentOffset.y

        let startBkgY: CGFloat = 120
        if contentOffsetY - startBkgY > 0 {
            backgroundTopConstraint.constant = 0
        } else {
            backgroundTopConstraint.constant = startBkgY + contentOffsetY * -1
        }

        if contentOffsetY - tabsHeaderPosition < 0 {
            sectionHeaderView.backgroundColor = .clear
        } else {
            sectionHeaderView.backgroundColor = view.backgroundColor
        }

        let startTitleY: CGFloat = 200
        if contentOffsetY - startTitleY > 0 {
            navigationItem.title = viewModel.pokemon.name
        } else {
            navigationItem.title = ""
        }
    }
}

extension PokemonDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, didEndDisplayingHeaderView view: UIView, forSection section: Int) {
        guard let pathsForVisibleRows = tableView.indexPathsForVisibleRows,
            let _ = pathsForVisibleRows.last else { return }

        if section == Section.info.rawValue {
            tabsHeaderPosition = sectionHeaderView.frame.origin.y
        }
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == Section.header.rawValue {
            return 1
        }
        switch tableMode {
        case .stats:
            return 1
        case .evolutions:
            print(viewModel.evolutionChain.value.count)
            return viewModel.evolutionChain.value.count
        }
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == Section.header.rawValue {
            return nil
        }
        return sectionHeaderView
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == Section.header.rawValue {
            return 0
        }
        return 80
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == Section.header.rawValue {
            return headerCell(at: indexPath)
        }

        switch tableMode {
        case .stats:
            return statsCell(at: indexPath)
        case .evolutions:
            return evolutionCell(at: indexPath)
        }
    }

    func statsCell(at indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PokemonDetailStatsTableViewCell", for: indexPath) as! PokemonDetailStatsTableViewCell
        cell.setup(detail: viewModel.pokemonDetail.value)
        return cell
    }

    func headerCell(at indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PokemonDetailTitleTableViewCell", for: indexPath) as! PokemonDetailTitleTableViewCell
        cell.setup(pokemon: viewModel.pokemon, detail: viewModel.pokemonDetail.value, tableMode: tableMode)
        return cell
    }

    func evolutionCell(at indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PokemonDetailEvolutionTableViewCell", for: indexPath) as! PokemonDetailEvolutionTableViewCell
        cell.setup(evolution: viewModel.evolutionChain.value[indexPath.row])
        return cell
    }
}
