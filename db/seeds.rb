Event.destroy_all

Event.create!([
  { title: "Cat sitting in Berlin", description: "Looking after a lovely cat 🐱", date: 3.days.from_now, location: "Berlin", event_type: :catsitting, creator: User.first },
  { title: "Dog walking meetup", description: "Dog owners meetup 🐶", date: 5.days.from_now, location: "Hamburg", event_type: :dogsitting, creator: User.first },
  { title: "House Party", description: "Bring your own drinks 🍻", date: 1.week.from_now, location: "Cologne", event_type: :party, creator: User.first },
  { title: "Speed Dating", description: "Meet new people 💞", date: 2.weeks.from_now, location: "Munich", event_type: :dating, creator: User.first }
])