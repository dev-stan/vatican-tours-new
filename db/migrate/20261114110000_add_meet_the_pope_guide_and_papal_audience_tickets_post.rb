# Adds the first travel tips guide (the "How to Meet the Pope in Rome" pillar page) and its first blog post ("Papal
# Audience Tickets"), which goes live on 19 Nov 2026 and links up to the guide. The content is frozen here so later
# edits elsewhere can't change what this migration does. Posts that already exist are left alone. The booking button
# links the papal audience tour only if it exists in this database.
class AddMeetThePopeGuideAndPapalAudienceTicketsPost < ActiveRecord::Migration[8.1]
  BOOKING_TOUR = "audience-tickets-assistance-on-site"

  GUIDE = YAML.safe_load(<<~'YAML')
    slug: how-to-meet-the-pope-in-rome
    title: How to Meet the Pope in Rome
    published_at: 2026-11-13 00:00
    excerpt: Seeing Pope Leo XIV in person is easier than most visitors think. Here’s how to make your papal encounter in Rome happen, step by step.
    meta_title: "How to Meet the Pope in Rome: Audience, Angelus & Tips"
    meta_description: "See Pope Leo XIV in Rome: Wednesday audience, Sunday Angelus, free tickets and tips. Plus papal audience assistance and VIP private service."
    button: Book Papal Audience Tickets & Assistance
    body: |
      <div>Seeing Pope Leo XIV in person is easier than most visitors think: almost every Wednesday he holds a General Audience in St. Peter’s Square, and on Sundays he prays the Angelus from his window. With a bit of planning (and the right tickets), you can be there.</div>
      <div>Here’s how to make your papal encounter in Rome happen, step by step.</div>
      <h2>The Wednesday General Audience: your best chance</h2>
      <div>The General Audience is the most reliable way to see the Pope up close. It is held most Wednesdays at around 10:00 a.m., in St. Peter’s Square or, in colder months and bad weather, in the Paul VI Audience Hall. It is not a Mass but a gathering of catechesis, readings in several languages and prayer, ending with the Pope’s blessing.</div>
      <div>Before the audience begins, the Pope usually rides through the crowd in the popemobile — the moment most visitors remember for life.</div>
      <div><strong>Tickets are free but required.</strong> They are issued by the Prefecture of the Papal Household and must be requested in advance, then collected in person in Rome, usually the day before. Demand peaks around major feasts, holidays and papal anniversaries, and audiences are cancelled when the Pope travels, so always check the schedule before booking your trip.</div>
      <h2>Other ways to see the Pope in Rome</h2>
      <ul>
        <li><strong>Sunday Angelus</strong> — at noon, the Pope appears at the window of the Apostolic Palace above St. Peter’s Square for a short prayer and blessing. No ticket needed; just pass security.</li>
        <li><strong>Papal Masses</strong> — celebrated in St. Peter’s Basilica or Square on major feasts such as Christmas, Easter and Sts. Peter and Paul. Tickets are usually required and harder to get.</li>
        <li><strong>Castel Gandolfo</strong> — in summer, when Wednesday audiences pause, the Pope often spends time at the papal residence in the Alban Hills and may lead the Angelus there.</li>
      </ul>
      <h2>Practical tips for audience day</h2>
      <ol>
        <li><strong>Arrive early.</strong> Gates usually open around 7:30 a.m.; the best spots near the popemobile route go to those who come first.</li>
        <li><strong>Dress modestly.</strong> Cover shoulders and knees — this is a religious event inside Vatican territory.</li>
        <li><strong>Travel light.</strong> Expect airport-style security; leave large bags, glass and sharp objects at your hotel.</li>
        <li><strong>Bring water, a hat or an umbrella.</strong> You may wait two to three hours outdoors.</li>
        <li><strong>Have your ticket in hand.</strong> No ticket, no entry to the seated area.</li>
      </ol>
      <h2>Can you actually shake the Pope’s hand?</h2>
      <div>A private meeting is rare and cannot be bought. After the General Audience, though, the Pope greets some groups and individuals in person — often newlyweds in wedding attire, the sick and people with disabilities, and their companions. These special-area places are requested in advance through the official channels, typically with a letter from your parish. For everyone else, a seat close to the popemobile route is the most realistic way to see him just a few metres away.</div>
      <h2>Let us handle the details</h2>
      <div>The tickets themselves are free — what takes time is the paperwork, the in-person pickup and finding your way through the crowd on the day. That’s where we come in. Our <a href="/tours/audience-tickets-assistance-on-site"><strong>Papal Audience Tickets &amp; Assistance</strong></a> service includes:</div>
      <ul>
        <li>Submitting your ticket request and checking the official schedule for you</li>
        <li>Collecting your tickets in Rome and delivering them to your hotel</li>
        <li>A local assistant who meets you on audience morning and guides you through security to your sector</li>
        <li>Tips on where to stand for the best view of the popemobile</li>
        <li>Help in your language from start to finish</li>
      </ul>
      <div><strong>Planning a trip to Rome? Book your papal audience assistance today and focus on the moment, not the logistics.</strong></div>
      <div><em>We are an independent service and are not affiliated with the Holy See. Admission to papal audiences is always free; our fee covers assistance only.</em></div>
  YAML

  POST = YAML.safe_load(<<~'YAML')
    slug: papal-audience-tickets
    title: "Papal Audience Tickets: Skip the Paperwork with Our Help"
    published_at: 2026-11-19 00:00
    excerpt: Papal audience tickets are free but required. How to request them, where to collect them and the mistakes that cost visitors their place.
    meta_title: "Papal Audience Tickets: Get Them Free or Let Us Handle It"
    meta_description: Papal audience tickets are free but required. Learn how to request them, where to collect them and how to avoid common mistakes.
    button: Book Papal Audience Tickets and Assistance on Site
    body: |
      <div>Planning to see Pope Leo XIV at a Wednesday General Audience? Good news first: <strong>papal audience tickets are always free.</strong> You do need one to enter the seated area, though, and getting it involves a request in advance and a pickup in Rome.</div>
      <div>This guide explains how papal audience tickets work, how to request them, where to collect them and the mistakes that cost visitors their place. For the bigger picture — the Angelus, papal Masses and other ways to see the Pope — read our pillar guide <a href="/travel-tips/how-to-meet-the-pope-in-rome"><em>How to Meet the Pope in Rome</em></a>.</div>
      <h2>What a papal audience ticket gets you</h2>
      <div>A ticket gives you access to the seated or standing sectors of the Wednesday General Audience, held in St. Peter’s Square or, in winter and bad weather, in the Paul VI Audience Hall. The audience usually starts around 10:00 a.m. and lasts about 90 minutes, including the Pope’s ride through the crowd in the popemobile.</div>
      <div>Two things a ticket does <strong>not</strong> do:</div>
      <ul>
        <li><strong>It doesn’t reserve a seat.</strong> Places are first come, first served within your sector, so arrival time matters more than the ticket itself.</li>
        <li><strong>It doesn’t guarantee a personal greeting.</strong> Meeting the Pope in person is reserved for specific groups, such as newlyweds and the sick, arranged separately in advance.</li>
      </ul>
      <h2>How to request papal audience tickets</h2>
      <ol>
        <li><strong>Check the date.</strong> Make sure an audience is scheduled for the Wednesday you’ll be in Rome. Audiences are cancelled when the Pope travels and usually pause for part of the summer, and the official calendar is published only a few weeks ahead.</li>
        <li><strong>Send a request to the Prefecture of the Papal Household.</strong> Use the official request form, giving the audience date, the number of people and your contact details. Request as early as you can; demand peaks around Christmas, Easter and major anniversaries.</li>
        <li><strong>Wait for confirmation.</strong> You’ll receive a confirmation telling you when and where to pick up your tickets. Keep it handy on your phone or printed.</li>
      </ol>
      <h2>Where and when to collect your tickets</h2>
      <div>Tickets requested from the Prefecture are typically collected in person at the <strong>Bronze Door</strong> (Portone di Bronzo), on the right-hand side of St. Peter’s colonnade, guarded by the Swiss Guard. Pickup is usually on Tuesday afternoon, the day before the audience, and sometimes early on Wednesday morning. Always follow the exact times given in your confirmation, as they can change.</div>
      <div>Plan for a queue, bring your confirmation and ID, and collect tickets for your whole group in one go.</div>
      <h2>Mistakes to avoid</h2>
      <ul>
        <li><strong>Paying for the ticket itself.</strong> Admission is free. Be wary of street sellers or websites charging for “official tickets”; a legitimate service charges only for its time and help, and says so clearly.</li>
        <li><strong>Requesting too late.</strong> A few days before Christmas or Easter may be too late for large groups.</li>
        <li><strong>Not checking for cancellations.</strong> Look at the schedule again the week of your trip.</li>
        <li><strong>Arriving at 9:30.</strong> Security opens around 7:00–7:30 a.m., and the best spots along the popemobile route fill early.</li>
        <li><strong>Ignoring the dress code.</strong> Cover shoulders and knees; you are entering Vatican territory for a religious event.</li>
      </ul>
      <h2>Papal audience tickets: FAQ</h2>
      <div><strong>Are papal audience tickets free?</strong> Yes. Tickets issued by the Prefecture of the Papal Household are always free of charge.</div>
      <div><strong>How far in advance should I request tickets?</strong> As soon as your travel dates are fixed. For most Wednesdays a few weeks is enough; for Christmas, Easter and large groups, request several months ahead.</div>
      <div><strong>Can I get tickets on the day?</strong> Sometimes spare tickets are handed out on Wednesday morning, but it’s never guaranteed. Don’t rely on it.</div>
      <div><strong>Do children need a ticket?</strong> Yes, every person in your group should be included in the request.</div>
      <div><strong>What happens if the audience is cancelled?</strong> The tickets are no longer valid. If you’re still in Rome, the Sunday Angelus at noon is a good alternative and needs no ticket.</div>
      <h2>Skip the paperwork with our help</h2>
      <div>The tickets are free; the time spent requesting, collecting and finding your way through the crowd is not. Our <a href="/tours/audience-tickets-assistance-on-site">Papal Audience Tickets &amp; Assistance</a> service handles the request, collects your tickets and delivers them to your hotel, then a local assistant meets you on audience morning and guides you through security to your sector. For a stress-free morning, book a <strong>VIP private service</strong>, inclusive of an on-site private concierge and private one-way transportation to the Vatican.</div>
      <div>New to Rome? Start with our complete guide, <a href="/travel-tips/how-to-meet-the-pope-in-rome"><em>How to Meet the Pope in Rome</em></a>, in the Travel tips section.</div>
      <div><em>We are an independent service and are not affiliated with the Holy See. Admission to papal audiences is always free; our fee covers assistance only.</em></div>
  YAML

  def up
    guide = add(TravelTip, GUIDE)
    add(BlogPost, POST, travel_tip: guide)
  end

  def down
    BlogPost.find_by(slug: POST["slug"])&.destroy!
    TravelTip.find_by(slug: GUIDE["slug"])&.destroy!
  end

  private

  def add(model, data, **extra)
    if (existing = model.find_by(slug: data["slug"]))
      say "#{data["slug"]}: already exists, skipped"
      return existing
    end

    post = model.create!(
      **data.slice("slug", "title", "excerpt", "meta_title", "meta_description", "body").symbolize_keys,
      **extra,
      published_at: Time.zone.parse(data["published_at"].to_s),
      status: "published"
    )

    if (tour = Tour.find_by(slug: BOOKING_TOUR))
      post.promoted_tours.create!(tour:, label: data["button"])
    else
      say "#{BOOKING_TOUR}: tour not found, #{data["slug"]} saved without a booking button"
    end
    say "#{post.title}: added"
    post
  end
end
