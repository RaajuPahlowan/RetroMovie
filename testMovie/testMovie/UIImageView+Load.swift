//
//  UIImageView+Load.swift
//  testMovie
//
//  Created by Fahim Mashroor on 13/11/25.
//

import Foundation
import UIKit

extension UIImageView {
    func load(from url: URL?) {
        guard let url = url else {
            self.image = nil
            return
        }

        self.image = nil

        URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let self = self,
                  let data = data,
                  error == nil,
                  let image = UIImage(data: data) else {
                return
            }

            DispatchQueue.main.async {
                self.image = image
            }
        }.resume()
    }
}
