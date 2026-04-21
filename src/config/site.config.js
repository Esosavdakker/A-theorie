export const site = {
  name: "A+theorie",
  tagline: "Slaag voor je theorie-examen!",
  description: "De beste online theorie-opleiding voor rijbewijs B. Leer in je eigen tempo en slaag met zekerheid.",
  url: "https://aplustheorie.nl",
  phone: "+31 6 00 00 00 00",
  email: "info@aplustheorie.nl",
  address: {
    street: "Straatnaam 1",
    city: "Amsterdam",
    postalCode: "1000 AA",
    country: "Nederland",
  },
  social: {
    instagram: "https://instagram.com/aplustheorie",
    facebook: "https://facebook.com/aplustheorie",
    whatsapp: "https://wa.me/31600000000",
  },
  announcement: {
    active: true,
    text: "🎉 Tijdelijk: Gratis proefles bij aanmelding voor het Compleet pakket",
    cta: { label: "Claim nu →", href: "/contact" },
  },
  nav: [
    { label: "Home",       href: "/" },
    { label: "Over Ons",   href: "/over-ons" },
    { label: "Cursussen",  href: "/cursussen" },
    { label: "Prijzen",    href: "/prijzen" },
    { label: "Contact",    href: "/contact" },
  ],
  hero: {
    headline1: "SLAAG IN 1 KEER",
    headline2: "VOOR JE THEORIE",
    ctaPrimary: { label: "Meld je aan", href: "/contact" },
    trust: ["CBR-oefenexamens", "Direct toegang", "Alle apparaten"],
    stats: [
      { icon: "🏆", numericValue: 97,   suffix: "%",  label: "Slagingspercentage" },
      { icon: "⭐", numericValue: 5000, suffix: "+",  label: "Tevreden cursisten" },
      { icon: "🎓", value: "CBR",                    label: "Erkend materiaal"   },
    ],
    socialProof: {
      text: "5.000+ cursisten gingen je voor",
      avatars: 5,
    },
  },
  about: {
    heading: "Online theoriecursus",
    body: "Bij A+theorie maken we het behalen van je CBR theorie-examen eenvoudiger dan ooit. Onze online theoriecursus stoomt je perfect klaar om in één keer te slagen bij het CBR.",
    features: [
      { icon: "✓", text: "CBR-erkend oefenmateriaal" },
      { icon: "✓", text: "Oefen wanneer het jou uitkomt" },
      { icon: "✓", text: "Persoonlijke voortgangsrapportage" },
      { icon: "✓", text: "Altijd bereikbaar voor vragen" },
    ],
  },
  testimonials: [
    {
      name: "Miryam A.",
      rating: 5,
      title: "Aanrader!",
      text: "In één keer geslaagd dankzij de duidelijke uitleg en goede oefenexamens. Echt een aanrader!",
      time: "2 weken geleden",
    },
    {
      name: "Khalil C.",
      rating: 5,
      title: "Top cursus!",
      text: "Top docent en 1x keer geslaagd. Echt aanrader voor iedereen die zijn rijbewijs wil halen.",
      time: "1 maand geleden",
    },
    {
      name: "Sara V.",
      rating: 5,
      title: "Intensief maar waardevol",
      text: "Veel informatie, goede uitleg. Met vertrouwen het examen ingegaan en in één keer geslaagd.",
      time: "3 weken geleden",
    },
  ],
  courses: [
    {
      id: "basis",
      title: "Basis Pakket",
      description: "Ideaal als je al wat kennis hebt en gericht wilt oefenen.",
      includes: [
        "Onbeperkt oefenexamens",
        "Officieel CBR-materiaal",
        "30 dagen toegang",
      ],
      cta: { label: "Kies Basis", href: "/contact" },
    },
    {
      id: "compleet",
      title: "Compleet Pakket",
      description: "Ons meest populaire pakket met alles wat je nodig hebt.",
      includes: [
        "Alles uit Basis",
        "Video-uitleg per onderwerp",
        "90 dagen toegang",
        "E-mail ondersteuning",
      ],
      badge: "Meest gekozen",
      cta: { label: "Kies Compleet", href: "/contact" },
    },
    {
      id: "premium",
      title: "Premium Pakket",
      description: "Maximale ondersteuning voor een zeker slagen.",
      includes: [
        "Alles uit Compleet",
        "1-op-1 telefonische begeleiding",
        "Onbeperkte toegang",
        "Geld-terug-garantie",
      ],
      cta: { label: "Kies Premium", href: "/contact" },
    },
  ],
  pricing: [
    { package: "Basis",    price: "€29", period: "eenmalig" },
    { package: "Compleet", price: "€49", period: "eenmalig", highlight: true },
    { package: "Premium",  price: "€79", period: "eenmalig" },
  ],
  faq: [
    {
      question: "Hoe lang heb ik toegang tot de cursus?",
      answer: "Dit is afhankelijk van het gekozen pakket: 30, 90 of onbeperkte dagen.",
    },
    {
      question: "Is het materiaal CBR-erkend?",
      answer: "Ja, al ons materiaal is gebaseerd op de officiële CBR-leerstof en wordt regelmatig bijgewerkt.",
    },
    {
      question: "Wat als ik zak voor mijn examen?",
      answer: "Premium-cursisten ontvangen volledige restitutie als ze niet slagen. Voor andere pakketten bieden we een herhalingsdeal aan.",
    },
    {
      question: "Kan ik de cursus op mijn telefoon volgen?",
      answer: "Absoluut. Ons platform is volledig responsive en werkt op alle apparaten.",
    },
    {
      question: "Hoe neem ik contact op?",
      answer: "Via het contactformulier, e-mail of WhatsApp. We reageren altijd binnen 24 uur.",
    },
  ],
  cta: {
    heading: "Klaar om in één keer te slagen?",
    body: "Sluit je aan bij 5.000+ cursisten die al hun rijbewijs hebben behaald met A+theorie.",
    button: { label: "Meld je aan", href: "/contact" },
    trust: ["Geen abonnement", "Direct toegang", "Geld-terug garantie"],
  },
  footer: {
    tagline: "Jouw weg naar het rijbewijs begint hier.",
    hours: { weekdays: "Ma–Vr: 09:00–17:00", saturday: "Za: Gesloten", sunday: "Zo: Gesloten" },
    copyright: `© ${new Date().getFullYear()} A+theorie. Alle rechten voorbehouden.`,
  },
};
