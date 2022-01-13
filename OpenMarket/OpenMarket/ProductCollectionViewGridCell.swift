//
//  ProductCollectionViewGridCell.swift
//  OpenMarket
//
//  Created by 박병호 on 2022/01/11.
//

import UIKit

class ProductCollectionViewGridCell: UICollectionViewCell {
  
  @IBOutlet weak var productImageView: UIImageView!
  @IBOutlet weak var productNameLabel: UILabel!
  @IBOutlet weak var productPriceLabel: UILabel!
  @IBOutlet weak var productStockLabel: UILabel!
    
  override func awakeFromNib() {
    super.awakeFromNib()
    configureBorder()
  }
  
  func configureCell(image: UIImage, name: String, price: String, fixedPrice: String , stock: String) {
    productImageView.image = image
    productNameLabel.text = name
    if price == fixedPrice {
      productPriceLabel.text = price
    } else {
      productPriceLabel.text = price
      productPriceLabel.attributedText = price.strikeThrough(strikeTaget: fixedPrice)
    }
    if stock == "품절" {
      productStockLabel.textColor = .orange
    } else {
      productStockLabel.textColor = .black
    }
    productStockLabel.text = stock
  }
  
  private func configureBorder() {
    contentView.layer.borderWidth = 1
    contentView.layer.borderColor = UIColor.gray.cgColor
    contentView.layer.cornerRadius = 8
  }
}
