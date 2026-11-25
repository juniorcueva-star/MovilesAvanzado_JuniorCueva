//
//  ImageCompressor.swift
//  Lab14IntroFirebase
//
//  Created by Junior Cueva Fabian on 24/11/26.
//

import UIKit

// Reduce y comprime las fotos para guardarlas dentro de un documento de Firestore.
// Firestore permite como máximo 1 MB por documento, así que la foto se deja por debajo de ~600 KB.
enum ImageCompressor {

    static func compress(_ data: Data, maxDimension: CGFloat = 1024, maxBytes: Int = 600_000) -> Data? {
        guard let image = UIImage(data: data) else { return nil }

        // 1. Reducir el tamaño (el lado más largo queda en 1024 px como máximo)
        let size = image.size
        let scale = min(1, maxDimension / max(size.width, size.height))
        let newSize = CGSize(width: size.width * scale, height: size.height * scale)

        let format = UIGraphicsImageRendererFormat()
        format.scale = 1
        let resized = UIGraphicsImageRenderer(size: newSize, format: format).image { _ in
            image.draw(in: CGRect(origin: .zero, size: newSize))
        }

        // 2. Comprimir en JPEG bajando la calidad hasta que quepa
        var quality: CGFloat = 0.7
        while quality > 0.1 {
            if let jpeg = resized.jpegData(compressionQuality: quality), jpeg.count <= maxBytes {
                return jpeg
            }
            quality -= 0.15
        }
        return resized.jpegData(compressionQuality: 0.1)
    }
}
