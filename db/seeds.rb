require "open-uri"
require "faker"
require "set"

puts "Wipe existing data…"
ActiveRecord::Base.connection.disable_referential_integrity do
  [Comment, Post, Event, User, ActiveStorage::Attachment, ActiveStorage::Blob].each(&:delete_all)
end

puts "Seeding users…"

locations = %w[Zürich Bern Basel Schaffhausen Winterthur]
genders = %w[male female]
gender_prefs = %w[men women both]

first_names = %w[Anna Ben Clara David Elena Felix Greta Hannah Jonas Leonie Mia Noah Olivia Paul Sophie Tim Yannick Zoe]
last_names = %w[Müller Schmidt Schneider Fischer Weber Meyer Wagner Becker Schäfer Koch Bauer Richter Klein Wolf Schröder Neumann Schwarz Zimmermann Braun Krüger Hofmann Hartmann Lange Schmitt Werner Schmitz Krause]

def unique_name(first_names, last_names, used_names)
  loop do
    name = "#{first_names.sample} #{last_names.sample}"
    return name unless used_names.include?(name)
  end
end

used_names = Set.new

50.times do |i|
  gender = genders.sample
  name = unique_name(first_names, last_names, used_names)
  used_names << name
  email = "user#{i+1}@deinprojekt.ch"
  location = locations.sample
  profile_text = Faker::Quote.matz + " " + Faker::Quote.famous_last_words

  user = User.create!(
    name: name,
    email: email,
    password: "password",
    profile_text: profile_text,
    location: location,
    gender: gender,
    show_gender_preferences: gender_prefs.sample
  )

  # Profilbild nach Gender!
  begin
    profile_img_url = "https://randomuser.me/api/portraits/#{gender == 'male' ? 'men' : 'women'}/#{rand(0..99)}.jpg"
    file = URI.open(profile_img_url)
    user.photos.attach(io: file, filename: "profile_user_#{user.id}.jpg", content_type: "image/jpeg")
  rescue
    puts "Profilbild konnte nicht geladen werden für User #{user.id}"
  end

  # 1-2 weitere Bilder von Picsum
  2.times do |img|
    begin
      file = URI.open("https://picsum.photos/seed/#{user.id}-#{img}/600/400")
      user.photos.attach(io: file, filename: "photo#{img+1}_user_#{user.id}.jpg", content_type: "image/jpeg")
    rescue
      puts "Zusatzbild konnte nicht geladen werden für User #{user.id}"
    end
  end
end

puts "Seeding posts…"

