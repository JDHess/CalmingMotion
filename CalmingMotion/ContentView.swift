//
//  ContentView.swift
//  Calming Motion
//
//  Created by Julie Hess on 12/23/22.
//

import SwiftUI

struct ContentView: View {
    @State private var particleSystem = ParticleSystem()
    @State private var motionHandler = MotionManager()
    
    var body: some View {
        
        GeometryReader{ geometry in
            
            
            TimelineView(.animation){ timeline in
                Canvas {context, size in
                    //drawing code here
                    let timelineData = timeline.date.timeIntervalSinceReferenceDate
                    particleSystem.update(date: timelineData)
                    context.blendMode = .plusLighter
                    
                    particleSystem.center = UnitPoint(x: 0.5 + motionHandler.roll, y: 0.5 + motionHandler.pitch)
                    
                    //MARK: Change color
                    
                    for particle in particleSystem.particles {
                        let xPos = particle.x * size.width
                        let yPos = particle.y * size.height
                        var contextCopy = context
                        contextCopy.addFilter(.colorMultiply(Color(hue: particle.hue, saturation: 1, brightness: 1)))
                        contextCopy.opacity = 1-(timelineData - particle.creationDate)
                        contextCopy.draw(particleSystem.image, at: CGPoint(x: xPos, y: yPos))
                    }
                }
                
                .gesture(
                    DragGesture(minimumDistance: 0).onChanged{drag in
                        particleSystem.center.x = drag.location.x / geometry.size.width
                        particleSystem.center.y = drag.location.y / geometry.size.height
                    })
                .ignoresSafeArea()
                .background(.black)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
