//
//  CircularImage.swift
//  Ripple
//
//  Created by Abhishek Velekar on 20/12/25.
//

import SwiftUI

struct CircularImage: View {
    
    private var imageName: String
    private var size : CGFloat
    
    init(imageName: String, size: CGFloat = 100) {
        self.imageName = imageName
        self.size = size
    }
    
    var body: some View {
        if(imageName.starts(with: "https://")){
            AsyncImage(url: URL(string: imageName)){ phase in
                
                if let image = phase.image{
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: size, height: size)
                        .clipShape(Circle())
                }
                else {
                    Image(systemName: "person.crop.circle")
                            .resizable()
                            .scaledToFit()
                            .frame(width: size, height: size)
                            .clipShape(Circle())
                            .foregroundColor(Color(.systemGray4))
                }
            }
        }
        else{
            
            if UIImage(named: imageName) != nil {
                Image(imageName)
                    .resizable()
                    .scaledToFill()
                    .frame(width: size, height: size)
                    .clipShape(Circle())
            } else {
                Image(systemName: "person.crop.circle")
                        .resizable()
                        .scaledToFit()
                        .frame(width: size, height: size)
                        .clipShape(Circle())
                        .foregroundColor(Color(.systemGray4))
                
            }
        }
        
    }
}

#Preview {
    ZStack{
        CircularImage(imageName: "xmark.circle.fill", size: 64)
    }
    .background(.darkBG)
    
}
