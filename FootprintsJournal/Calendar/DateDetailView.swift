import SwiftUI

/// A detail view that participates in a matchedGeometryEffect for the day number,
/// and animates the month and year sliding in from the trailing edge.
struct DateDetailView: View {
    let date: Date
    let dayNamespace: Namespace.ID
    let monthNamespace: Namespace.ID
    let matchedID: String
    let monthID: String
    let onClose: () -> Void
    
//    @State private var showMonthYear: Bool = false
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Button {
                    onClose()
                } label: {
                    Label("close", systemImage: "chevron.left")
                }
                .labelStyle(.iconOnly)
                .font(.title)
                .buttonStyle(.glass)
                Spacer()
            }
            HStack(alignment: .firstTextBaseline, spacing: 12) {
                // Day number morphs from the grid cell
  
                Text(date, format: .dateTime.day())
                    .font(.title)
                    .foregroundStyle(.primary)
                    .fixedSize(horizontal: false, vertical: false)
                    .matchedGeometryEffect(id: matchedID, in: dayNamespace)
                    .lineLimit(1)
                    
                
                Text(date, format: .dateTime.month(.wide).year())
                    .font(.title2)
                    .foregroundStyle(.secondary)
                    .matchedGeometryEffect(id: monthID, in: monthNamespace)
                
                Spacer(minLength: 0)
            }
            .padding(.top)
            
            
//            List {
//                ForEach(0..<10) { int in
//                    Text(int, format: .number)
//                }
//            }
//            .transition(.move(edge: .bottom).combined(with: .opacity))
//            .matchedGeometryEffect(id: matchedID, in: dayNamespace)
        }
        .padding(.horizontal)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(
            // Use a material to visually separate from the grid while allowing context to show through
            Rectangle().fill(.ultraThinMaterial)
                .ignoresSafeArea()
        )
    }
}

#Preview("Detail View") {
    @Previewable @Namespace var dayNamespace
    @Previewable @Namespace var monthNamespace
    
    DateDetailView(
        date: .now,
        dayNamespace: dayNamespace,
        monthNamespace: monthNamespace,
        matchedID: String(Date().timeIntervalSinceReferenceDate),
        monthID: String(
            Calendar.current
                .startOfMonth(for: Date()).timeIntervalSinceReferenceDate
        ),
        onClose: {
        }
    )
}
