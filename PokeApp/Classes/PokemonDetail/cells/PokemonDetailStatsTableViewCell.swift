//
//  PokemonDetailStatsTableViewCell.swift
//  PokeApp
//
//  Created by ahmad zen on 30/11/20.
//  Copyright © 2020 ahmadzen. All rights reserved.
//

import UIKit

class PokemonDetailStatsTableViewCell: UITableViewCell {
    @IBOutlet var hpValueLabel: UILabel!
    @IBOutlet var atkValueLabel: UILabel!
    @IBOutlet var defValueLabel: UILabel!
    @IBOutlet var satkValueLabel: UILabel!
    @IBOutlet var sdefValueLabel: UILabel!
    @IBOutlet var spdValueLabel: UILabel!

    @IBOutlet var hpProgressView: UIProgressView!
    @IBOutlet var atkProgressView: UIProgressView!
    @IBOutlet var defProgressView: UIProgressView!
    @IBOutlet var satkProgressView: UIProgressView!
    @IBOutlet var sdefProgressView: UIProgressView!
    @IBOutlet var spdProgressView: UIProgressView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setup(detail: PokemonDetail?) {
        guard let detail = detail else {
            return
        }

        if let type = detail.types.filter({ $0.slot == 1 })[safe: 0] {
            let color = UIColor(named: type.name.capitalized) ?? .black

            for subView in contentView.subviews {
                if let label = subView as? UILabel, label.tag == 1 {
                    label.textColor = color
                }
                if let progress = subView as? UIProgressView {
                    progress.progressTintColor = color
                }
            }
        }

        // values
        for stat in detail.stats {
            switch stat.visualName {
            case "HP":
                hpValueLabel.text = String(format: "%03d", stat.value)
                hpProgressView.progress = Float(stat.value) / 100.0
            case "ATK":
                atkValueLabel.text = String(format: "%03d", stat.value)
                atkProgressView.progress = Float(stat.value) / 100.0
            case "DEF":
                defValueLabel.text = String(format: "%03d", stat.value)
                defProgressView.progress = Float(stat.value) / 100.0
            case "SATK":
                satkValueLabel.text = String(format: "%03d", stat.value)
                satkProgressView.progress = Float(stat.value) / 100.0
            case "SDEF":
                sdefValueLabel.text = String(format: "%03d", stat.value)
                sdefProgressView.progress = Float(stat.value) / 100.0
            case "SPD":
                spdValueLabel.text = String(format: "%03d", stat.value)
                spdProgressView.progress = Float(stat.value) / 100.0
            default:
                ()
            }
        }
    }
}
