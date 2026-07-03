export const site = {
  name: "A+theorie",
  tagline: "Slaag voor je theorie-examen!",
  description: "De beste online theorie-opleiding voor rijbewijs B. Leer in je eigen tempo en slaag met zekerheid.",
  url: "https://aplustheorie.nl",
  phone: "06 44 79 30 93",
  email: "info@aplustheorie.nl",
  address: {
    street: "Reggestraat 38",
    city: "IJmuiden",
    postalCode: "1972 WL",
    country: "Nederland",
  },
  social: {
    instagram: "https://instagram.com/aplustheorie",
    facebook: "https://facebook.com/aplustheorie",
    whatsapp: "https://wa.me/31644793093",
  },
  nav: [
    { label: "Home",       href: "/" },
    { label: "Over Ons",   href: "/over-ons" },
    { label: "Cursussen",  href: "/cursussen" },
    { label: "Prijzen",    href: "/prijzen" },
    { label: "Contact",    href: "/contact" },
  ],
  hero: {
    headline1: "Jouw theorie-examen,",
    headline2: "in één keer gehaald.",
    ctaPrimary: { label: "Meld je aan", href: "https://aplusplatform.netlify.app/signup" },
    trust: ["CBR-oefenexamens", "Direct toegang", "Alle apparaten"],
    stats: [
      { icon: "🏆", numericValue: 97,   suffix: "%",  label: "Slagingspercentage" },
      { icon: "⭐", numericValue: 100,  suffix: "+",  label: "Tevreden cursisten" },
      { icon: "🎓", value: "CBR",                    label: "Erkend materiaal"   },
    ],
    socialProof: {
      text: "100+ cursisten gingen je voor",
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
      name: "Dylan Lindelauf",
      rating: 5,
      title: "Hartstikke fijn!",
      text: "Ik vond met Alex rijden hartstikke fijn. Ongeveer een halfjaar lang gereden met Alex en heb alles op mijn eigen tempo mogen benaderen. Tijdens het lessen heb ik het ook hartstikke gezellig gehad!",
      time: "5 maanden geleden",
    },
    {
      name: "Jenz Groen",
      rating: 5,
      title: "In 1x geslaagd!",
      text: "De rijinstructeur (Alex) is top, heel fijn om mee op pad te gaan. Als je van een praatje houdt kan dat ook zeker. Legt alles ook goed uit. Ik ben met deze fijne lessen ook in 1x geslaagd — zeker een aanrader!",
      time: "3 maanden geleden",
    },
    {
      name: "Keano C.",
      rating: 5,
      title: "Aanrader!",
      text: "Ik heb goede lessen gehad van Alex. Een superfijne instructeur die duidelijk uitleg geeft en met wie het altijd gezellig is. Bedankt!",
      time: "5 maanden geleden",
    },
    {
      name: "Vigo Jansen",
      rating: 5,
      title: "Rijbewijs in 1 maand",
      text: "Geweldige rijschool. Heb binnen 1 maand mijn rijbewijs gehaald met geweldige hulp van rijinstructeur Alex.",
      time: "4 maanden geleden",
    },
    {
      name: "Danilo Heyman",
      rating: 5,
      title: "Fijn en duidelijk",
      text: "Fijne rustige rijinstructeur. Legt goed en duidelijk uit.",
      time: "2 maanden geleden",
    },
    {
      name: "Google-gebruiker",
      rating: 4,
      title: "Geslaagd na 2 eerdere pogingen",
      text: "Geslaagd 🥳 Eerst 2 keer bij een andere rijschool gezakt. Nu in één keer geslaagd bij Alex.",
      time: "5 maanden geleden",
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
      cta: { label: "Kies Basis", href: "https://aplusplatform.netlify.app/signup" },
    },
    {
      id: "compleet",
      title: "Compleet Pakket",
      description: "Ons meest populaire pakket met alles wat je nodig hebt.",
      includes: [
        "Alles uit Basis",
        "90 dagen toegang",
        "E-mail ondersteuning",
      ],
      badge: "Meest gekozen",
      cta: { label: "Kies Compleet", href: "https://aplusplatform.netlify.app/signup" },
    },
  ],
  pricing: [
    { package: "Basis",    price: "€29", period: "eenmalig" },
    { package: "Compleet", price: "€49", period: "eenmalig", highlight: true },
  ],
  faq: [
    {
      question: "Hoe lang heb ik toegang tot de cursus?",
      answer: "Dit is afhankelijk van het gekozen pakket.",
    },
    {
      question: "Is het materiaal CBR-erkend?",
      answer: "Ja, al ons materiaal is gebaseerd op de officiële CBR-leerstof en wordt regelmatig bijgewerkt.",
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
    body: "Sluit je aan bij 100+ cursisten die al hun rijbewijs hebben behaald met A+theorie.",
    button: { label: "Meld je aan", href: "https://aplusplatform.netlify.app/signup" },
    trust: ["Geen abonnement", "Direct toegang"],
  },
  footer: {
    tagline: "Jouw weg naar het rijbewijs begint hier.",
    hours: { weekdays: "Ma–Za: 09:00–22:00", sunday: "Zo: 09:00–17:00" },
    copyright: `© ${new Date().getFullYear()} AkkerDigital. Alle rechten voorbehouden.`,
  },
};

