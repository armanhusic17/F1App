//
//  HomeViewModel.swift
//  F1App
//
//  Created by Arman Husic on 4/27/24.
//

import SwiftUI
@preconcurrency import GoogleGenerativeAI

@MainActor
class HomeViewModel: ObservableObject {
    private let networkClient: NetworkClient
    @Published var generatedText: String = ""
    @Published var raceResultViewModel: RaceResultViewModel? = nil
    @Published var isLoadingGrandPrix = false
    @Published var isLoadingDrivers = false
    @Published var isLoadingConstructors = false
    @Published var isLoadingRaceResults = false
    @Published var driverStandings: [DriverStanding] = []
    @Published var raceResults: Root?
    @Published var raceResults2: [Result] = []
    @Published var winner: String = ""
    @Published var races: [Race] = []
    @Published var raceWinner: [String] = []
    @Published var winningConstructor: [String] = []
    @Published var winningTime: [String] = []
    @Published var winnerFastestLap: [String] = []
    @Published var errorMessage: String?
    @Published var constructorStandings: [ConstructorStanding] = []
    @Published var constructorImages: [Image] = []
    @Published var seasonYear: String = "\(Calendar.current.component(.year, from: Date()))" {
        didSet {
            Task {
                await self.reloadDataForNewSeason()
                seasonSynapse()
            }
        }
    }
    
    enum Constant: String {
        case homescreenTitle = "Grid Pulse"
        case wdcLabel = "World Drivers' Championship Standings"
        case grandPrixLabel = "Grand Prix Results"
    }
    
    init(
        seasonYear: String
    ) {
        self.networkClient = NetworkClient()
        self.seasonYear = seasonYear
        Task {
            await initializeData()
            seasonSynapse()
        }
    }
    
    func seasonSynapse() {
        Task {
            generatedText = try await generateContent(seasonYear: seasonYear)
        }
    }
    
    // Drivers Collection
    func wdcPosition(driverStanding: DriverStanding) -> String {
        return "WDC Position: \(driverStanding.position)"
    }
    
    func wdcPoints(driverStanding: DriverStanding) -> String {
        return "Points \(driverStanding.points)"
    }
    
    func constructorName(driverStanding: DriverStanding) -> String {
        let constructorName = driverStanding.constructor.first
        return constructorName??.name ?? "Team Name"
    }
    
    func driverImage(driverStanding: DriverStanding) -> String {
        return driverStanding.imageUrl ?? "🏎️"
    }
    
    func driverName(driverStanding: DriverStanding) -> [String] {
        return ["\(driverStanding.givenName ?? "First Name")\n\(driverStanding.familyName ?? "Last Name")"]
    }
    
    // Constructor Collection
    func wccPosition(constructorStanding: ConstructorStanding) -> String {
        return "WCC Position: \(constructorStanding.position ?? "⏳")"
    }
    
    func wccPoints(constructorStanding: ConstructorStanding) -> String {
        return "WCC Points: \(constructorStanding.points ?? "⏳")"
    }
    
    func wccWins(constructorStanding: ConstructorStanding) -> String {
        return "Wins: \(constructorStanding.wins ?? "⏳")"
    }
    
    func wccImage(index: Int) -> Image {
        return self.constructorImages[safe: index] ?? Image("gridPulseRed_1024")
    }
    
    func wccName(constructorStanding: ConstructorStanding) -> [String] {
        return ["\(constructorStanding.constructor?.name ?? "⏳")"]
    }
    
    // Grand Prix Collection
    func gpName(race: Race) -> String {
        return "\(race.raceName ?? "⏳")"
    }
    
    func gpCircuit(race: Race) -> String {
        return "\(race.circuit?.circuitName ?? "⏳")"
    }
    
    func gpDate(race: Race) -> String {
        return "\(race.date ?? "⏳")"
    }
    
    func gpTime(race: Race) -> String {
        return "\(race.time ?? "⏳")"
    }
    
    func gpWinner(index: Int) -> String {
        return self.raceWinner[safe: index] ?? "⏳"
    }
    
    func gpWinnerTeam(index: Int) -> String {
        return self.winningConstructor[safe: index] ?? "⏳"
    }
    
    func gpTeamFastestLap(index: Int) -> String {
        return self.winnerFastestLap[safe: index] ?? "⏳"
    }
    
    func gpTeamCountryFlag(race: Race) -> String {
        return "\(race.circuit?.location?.country ?? "⏳")"
    }
    
