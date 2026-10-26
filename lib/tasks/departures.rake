namespace :departures do
  desc "Create missing departures. " \
       "TOUR=slug KIND=group|private TIMES=09:00,10:30 DAYS=mon,tue,... CAPACITY=12 FROM=YYYY-MM-DD TO=YYYY-MM-DD [SKIP=YYYY-MM-DD,...]"
  task generate: :environment do
    fetch = ->(key) { ENV.fetch(key) { abort "Missing #{key}. See: bin/rails -D departures:generate" } }
    list = ->(value) { value.to_s.split(",").map(&:strip).compact_blank }

    tour = Tour.find_by!(slug: fetch.("TOUR"))
    created = Departures::Generator.call(
      tour: tour, kind: fetch.("KIND"), times: list.(fetch.("TIMES")),
      days: list.(ENV.fetch("DAYS", "mon,tue,wed,thu,fri,sat,sun")), capacity: fetch.("CAPACITY"),
      from: fetch.("FROM"), to: fetch.("TO"), skip_dates: list.(ENV["SKIP"])
    )
    puts "Created #{created} #{ENV["KIND"]} departures for #{tour.title}."
  end
end