news_headlines = [
  { title: "Schweizer Wahlen 2025: Die wichtigsten Ergebnisse", body: "Die nationalen Wahlen haben deutliche Veränderungen im Parlament gebracht. Experten analysieren die Folgen für Umwelt- und Sozialpolitik." },
  { title: "Tech-Gipfel in Zürich: Künstliche Intelligenz im Alltag", body: "Beim diesjährigen Tech-Gipfel präsentierten Startups ihre neuesten KI-Anwendungen. Besonders im Gesundheitswesen sieht man grosses Potenzial." },
  { title: "Basler Fasnacht 2025: Rekordbeteiligung erwartet", body: "Die Organisatoren rechnen mit über 20.000 Teilnehmer*innen und stellen neue Sicherheitskonzepte vor." },
  { title: "Bern: Tram-Ausbau sorgt für Diskussionen", body: "Die Erweiterung des Tramnetzes polarisiert die Bevölkerung. Befürworter betonen Klimaschutz, Kritiker fürchten höhere Kosten." },
  { title: "Winterthur: Nachhaltige Architektur setzt neue Massstäbe", body: "Holzbau und Gründächer prägen das Stadtbild. Experten loben die Innovationskraft der lokalen Unternehmen." },
  { title: "Schaffhausen: Rheinfall feiert Besucherrekord", body: "Mehr als eine Million Menschen besuchten 2025 das Naturwunder. Neue Attraktionen und Gastronomie-Angebote sind geplant." },
  { title: "EU beschliesst strengere Klimaziele bis 2030", body: "Die neuen Richtlinien setzen einen verstärkten Fokus auf erneuerbare Energien und Reduktion des CO₂-Ausstoßes." },
  { title: "Apple veröffentlicht das iPhone 17", body: "Das neue Modell setzt auf Nachhaltigkeit und bietet erstmals eine vollständig recycelbare Hülle." },
  { title: "Digitale Bildung in Schweizer Schulen", body: "Ein neues Förderprogramm stattet Schulen mit Tablets und VR-Technologie aus, um den Unterricht zu modernisieren." },
  { title: "Schweizer Alpen: Lawinenwarnung nach starkem Schneefall", body: "Die Behörden raten zu besonderer Vorsicht und haben mehrere Wanderwege vorübergehend gesperrt." },
  { title: "Erfolgreiche Impfkampagne gegen Grippe in Zürich", body: "Die Kantonsapotheke meldet einen Rekord bei den verabreichten Impfungen." },
  { title: "Start der Fussball EM 2024", body: "Die Schweiz tritt mit einem jungen Team an und setzt auf Offensivfußball." },
  { title: "Forschung: Durchbruch bei Quantencomputern", body: "ETH Zürich meldet eine neue Methode zur Fehlerkorrektur, die die Entwicklung beschleunigen könnte." },
  { title: "Basel: Neuer Stadtteil am Rheinufer geplant", body: "Das Projekt verspricht bezahlbaren Wohnraum und eine innovative Ufergestaltung." },
  { title: "Künstliche Intelligenz erkennt seltene Krankheiten", body: "Eine Zürcher Klinik setzt erfolgreich ein KI-System zur Diagnose von seltenen Erkrankungen ein." },
  { title: "Bern: Gratis-ÖV für alle unter 18", body: "Die Stadtverwaltung testet ein Pilotprojekt zur Förderung nachhaltiger Mobilität." },
  { title: "Winterthur: Start-up gewinnt Innovationspreis", body: "Das junge Unternehmen entwickelt Solarzellen mit rekordverdächtigem Wirkungsgrad." },
  { title: "Schaffhausen: Historisches Museum feiert Jubiläum", body: "Mit einer Sonderausstellung zur Regionalgeschichte lockt das Museum zahlreiche Besucher an." },
  { title: "ETH Zürich eröffnet neues KI-Forschungszentrum", body: "Fokus auf ethische KI-Anwendungen und Zusammenarbeit mit internationalen Partnern." },
  { title: "Bern: Urban Gardening boomt", body: "Immer mehr Stadtbewohner setzen auf eigene Gemüsebeete und nachhaltige Begrünung." },
  { title: "Basel: E-Bike Infrastruktur wächst rasant", body: "Stadtverwaltung investiert in neue Radwege und Ladestationen." },
  { title: "Winterthur: Festival für digitale Kunst", body: "Künstler aus aller Welt präsentieren ihre Werke rund um VR und AR." },
  { title: "Schaffhausen: Wirtschaftskongress zu nachhaltigem Tourismus", body: "Regionale Initiativen stellen neue Konzepte vor." }
]