    func gpWinnerTime(index: Int) -> String {
        return self.winningTime[safe: index] ?? "⏳"
    }
    
    private func initializeData() async {
        self.raceResultViewModel = RaceResultViewModel()
    }
    
    private func returnYear() -> Int {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy"
        return Int(dateFormatter.string(from: Date())) ?? 2024
    }
    
    private func clearData() {
        driverStandings.removeAll()
        constructorStandings.removeAll()
        constructorImages.removeAll()
        winningConstructor.removeAll()
        winnerFastestLap.removeAll()
        winningTime.removeAll()
        raceWinner.removeAll()
        races.removeAll()
    }
    
    func clearRaceResults() {
        raceResults2.removeAll()
    }
    
    @MainActor private func reloadDataForNewSeason() async {
        clearData()
        async let loadRacesTask: () = loadAllRacesForSeason(year: seasonYear)
        async let loadDriverStandingsTask: () = loadDriverStandings(seasonYear: seasonYear)
        async let loadConstructorStandingsTask: () = loadConstructorStandings(seasonYear: seasonYear)

        _ = await (loadRacesTask, loadDriverStandingsTask, loadConstructorStandingsTask)

        async let getDriverImgsTask: () = getDriverImgs()

        _ = await getDriverImgsTask

        async let loadQuickLookResults: () = loadRaceResultsForYear(year: seasonYear)
        await loadQuickLookResults
    }
    
    @MainActor func loadDriverStandings(seasonYear: String) async {
        isLoadingDrivers = true
        do {
            let standings = try await networkClient.worldDriversChampionshipStandings(seasonYear: self.seasonYear)
            driverStandings.removeAll()
            driverStandings.append(contentsOf: standings.unique(by: {$0.familyName}))
            // Update UI or state with standings
        } catch {
            // Handle errors such as display an error message
            print("Error gathering driver standings... \(error.localizedDescription)")
        }
        isLoadingDrivers = false
    }
    
    @MainActor func getDriverImgs() async {
        let nc = self.networkClient
        for index in driverStandings.indices {
            Task { [weak self] in
                guard let self else { return }
                let driverImg = try await nc.fetchDriverImgFromWikipedia(
                    givenName: self.driverStandings[safe: index]?.givenName ?? "⏳",
                    familyName: self.driverStandings[safe: index]?.familyName ?? "⏳")
                self.driverStandings[index].imageUrl = driverImg
            }
        }
    }
    
    @MainActor func loadConstructorStandings(seasonYear: String) async {
        let nc = self.networkClient
        isLoadingConstructors = true
        Task { [weak self] in
            guard let self else { return }
            do {
                let standings = try await nc.getConstructorStandings(seasonYear: self.seasonYear)
                constructorStandings.removeAll()
                self.constructorStandings.append(contentsOf: standings.unique(by: { $0.constructor?.name ?? ""}))
                await self.getConstructorImages()
            } catch {
                print("Constructors query failed to gather data...")
            }
            isLoadingConstructors = false
        }
    }
    
    @MainActor func getConstructorImages() async {
        let nc = self.networkClient
        isLoadingConstructors = true
        let constructorLoop = constructorStandings.indices
        Task { [weak self] in
            for index in constructorLoop {
                do {
                    let constructorImg = try await nc.fetchConstructorImageFromWikipedia(constructorName: self?.constructorStandings[safe: index]?.constructor?.name ?? "Unable to get constructor name")
                    self?.constructorImages.append(constructorImg)
                    print(self?.constructorStandings[safe: index]?.constructor?.name ?? "Unable to get constructor name")
                } catch {
                    // Handle errors such as display an error message
                    self?.constructorImages.append(Image("gridPulseRed_1024"))
                    print("Constructors wikipedia fetch failed to gather data...\(error)")
                }
            }
        }
    }
    
    @MainActor func loadAllRacesForSeason(year: String) async {
        let nc = self.networkClient
        isLoadingGrandPrix = true
        Task { [weak self] in
            guard let self else { return }
            do {
                let raceResults = try await nc.fetchRaceSchedule(forYear: year)
                self.races = raceResults.mrData?.raceTable?.races ?? []
                print("NUMBER OF RACES \(races.count)")
            } catch {
                self.errorMessage = "Failed to fetch data: \(error.localizedDescription)"
            }
            isLoadingGrandPrix = false
        }
    }
    
