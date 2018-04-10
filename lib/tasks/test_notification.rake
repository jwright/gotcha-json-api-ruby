desc "Send a test new match notification"
task send_test_match: :environment do
  token = ENV["TOKEN"]

  arena = Arena.first || Arena.create!(location_name: "Seed Coworking",
                                       street_address1: "25 S. St. Clair St.",
                                       city: "Toledo",
                                       state: "OH",
                                       zip_code: "43604")

  seeker = arena.players.first || Player.create!(name: "Jimmy Page",
                                                 email_address: "jimmy@example.com",
                                                 password: "test",
                                                 arenas: [arena])

  device = Device.create! player: seeker, token: token, registered_at: DateTime.now

  opponent = arena.players.second || Player.create!(name: "Robert Plant",
                                                    email_address: "robert@example.com",
                                                    password: "test",
                                                    arenas: [arena])

  match = Match.create! arena: arena,
                        seeker: seeker,
                        opponent: opponent,
                        matched_at: DateTime.now

  NewMatchNotifier.new(match).notify!

  match.destroy
  seeker.destroy if seeker.created_at > 40.seconds.ago
  opponent.destroy if opponent.created_at > 40.seconds.ago
  arena.destroy if arena.created_at > 40.seconds.ago
end
