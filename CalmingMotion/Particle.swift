//
//  Particle.swift
//  Zen Motion
//
//  Created by Julie Hess on 12/23/22.
//

import Foundation

struct Particle: Hashable {
    let x: Double
    let y: Double
    let creationDate = Date.now.timeIntervalSinceReferenceDate
    let hue: Double
}
