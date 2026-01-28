//
//  ShoppingListWidget.swift
//  ShoppingListWidget
//
//  Created by Trevor Bollinger on 1/15/26.
//

import SwiftUI
import WidgetKit

// Duplicate struct to ensure decoding works without file sharing issues
struct ShoppingListItem: Identifiable, Hashable, Codable {
    var id: UUID
    let name: String
    let count: Int
}

struct Provider: TimelineProvider {
    let sharedDefaults = UserDefaults(
        suiteName: "group.com.trevorbollinger.animalhandbook"
    )

    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(
            date: Date(),
            items: [
                ShoppingListItem(
                    id: UUID(),
                    name: "Perfect Bear Pelt",
                    count: 5
                ),
                ShoppingListItem(
                    id: UUID(),
                    name: "Perfect Snake Skin",
                    count: 2
                ),
            ],
            isPremium: true
        )
    }

    func getSnapshot(
        in context: Context,
        completion: @escaping (SimpleEntry) -> Void
    ) {
        let (items, isPremium) = fetchData()
        let entry = SimpleEntry(date: Date(), items: items, isPremium: isPremium)
        completion(entry)
    }

    func getTimeline(
        in context: Context,
        completion: @escaping (Timeline<SimpleEntry>) -> Void
    ) {
        let (items, isPremium) = fetchData()
        // Create an entry that is relevant "now"
        let entry = SimpleEntry(date: Date(), items: items, isPremium: isPremium)

        // Refresh every 15 minutes to keep it relatively fresh if app updates failed to push
        let nextUpdate =
            Calendar.current.date(byAdding: .minute, value: 60, to: Date())
            ?? Date()

        let timeline = Timeline(entries: [entry], policy: .after(nextUpdate))
        completion(timeline)
    }
    
    private func fetchData() -> ([ShoppingListItem], Bool) {
        let isPremium = sharedDefaults?.bool(forKey: "hasPremium") ?? false
        
        guard let data = sharedDefaults?.data(forKey: "shoppingList"),
            let items = try? JSONDecoder().decode(
                [ShoppingListItem].self,
                from: data
            )
        else {
            return ([], isPremium)
        }
        
        let validItems = items.filter {
            !$0.name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        }
        
        return (validItems, isPremium)
    }
    
    // Legacy support to match protocol requirement if needed, but we use fetchData() internally
    private func fetchItems() -> [ShoppingListItem] {
        return fetchData().0
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let items: [ShoppingListItem]
    let isPremium: Bool
}

struct ShoppingListWidgetEntryView: View {
    var entry: Provider.Entry
    @Environment(\.widgetFamily) var family

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            if !entry.isPremium {
                // Locked State
                VStack(spacing: 8) {
                    Image(systemName: "lock.fill")
                        .font(.title)
                        .foregroundColor(.secondary)
                    
                    Text("Premium Required")
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    Text("Purchase Premium to use the Shopping List widget.")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                // Normal Content
                HStack {
                    
                    Image(systemName: "cart.fill")
                        .foregroundColor(.accentColor)
                    Text(family == .systemSmall ? "Needed" : "Items Needed")
                        .font(.headline)
                    Spacer()
                }
                .padding(.bottom, 4)

                if entry.items.isEmpty {
                    Spacer()
                    Text("No items tracked")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity, alignment: .center)
                    Spacer()
                } else {
                    let itemsPerColumn = 6
                    
                    if family == .systemMedium {
                        
                        HStack(alignment: .top, spacing: 16) {
                            
                            // Column 1 (First items)
                            VStack(alignment: .leading, spacing: 4) {
                                ForEach(entry.items.prefix(itemsPerColumn)) { item in
                                    ItemRow(item: item)
                                }
                                Spacer()
                            }
                            Spacer()
                            // Column 2 (Next items)
                            VStack(alignment: .leading, spacing: 4) {
                                ForEach(entry.items.dropFirst(itemsPerColumn).prefix(itemsPerColumn)) {
                                    item in
                                    ItemRow(item: item)
                                }
                                
                                let maxVisible = itemsPerColumn * 2
                                if entry.items.count > maxVisible {
                                    Text("+ \(entry.items.count - maxVisible) more")
                                        .font(.caption2)
                                        .foregroundColor(.secondary)
                                }
                                Spacer()
                            }
                        }
                        .padding(.horizontal, 4)
                    } else {
                        // Small / Others
                        VStack(alignment: .leading, spacing: 4) {
                            ForEach(entry.items.prefix(itemsPerColumn)) { item in
                                ItemRow(item: item)
                            }
                            
                            if entry.items.count > itemsPerColumn {
                                Text("+ \(entry.items.count - itemsPerColumn) more")
                                    .font(.caption2)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                }
            }
        }
        .containerBackground(.fill.tertiary, for: .widget)
        .widgetURL(URL(string: "animalhandbook://shoppinglist"))
    }
}

struct ItemRow: View {
    let item: ShoppingListItem

    var body: some View {
        HStack(alignment: .top, spacing: 4) {
            Text("\(item.count)x")
                .font(.caption2)
                .bold()
                .foregroundColor(.secondary)
                .frame(width: 22, alignment: .leading)  // Widened from 14 to 22
                .minimumScaleFactor(0.8)

            Text(item.name)
                .font(.caption2)
                .lineLimit(1)
        }
    }
}

struct ShoppingListWidget: Widget {
    let kind: String = "ShoppingListWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            ShoppingListWidgetEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
        .configurationDisplayName("Shopping List")
        .description("Your RDR2 shopping list.")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

#Preview(as: .systemSmall) {
    ShoppingListWidget()
} timeline: {
    SimpleEntry(
        date: .now,
        items: [
            ShoppingListItem(id: UUID(), name: "Perfect Bear Pelt", count: 5),
            ShoppingListItem(id: UUID(), name: "Perfect Snake Skin", count: 2),
            ShoppingListItem(id: UUID(), name: "Fat", count: 1),
            ShoppingListItem(id: UUID(), name: "Fat", count: 1),
            ShoppingListItem(id: UUID(), name: "Flight Feather", count: 10),
//            ShoppingListItem(id: UUID(), name: "Fat", count: 1),
//            ShoppingListItem(id: UUID(), name: "Flight Feather", count: 10),
        ],
        isPremium: true
    )
}

#Preview(as: .systemMedium) {
    ShoppingListWidget()
} timeline: {
    SimpleEntry(
        date: .now,
        items: [
            ShoppingListItem(id: UUID(), name: "Perfect Bear Pelt", count: 5),
            ShoppingListItem(id: UUID(), name: "Perfect Snake Skin", count: 2),
            ShoppingListItem(id: UUID(), name: "Fat", count: 1),
            ShoppingListItem(id: UUID(), name: "Perfect Bear Pelt", count: 5),
            ShoppingListItem(id: UUID(), name: "Perfect Snake Skin", count: 2),
            ShoppingListItem(id: UUID(), name: "Fat", count: 1),
            ShoppingListItem(id: UUID(), name: "Perfect Bear Pelt", count: 5),
            ShoppingListItem(id: UUID(), name: "Perfect Snake Skin", count: 2),
            ShoppingListItem(id: UUID(), name: "Fat", count: 1),
        ],
        isPremium: true
    )
}
#Preview(as: .systemMedium) {
    ShoppingListWidget()
} timeline: {
    SimpleEntry(
        date: .now,
        items: [
            
        ],
        isPremium: false
    )
}