comment_texts = [
  "Sehr interessante Perspektive! Das könnte die Debatte nachhaltig beeinflussen.",
  "Ich finde besonders den Aspekt zu den Klimazielen spannend – endlich passiert etwas!",
  "Wie beurteilst du die sozialen Folgen dieser Entwicklung?",
  "Danke für die detaillierte Analyse. Wie sieht es mit der Finanzierung aus?",
  "Das erinnert mich an ähnliche Projekte in Skandinavien, dort wurden gute Erfahrungen gemacht.",
  "Ich bin skeptisch, ob das wirklich so nachhaltig ist, wie versprochen.",
  "Gibt es dazu auch eine Stellungnahme aus der Wissenschaft?",
  "Die Digitalisierung der Schulen ist überfällig, aber wie werden die Lehrer unterstützt?",
  "Super, dass die Schweiz bei der EM dabei ist! Hoffentlich halten sie dem Druck stand.",
  "Die Innovation bei Solarzellen ist beeindruckend – könnte das unser Energiemix verändern?",
  "Ich glaube, für die jüngere Generation ist das ein echter Fortschritt.",
  "Viel Erfolg für das neue Stadtteilprojekt! Hoffentlich bleibt Wohnraum bezahlbar.",
  "Lawinenwarnungen sind wichtig, aber werden sie von den Touristen wirklich ernst genommen?",
  "Das KI-System zur Diagnostik ist eine Revolution für die Medizin.",
  "Wie steht die Bevölkerung zu den neuen Impfkampagnen?",
  "Die Museums-Ausstellung klingt spannend! Gibt es eine Führung für Kinder?",
  "Das iPhone 17 mit recycelbarer Hülle ist ein Schritt in die richtige Richtung.",
  "Ich würde mir wünschen, dass auch kleinere Städte von solchen Förderprogrammen profitieren.",
  "Die Organisatoren der Fasnacht leisten großartige Arbeit – Sicherheit geht vor!",
  "Urban Gardening wäre auch für unsere Nachbarschaft eine tolle Idee.",
  "Könnte das neue Forschungszentrum auch internationale Talente nach Zürich bringen?",
  "Wird das Tram-Projekt in Bern wirklich die Verkehrsprobleme lösen?",
  "Hat Basel für die E-Bikes auch ausreichend Sicherheitsmaßnahmen vorgesehen?",
  "Wie integriert Winterthur digitale Kunst in den Alltag der Bürger?",
  "Nachhaltiger Tourismus klingt gut, aber wie sieht es mit den Kosten aus?"
]

User.find_each do |user|
  rand(2..4).times do
    news = news_headlines.sample
    post = user.posts.create!(
      title: "#{news[:title]}",
      body: "#{news[:body]} #{Faker::Quote.yoda} #{Faker::Quote.famous_last_words}"
    )

    rand(2..6).times do
      commenter = User.where.not(id: user.id).sample
      post.comments.create!(
        user: commenter,
        body: comment_texts.sample
      )
    end
  end
end

puts "Seeding events…"

event_types = %i[catsitting dogsitting party dating]
event_titles = [
  "Startup Networking Zürich",
  "Open-Air Konzert in Bern",
  "Basler Herbstmesse",
  "Schaffhauser Weinfest",
  "Winterthur Science Slam",
  "Kunstmarkt Basel",
  "Technologie-Workshop Zürich",
  "Literaturtage Bern",
  "Rheinfall Charity Run",
  "Interkultureller Brunch Winterthur",
  "Familienfest Schaffhausen",
  "Veggie Days Zürich",
  "Boulder-Event Basel",
  "Streetfood Festival Bern",
  "Smart City Symposium Winterthur",
  "Yoga im Park Schaffhausen",
  "Fotografie-Walk Zürich",
  "Urban Gardening Workshop Basel",
  "Spieleabend Bern",
  "Filmnacht Winterthur",
  "Kochkurs Schaffhausen",
  "Sommerparty Zürich",
  "Tanzkurs Basel",
  "Bier-Tasting Bern",
  "Science Café Winterthur"
]

25.times do |i|
  creator = User.order("RANDOM()").first
  event_type = event_types.sample
  date = rand(1..16).weeks.from_now
  location = locations.sample
  description = "#{event_titles[i]}: #{Faker::Lorem.paragraph(sentence_count: 4)}"
  Event.create!(
    title: event_titles[i],
    description: description,
    date: date,
    location: location,
    event_type: event_type,
    creator: creator
  )
end

puts "Seed finished! Created #{User.count} users, #{Post.count} posts, #{Comment.count} comments, #{Event.count} events."