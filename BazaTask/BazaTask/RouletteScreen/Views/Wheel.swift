//
//  Wheel.swift
//  BazaTask
//
//  Created by Kostiantyn Kaniuka on 01.09.2025.
//

import SwiftUI

struct RouletteWheel: View {
    let pockets: [Pocket]
    let rotation: Double
    
    var body: some View {
        ZStack {
            Circle().fill(Color(hue: 0.35, saturation: 0.8, brightness: 0.25)) // felt background hint
            
            // Segments
            GeometryReader { geo in
                let size = min(geo.size.width, geo.size.height)
                let radius = size / 2
                // let slotAngle = Angle(degrees: 360 / 37)
                
                ZStack {
                    ForEach(Array(pockets.enumerated()), id: \.offset) { idx, pocket in
                        let start = Angle(degrees: Double(idx) * (360.0/37.0))
                        let end = Angle(degrees: Double(idx + 1) * (360.0/37.0))
                        
                        SegmentShape(startAngle: start, endAngle: end)
                            .fill(pocket.color)
                            .overlay(
                                SegmentShape(startAngle: start, endAngle: end)
                                    .stroke(Color.white.opacity(0.6), lineWidth: 1)
                            )
                        
                        // Number label along the ring
                        let mid = Angle(degrees: (Double(idx) + 0.5) * (360.0/37.0))
                        Text("\(pocket.number)")
                            .font(.system(size: 12, weight: .bold, design: .rounded))
                            .foregroundStyle(pocket.number == 0 ? .black : .white)
                            .position(x: geo.size.width/2, y: geo.size.height/2)
                            .offset(x: 0, y: -radius * 0.72)
                            .rotationEffect(mid)
                            .rotationEffect(.degrees(90)) // make upright from tangent
                    }
                    
                    // Inner hub
                    Circle()
                        .fill(Color(white: 0.1))
                        .frame(width: radius * 0.9, height: radius * 0.9)
                        .overlay(Circle().stroke(Color.white.opacity(0.2), lineWidth: 2))
                    
                    Circle()
                        .fill(Color(white: 0.05))
                        .frame(width: radius * 0.35, height: radius * 0.35)
                        .overlay(Circle().stroke(Color.white.opacity(0.3), lineWidth: 2))
                }
                .frame(width: geo.size.width, height: geo.size.height)
            }
        }
        .clipShape(Circle())
        .rotationEffect(.degrees(-95)) // so index 0 starts at top
        .rotationEffect(.degrees(rotation))
        .shadow(radius: 8)
    }
}

struct SegmentShape: Shape {
    var startAngle: Angle
    var endAngle: Angle
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.height) / 2
        path.move(to: center)
        path.addArc(center: center,
                    radius: radius,
                    startAngle: startAngle,
                    endAngle: endAngle,
                    clockwise: false)
        path.closeSubpath()
        return path
    }
}

struct TrianglePointer: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        // Flip the triangle upside down - point at the bottom, base at the top
        path.move(to: CGPoint(x: rect.midX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        path.closeSubpath()
        return path
    }
}
