puts "Wipe existing comments…"
Comment.delete_all

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

users = User.all

puts "Adding comments to posts…"
Post.find_each do |post|
  rand(2..6).times do
    commenter = users.where.not(id: post.user_id).sample
    Comment.create!(
      user: commenter,
      body: comment_texts.sample,
      commentable: post
    )
  end
end

puts "Adding comments to events…"
Event.find_each do |event|
  rand(2..6).times do
    commenter = users.where.not(id: event.creator_id).sample
    Comment.create!(
      user: commenter,
      body: comment_texts.sample,
      commentable: event
    )
  end
end

puts "Comment seeding finished! Jetzt gibt es #{Comment.count} Kommentare."