    @MainActor func loadRaceResultsForYear(year: String) async {
        let nc = self.networkClient
        isLoadingRaceResults = true
        Task { [weak self] in
            guard let self else { return }

            for index in Range(1...races.count + 1) {
                do {
                    let raceResultsData = try await nc.fetchRaceResults(
                        season: year,
                        round: "\(index)"
                    )
                    raceWinner.append(
                        "\(raceResultsData.mrData?.raceTable?.races?.first?.results?.first?.driver?.givenName ?? "") \(raceResultsData.mrData?.raceTable?.races?.first?.results?.first?.driver?.familyName ?? "")"
                    )
                    winningConstructor.append(
                        raceResultsData.mrData?.raceTable?.races?.first?.results?.first?.constructor?.name ?? ""
                    )
                    winningTime.append(
                        raceResultsData.mrData?.raceTable?.races?.first?.results?.first?.time?.time ?? ""
                    )
                    winnerFastestLap.append(
                        raceResultsData.mrData?.raceTable?.races?.first?.results?.first?.fastestLap?.time?.time ?? ""
                    )
                } catch {
                    print("failed to fetch data \(error.localizedDescription)")
                }
            }
        }

        isLoadingRaceResults = false
    }
    
    @MainActor func fetchRaceResults(season: String, round: String) async {
        let nc = self.networkClient
        Task { [weak self] in
            guard let self else { return }
            do {
                let results = try await nc.fetchRaceResults(
                    season: season,
                    round: round
                )

                if let race = results.mrData?.raceTable?.races?.first {
                    await MainActor.run {
                        self.raceResults2 = race.results ?? []

                        if let winner = race.results?.first {
                            self.winner = "\(winner.driver?.givenName ?? "") \(winner.driver?.familyName ?? "")"
                        }
                    }
                }
            } catch {
                print("failed to fetch data \(error.localizedDescription)")
            }
        }
    }
    
    private func generateContent(seasonYear: String) async throws -> String {
        let generativeModel =
          GenerativeModel(
            // Specify a Gemini model appropriate for your use case
            name: "gemini-1.5-flash-8b",
            // Access your API key from your on-demand resource .plist file (see "Set up your API key"
            // above)
            apiKey: APIKey.default
          )

        let prompt = "Write a short poem summary about the \(seasonYear) Formula 1 season."
        
        do {
            let response = try await generativeModel.generateContent(prompt)
            if let text = response.text {
                generatedText = text
                print("GENERATED TEXT OUTPUT - \(text)")
                return generatedText
            }
        } catch {
            throw error
        }
        
        return ""
    }
}

extension Array {
    func unique<T: Hashable>(by key: (Element) -> T) -> [Element] {
        var seenKeys = Set<T>()
        return filter { element in
            let key = key(element)
            return seenKeys.insert(key).inserted
        }
    }
}

extension Locale {
    /// Returns the flag emoji for a given country name or nil if the country is not found.
    static func flag(for countryName: String) -> String? {
        // Find the country code for the given country name.
        let countryCodes = Locale.isoRegionCodes
        var countryCode: String?
        
        for code in countryCodes {
            let identifier = Locale.identifier(fromComponents: [NSLocale.Key.countryCode.rawValue: code])
            let name = Locale(identifier: identifier).localizedString(forRegionCode: code)
            if name?.lowercased() == countryName.lowercased() {
                countryCode = code
                break
            }
        }
        
        // Ensure a country code was found.
        guard let code = countryCode else { return nil }
        
        // Convert the country code to a flag emoji.
        return code
            .unicodeScalars
            .map { UnicodeScalar(127397 + $0.value)! }
            .map { String($0) }
            .joined()
    }
}

enum APIKey {
  // Fetch the API key from `GenerativeAI-Info.plist`
  static var `default`: String {
      guard let filePath = Bundle.main.path(forResource: "GenerativeAI-Info", ofType: "plist")
      else {
        fatalError("Couldn't find file 'GenerativeAI-Info.plist'.")
      }
      let plist = NSDictionary(contentsOfFile: filePath)
      guard let value = plist?.object(forKey: "API_KEY") as? String else {
        fatalError("Couldn't find key 'API_KEY' in 'GenerativeAI-Info.plist'.")
      }
      if value.starts(with: "_") {
        fatalError(
          "Follow the instructions at https://ai.google.dev/tutorials/setup to get an API key."
        )
      }
      return value
  }
}
