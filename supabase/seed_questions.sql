-- ============================================================================
-- A+theorie — Seed: 100 theory questions + options
-- Run AFTER supabase/migrations/0001_init.sql (needs categories seeded).
-- Idempotent-ish: clears prior seeded questions by matching stems is hard,
-- so only run on a fresh DB, or truncate questions/question_options first.
-- All questions are inserted as status='published'.
-- ============================================================================

-- q001
with q as (
  insert into public.questions (category_id, type, stem, explanation, difficulty, status)
  select id, 'single', 'Wat is binnen de bebouwde kom de maximumsnelheid voor een personenauto, als er geen borden staan die iets anders aangeven?', 'Binnen de bebouwde kom geldt standaard een maximumsnelheid van 50 km/u. Steeds vaker geldt op woonstraten 30 km/u, maar dat moet dan met borden zijn aangegeven.', 1, 'published'
  from public.categories where slug = 'verkeersregels'
  returning id
)
insert into public.question_options (question_id, label, is_correct, sort_order)
select q.id, v.label, v.is_correct, v.ord from q,
  (values
      ('30 km/u', false, 0),
      ('50 km/u', true, 1),
      ('60 km/u', false, 2)
  ) as v(label, is_correct, ord);

-- q002
with q as (
  insert into public.questions (category_id, type, stem, explanation, difficulty, status)
  select id, 'single', 'Je rijdt buiten de bebouwde kom op een gewone provinciale weg (N-weg) zonder snelheidsborden. Wat is de maximumsnelheid?', 'Buiten de bebouwde kom geldt op gewone wegen standaard 80 km/u. Op een autoweg geldt 100 km/u en op een autosnelweg gelden eigen regels.', 1, 'published'
  from public.categories where slug = 'verkeersregels'
  returning id
)
insert into public.question_options (question_id, label, is_correct, sort_order)
select q.id, v.label, v.is_correct, v.ord from q,
  (values
      ('60 km/u', false, 0),
      ('80 km/u', true, 1),
      ('100 km/u', false, 2)
  ) as v(label, is_correct, ord);

-- q003
with q as (
  insert into public.questions (category_id, type, stem, explanation, difficulty, status)
  select id, 'single', 'Wat is op een autosnelweg de maximumsnelheid voor een personenauto tussen 06:00 en 19:00 uur, als er geen ander bord staat?', 'Sinds 2020 geldt overdag (06:00-19:00 uur) op de autosnelweg standaard 100 km/u. Buiten die uren geldt de snelheid die op de borden staat (vaak 120 of 130 km/u).', 2, 'published'
  from public.categories where slug = 'verkeersregels'
  returning id
)
insert into public.question_options (question_id, label, is_correct, sort_order)
select q.id, v.label, v.is_correct, v.ord from q,
  (values
      ('100 km/u', true, 0),
      ('120 km/u', false, 1),
      ('130 km/u', false, 2)
  ) as v(label, is_correct, ord);

-- q004
with q as (
  insert into public.questions (category_id, type, stem, explanation, difficulty, status)
  select id, 'single', 'Wat is de maximumsnelheid op een autoweg (aangegeven met het bord met een witte auto op blauwe achtergrond)?', 'Op een autoweg mag je maximaal 100 km/u rijden, tenzij borden een lagere snelheid aangeven.', 1, 'published'
  from public.categories where slug = 'verkeersregels'
  returning id
)
insert into public.question_options (question_id, label, is_correct, sort_order)
select q.id, v.label, v.is_correct, v.ord from q,
  (values
      ('80 km/u', false, 0),
      ('100 km/u', true, 1),
      ('130 km/u', false, 2)
  ) as v(label, is_correct, ord);

-- q005
with q as (
  insert into public.questions (category_id, type, stem, explanation, difficulty, status)
  select id, 'single', 'Je hebt sinds 1 jaar je rijbewijs en bent dus een beginnend bestuurder. Welk alcoholpromillage mag je maximaal hebben?', 'Voor beginnende bestuurders (de eerste 5 jaar na het halen van het rijbewijs) geldt een limiet van 0,2 promille. Voor ervaren bestuurders is dit 0,5 promille.', 2, 'published'
  from public.categories where slug = 'verkeersregels'
  returning id
)
insert into public.question_options (question_id, label, is_correct, sort_order)
select q.id, v.label, v.is_correct, v.ord from q,
  (values
      ('0,0 promille', false, 0),
      ('0,2 promille', true, 1),
      ('0,5 promille', false, 2)
  ) as v(label, is_correct, ord);

-- q006
with q as (
  insert into public.questions (category_id, type, stem, explanation, difficulty, status)
  select id, 'single', 'Welk maximaal alcoholpromillage geldt voor een ervaren bestuurder (langer dan 5 jaar in het bezit van het rijbewijs)?', 'Voor ervaren bestuurders geldt een wettelijke limiet van 0,5 promille. Toch is het altijd veiliger om helemaal geen alcohol te drinken als je gaat rijden (BOB).', 1, 'published'
  from public.categories where slug = 'verkeersregels'
  returning id
)
insert into public.question_options (question_id, label, is_correct, sort_order)
select q.id, v.label, v.is_correct, v.ord from q,
  (values
      ('0,2 promille', false, 0),
      ('0,5 promille', true, 1),
      ('0,8 promille', false, 2)
  ) as v(label, is_correct, ord);

-- q007
with q as (
  insert into public.questions (category_id, type, stem, explanation, difficulty, status)
  select id, 'single', 'Je nadert een kruising van twee gelijkwaardige wegen. Van rechts komt tegelijk een auto aan. Wie moet voorrang verlenen?', 'Op een gelijkwaardige kruising verleen je voorrang aan bestuurders die van rechts komen. Dit geldt voor alle bestuurders, dus ook fietsers en brommers.', 2, 'published'
  from public.categories where slug = 'verkeersregels'
  returning id
)
insert into public.question_options (question_id, label, is_correct, sort_order)
select q.id, v.label, v.is_correct, v.ord from q,
  (values
      ('Jij verleent voorrang aan de auto van rechts', true, 0),
      ('De auto van rechts verleent voorrang aan jou', false, 1),
      ('Wie het eerst bij de kruising is, mag eerst', false, 2)
  ) as v(label, is_correct, ord);

-- q008
with q as (
  insert into public.questions (category_id, type, stem, explanation, difficulty, status)
  select id, 'single', 'Een voetganger staat duidelijk te wachten bij een zebrapad (voetgangersoversteekplaats). Wat moet je doen?', 'Bestuurders moeten voetgangers en bestuurders van een gehandicaptenvoertuig die op een zebrapad oversteken of duidelijk op het punt staan over te steken, voor laten gaan.', 1, 'published'
  from public.categories where slug = 'verkeersregels'
  returning id
)
insert into public.question_options (question_id, label, is_correct, sort_order)
select q.id, v.label, v.is_correct, v.ord from q,
  (values
      ('Voetgangers op een zebrapad voor laten gaan', true, 0),
      ('Doorrijden, voetgangers moeten wachten', false, 1),
      ('Alleen stoppen als de voetganger een hand opsteekt', false, 2)
  ) as v(label, is_correct, ord);

-- q009
with q as (
  insert into public.questions (category_id, type, stem, explanation, difficulty, status)
  select id, 'single', 'Een tram en jij naderen tegelijk een kruising. In welke situatie moet je een tram NIET altijd voorrang geven?', 'Op een gelijkwaardige kruising moet je een tram altijd voorrang geven, ook als die van links komt. Bij borden, haaientanden of verkeerslichten geldt de gewone voorrangsregeling wel ook voor de tram.', 2, 'published'
  from public.categories where slug = 'verkeersregels'
  returning id
)
insert into public.question_options (question_id, label, is_correct, sort_order)
select q.id, v.label, v.is_correct, v.ord from q,
  (values
      ('Als jij voorrang hebt volgens borden of verkeerslichten geldt dat ook voor de tram', false, 0),
      ('Een tram heeft op een gelijkwaardige kruising voorrang, ook van links', true, 1),
      ('Een tram heeft nooit voorrang', false, 2)
  ) as v(label, is_correct, ord);

-- q010
with q as (
  insert into public.questions (category_id, type, stem, explanation, difficulty, status)
  select id, 'single', 'Waar rijdt een bromfiets (blauw kenteken, maximaal 45 km/u) binnen de bebouwde kom, als er geen apart bromfietspad is?', 'Binnen de bebouwde kom rijdt een bromfietser op de rijbaan, tenzij er een verplicht bromfietspad is. Buiten de bebouwde kom rijdt de bromfiets juist op het fiets/bromfietspad.', 2, 'published'
  from public.categories where slug = 'verkeersregels'
  returning id
)
insert into public.question_options (question_id, label, is_correct, sort_order)
select q.id, v.label, v.is_correct, v.ord from q,
  (values
      ('Op het fietspad', false, 0),
      ('Op de rijbaan, tussen het overige verkeer', true, 1),
      ('Op het trottoir', false, 2)
  ) as v(label, is_correct, ord);

-- q011
with q as (
  insert into public.questions (category_id, type, stem, explanation, difficulty, status)
  select id, 'single', 'Wat betekent een doorgetrokken streep in het midden van de weg?', 'Een doorgetrokken streep mag je niet overschrijden en je mag er ook niet op rijden. Een onderbroken streep mag je wel overschrijden, bijvoorbeeld om in te halen.', 2, 'published'
  from public.categories where slug = 'verkeersregels'
  returning id
)
insert into public.question_options (question_id, label, is_correct, sort_order)
select q.id, v.label, v.is_correct, v.ord from q,
  (values
      ('Je mag de streep niet overschrijden of erop rijden', true, 0),
      ('Je mag de streep alleen overschrijden om in te halen', false, 1),
      ('De streep geeft alleen het midden van de weg aan en mag je negeren', false, 2)
  ) as v(label, is_correct, ord);

-- q012
with q as (
  insert into public.questions (category_id, type, stem, explanation, difficulty, status)
  select id, 'single', 'Wat betekenen haaientanden (driehoekjes) op het wegdek?', 'Haaientanden betekenen dat je voorrang moet verlenen aan bestuurders op de kruisende weg. Je hoeft niet per se te stoppen, dat moet alleen bij een STOP-bord.', 2, 'published'
  from public.categories where slug = 'verkeersregels'
  returning id
)
insert into public.question_options (question_id, label, is_correct, sort_order)
select q.id, v.label, v.is_correct, v.ord from q,
  (values
      ('Je moet voorrang verlenen aan bestuurders op de kruisende weg', true, 0),
      ('Je hebt voorrang op de kruisende weg', false, 1),
      ('Je moet altijd volledig stoppen', false, 2)
  ) as v(label, is_correct, ord);

-- q013
with q as (
  insert into public.questions (category_id, type, stem, explanation, difficulty, status)
  select id, 'single', 'Je nadert een verkeerslicht dat op geel (oranje) springt. Wat is de juiste handelwijze?', 'Geel betekent: stoppen. Alleen als je zo dicht bij het verkeerslicht bent dat je niet meer veilig kunt stoppen, mag je doorrijden.', 1, 'published'
  from public.categories where slug = 'verkeersregels'
  returning id
)
insert into public.question_options (question_id, label, is_correct, sort_order)
select q.id, v.label, v.is_correct, v.ord from q,
  (values
      ('Stoppen, tenzij je zo dicht bij het licht bent dat veilig stoppen niet meer kan', true, 0),
      ('Altijd doorrijden, geel betekent doorrijden', false, 1),
      ('Altijd hard remmen, ongeacht je positie', false, 2)
  ) as v(label, is_correct, ord);

-- q014
with q as (
  insert into public.questions (category_id, type, stem, explanation, difficulty, status)
  select id, 'single', 'Wat betekent een knipperend geel verkeerslicht?', 'Een knipperend geel licht betekent dat de verkeerslichten niet in werking zijn. Je let dan op borden, haaientanden of de regel ''voorrang aan verkeer van rechts''.', 2, 'published'
  from public.categories where slug = 'verkeersregels'
  returning id
)
insert into public.question_options (question_id, label, is_correct, sort_order)
select q.id, v.label, v.is_correct, v.ord from q,
  (values
      ('Het verkeerslicht is buiten werking; de normale voorrangsregels gelden', true, 0),
      ('Je hebt altijd voorrang', false, 1),
      ('Je moet altijd stoppen', false, 2)
  ) as v(label, is_correct, ord);

-- q015
with q as (
  insert into public.questions (category_id, type, stem, explanation, difficulty, status)
  select id, 'single', 'Je verlaat een rotonde. Moet je richting aangeven?', 'Bij het verlaten van de rotonde geef je richting aan naar rechts, zodat andere weggebruikers weten dat je de rotonde af gaat. Bij het oprijden geef je geen richting aan als je rechtdoor of de eerste afslag neemt.', 2, 'published'
  from public.categories where slug = 'verkeersregels'
  returning id
)
insert into public.question_options (question_id, label, is_correct, sort_order)
select q.id, v.label, v.is_correct, v.ord from q,
  (values
      ('Ja, je geeft richting aan (rechts) bij het verlaten van de rotonde', true, 0),
      ('Nee, op een rotonde hoef je nooit richting aan te geven', false, 1),
      ('Alleen als er verkeer achter je rijdt', false, 2)
  ) as v(label, is_correct, ord);

-- q016
with q as (
  insert into public.questions (category_id, type, stem, explanation, difficulty, status)
  select id, 'single', 'Een voorrangsvoertuig (politie, brandweer of ambulance) nadert met zwaailicht én sirene. Wat doe je?', 'Een voorrangsvoertuig met zwaailicht en sirene moet je voor laten gaan. Maak rustig en veilig ruimte, ga zo nodig opzij of stop, maar veroorzaak geen gevaarlijke situatie.', 2, 'published'
  from public.categories where slug = 'verkeersregels'
  returning id
)
insert into public.question_options (question_id, label, is_correct, sort_order)
select q.id, v.label, v.is_correct, v.ord from q,
  (values
      ('Ruimte maken en zo nodig veilig stoppen om het voertuig voor te laten gaan', true, 0),
      ('Gewoon doorrijden met je eigen snelheid', false, 1),
      ('Direct vol in de remmen, midden op de weg', false, 2)
  ) as v(label, is_correct, ord);

-- q017
with q as (
  insert into public.questions (category_id, type, stem, explanation, difficulty, status)
  select id, 'single', 'Binnen de bebouwde kom geeft een lijnbus bij een halte richting aan om weg te rijden. Wat moet je doen?', 'Binnen de bebouwde kom moet je een lijnbus die vanaf een halte wegrijdt en richting aangeeft, voor laten gaan. Buiten de bebouwde kom geldt deze regel niet.', 2, 'published'
  from public.categories where slug = 'verkeersregels'
  returning id
)
insert into public.question_options (question_id, label, is_correct, sort_order)
select q.id, v.label, v.is_correct, v.ord from q,
  (values
      ('De bus voor laten gaan en je snelheid aanpassen', true, 0),
      ('Snel langs de bus rijden voordat hij wegrijdt', false, 1),
      ('Toeteren zodat de bus blijft staan', false, 2)
  ) as v(label, is_correct, ord);

-- q018
with q as (
  insert into public.questions (category_id, type, stem, explanation, difficulty, status)
  select id, 'single', 'Wat betekent een rond blauw bord met een witte pijl recht naar boven?', 'Ronde blauwe borden met een pijl geven een verplichte rijrichting aan (gebodsborden). Hier is dat: rechtdoor.', 1, 'published'
  from public.categories where slug = 'verkeersregels'
  returning id
)
insert into public.question_options (question_id, label, is_correct, sort_order)
select q.id, v.label, v.is_correct, v.ord from q,
  (values
      ('Gebod om rechtdoor te rijden', true, 0),
      ('Verbod om rechtdoor te rijden', false, 1),
      ('Aanbevolen rijrichting, je mag ook anders', false, 2)
  ) as v(label, is_correct, ord);

-- q019
with q as (
  insert into public.questions (category_id, type, stem, explanation, difficulty, status)
  select id, 'single', 'Wat betekent een rond rood-wit bord (witte balk op rood) — het ''C1''-bord?', 'Het C1-bord (rond, rood met een witte horizontale balk) betekent: gesloten in beide richtingen. Je mag deze weg niet in rijden.', 1, 'published'
  from public.categories where slug = 'verkeersregels'
  returning id
)
insert into public.question_options (question_id, label, is_correct, sort_order)
select q.id, v.label, v.is_correct, v.ord from q,
  (values
      ('Gesloten in beide richtingen voor voertuigen, ruiters en geleiders van vee', true, 0),
      ('Eenrichtingsverkeer', false, 1),
      ('Verboden in te halen', false, 2)
  ) as v(label, is_correct, ord);

-- q020
with q as (
  insert into public.questions (category_id, type, stem, explanation, difficulty, status)
  select id, 'single', 'Wat is het verschil tussen een gele doorgetrokken streep en een gele onderbroken streep langs de rand van de rijbaan?', 'Een gele doorgetrokken streep betekent een stopverbod (je mag er niet stilstaan). Een gele onderbroken streep betekent een parkeerverbod (stilstaan om in/uit te stappen mag wel).', 2, 'published'
  from public.categories where slug = 'verkeersregels'
  returning id
)
insert into public.question_options (question_id, label, is_correct, sort_order)
select q.id, v.label, v.is_correct, v.ord from q,
  (values
      ('Doorgetrokken = verbod om stil te staan; onderbroken = verbod om te parkeren', true, 0),
      ('Doorgetrokken = verbod om te parkeren; onderbroken = verbod om stil te staan', false, 1),
      ('Beide betekenen precies hetzelfde', false, 2)
  ) as v(label, is_correct, ord);

-- q021
with q as (
  insert into public.questions (category_id, type, stem, explanation, difficulty, status)
  select id, 'single', 'Mag je parkeren binnen 5 meter van een kruispunt?', 'Parkeren binnen 5 meter van een kruispunt is verboden. Hierdoor houden bestuurders voldoende overzicht op de kruising.', 2, 'published'
  from public.categories where slug = 'verkeersregels'
  returning id
)
insert into public.question_options (question_id, label, is_correct, sort_order)
select q.id, v.label, v.is_correct, v.ord from q,
  (values
      ('Nee, parkeren binnen 5 meter van een kruispunt is verboden', true, 0),
      ('Ja, dat mag altijd', false, 1),
      ('Alleen overdag verboden', false, 2)
  ) as v(label, is_correct, ord);

-- q022
with q as (
  insert into public.questions (category_id, type, stem, explanation, difficulty, status)
  select id, 'single', 'Wat betekent een blauw bord met een witte ''P'' en daaronder het symbool van een parkeerschijf?', 'Dit is een blauwe zone. Je mag er parkeren met een parkeerschijf waarop je aankomsttijd staat, voor de aangegeven maximale tijd.', 2, 'published'
  from public.categories where slug = 'verkeersregels'
  returning id
)
insert into public.question_options (question_id, label, is_correct, sort_order)
select q.id, v.label, v.is_correct, v.ord from q,
  (values
      ('Parkeren is toegestaan, maar je moet een parkeerschijf gebruiken', true, 0),
      ('Hier mag je nooit parkeren', false, 1),
      ('Hier mag je gratis en onbeperkt parkeren', false, 2)
  ) as v(label, is_correct, ord);

-- q023
with q as (
  insert into public.questions (category_id, type, stem, explanation, difficulty, status)
  select id, 'single', 'Je nadert een STOP-bord (achthoekig rood bord). Wat moet je doen?', 'Bij een STOP-bord moet je altijd volledig stilstaan vóór de stopstreep, ook als er geen ander verkeer is. Daarna verleen je voorrang aan het kruisende verkeer.', 1, 'published'
  from public.categories where slug = 'verkeersregels'
  returning id
)
insert into public.question_options (question_id, label, is_correct, sort_order)
select q.id, v.label, v.is_correct, v.ord from q,
  (values
      ('Volledig stilstaan vóór de stopstreep en voorrang verlenen', true, 0),
      ('Alleen langzamer rijden en doorrijden als het kan', false, 1),
      ('Alleen stoppen als er ander verkeer is', false, 2)
  ) as v(label, is_correct, ord);

-- q024
with q as (
  insert into public.questions (category_id, type, stem, explanation, difficulty, status)
  select id, 'single', 'Wat betekent een rond blauw bord met de witte letters/symbolen die de bebouwde kom aangeven (komborden)?', 'Het kombord geeft het begin van de bebouwde kom aan. Vanaf dat punt geldt standaard 50 km/u en gelden de regels voor de bebouwde kom (bijvoorbeeld over parkeren en bussen).', 1, 'published'
  from public.categories where slug = 'verkeersregels'
  returning id
)
insert into public.question_options (question_id, label, is_correct, sort_order)
select q.id, v.label, v.is_correct, v.ord from q,
  (values
      ('Vanaf hier geldt de bebouwde kom: standaard 50 km/u en bijbehorende parkeerregels', true, 0),
      ('Einde bebouwde kom', false, 1),
      ('Alleen een plaatsnaam, zonder gevolgen voor de regels', false, 2)
  ) as v(label, is_correct, ord);

-- q025
with q as (
  insert into public.questions (category_id, type, stem, explanation, difficulty, status)
  select id, 'single', 'Mag je een file op de invoegstrook bij wijze van ritsen om en om laten invoegen?', 'Bij een rijstrook die ophoudt, rits je om en om in: het verkeer voegt zo laat mogelijk, vlak voor het einde van de strook, beurtelings in. Dit zorgt voor een betere doorstroming.', 2, 'published'
  from public.categories where slug = 'verkeersregels'
  returning id
)
insert into public.question_options (question_id, label, is_correct, sort_order)
select q.id, v.label, v.is_correct, v.ord from q,
  (values
      ('Ja, ritsen (om en om invoegen) gebeurt zo laat mogelijk bij het einde van de strook', true, 0),
      ('Nee, je moet altijd zo vroeg mogelijk invoegen', false, 1),
      ('Ritsen mag alleen buiten de spits', false, 2)
  ) as v(label, is_correct, ord);

-- q026
with q as (
  insert into public.questions (category_id, type, stem, explanation, difficulty, status)
  select id, 'single', 'Wat betekent een rond rood bord met daarin een rode auto en een zwarte auto naast elkaar?', 'Dit bord (twee auto''s naast elkaar, waarvan één rood) betekent een inhaalverbod voor motorvoertuigen. Het geldt tot een bord ''einde inhaalverbod'' of tot het volgende kruispunt.', 2, 'published'
  from public.categories where slug = 'verkeersregels'
  returning id
)
insert into public.question_options (question_id, label, is_correct, sort_order)
select q.id, v.label, v.is_correct, v.ord from q,
  (values
      ('Verboden in te halen', true, 0),
      ('Verplicht in te halen', false, 1),
      ('Einde inhaalverbod', false, 2)
  ) as v(label, is_correct, ord);

-- q027
with q as (
  insert into public.questions (category_id, type, stem, explanation, difficulty, status)
  select id, 'single', 'Mag je rechts inhalen?', 'Inhalen doe je in principe links. Rechts ''voorbijrijden'' mag wel in bepaalde situaties, zoals bij filevorming, bij bestuurders die naar links voorsorteren, en op wegen met rijstroken die door pijlen of strepen zijn gescheiden.', 2, 'published'
  from public.categories where slug = 'verkeersregels'
  returning id
)
insert into public.question_options (question_id, label, is_correct, sort_order)
select q.id, v.label, v.is_correct, v.ord from q,
  (values
      ('In principe haal je links in; rechts inhalen mag o.a. bij file, op rijstroken met pijlen en bij voorsorterend verkeer', true, 0),
      ('Rechts inhalen mag altijd en overal', false, 1),
      ('Rechts inhalen is in geen enkele situatie toegestaan', false, 2)
  ) as v(label, is_correct, ord);

-- q028
with q as (
  insert into public.questions (category_id, type, stem, explanation, difficulty, status)
  select id, 'truefalse', 'Stelling: Het is verboden om tijdens het rijden een mobiele telefoon vast te houden.', 'Het is verboden om tijdens het rijden een mobiel elektronisch apparaat zoals een telefoon vast te houden. Bellen of navigeren mag alleen handsfree, bijvoorbeeld via een houder.', 1, 'published'
  from public.categories where slug = 'verkeersregels'
  returning id
)
insert into public.question_options (question_id, label, is_correct, sort_order)
select q.id, v.label, v.is_correct, v.ord from q,
  (values
      ('Waar', true, 0),
      ('Niet waar', false, 1)
  ) as v(label, is_correct, ord);

-- q029
with q as (
  insert into public.questions (category_id, type, stem, explanation, difficulty, status)
  select id, 'single', 'Wanneer mag je een mistlamp achter gebruiken?', 'De mistlamp achter mag je alleen aanzetten als het zicht minder is dan 50 meter door mist, sneeuw of zware regen. Bij beter zicht verblindt hij het achteropkomende verkeer en is hij verboden.', 2, 'published'
  from public.categories where slug = 'verkeersregels'
  returning id
)
insert into public.question_options (question_id, label, is_correct, sort_order)
select q.id, v.label, v.is_correct, v.ord from q,
  (values
      ('Alleen als het zicht door mist, sneeuw of regen minder is dan 50 meter', true, 0),
      ('Altijd ''s nachts', false, 1),
      ('Altijd als het regent', false, 2)
  ) as v(label, is_correct, ord);

-- q030
with q as (
  insert into public.questions (category_id, type, stem, explanation, difficulty, status)
  select id, 'single', 'Welke lichten gebruik je overdag bij goed zicht binnen de bebouwde kom (verplicht of toegestaan)?', 'Overdag mag je dagrijlicht of dimlicht voeren. Groot licht (grootlicht) gebruik je alleen in het donker buiten de bebouwde kom als er geen ander verkeer wordt verblind.', 1, 'published'
  from public.categories where slug = 'verkeersregels'
  returning id
)
insert into public.question_options (question_id, label, is_correct, sort_order)
select q.id, v.label, v.is_correct, v.ord from q,
  (values
      ('Dimlicht of dagrijlicht', true, 0),
      ('Altijd groot licht', false, 1),
      ('Altijd mistlampen voor', false, 2)
  ) as v(label, is_correct, ord);

-- q031
with q as (
  insert into public.questions (category_id, type, stem, explanation, difficulty, status)
  select id, 'single', 'Wat betekent een verdrijvingsvlak (gearceerd vlak met witte strepen) op de weg?', 'Een verdrijvingsvlak scheidt rijstromen. Je rijdt er zo min mogelijk op of overheen. Als het vlak door doorgetrokken strepen wordt begrensd, mag je er helemaal niet op of overheen rijden.', 2, 'published'
  from public.categories where slug = 'verkeersregels'
  returning id
)
insert into public.question_options (question_id, label, is_correct, sort_order)
select q.id, v.label, v.is_correct, v.ord from q,
  (values
      ('Je moet het vlak zoveel mogelijk vermijden; erop of eroverheen rijden mag alleen als het echt nodig is en veilig kan', true, 0),
      ('Hier mag je parkeren', false, 1),
      ('Dit is een extra rijstrook die je vrij mag gebruiken', false, 2)
  ) as v(label, is_correct, ord);

-- q032
with q as (
  insert into public.questions (category_id, type, stem, explanation, difficulty, status)
  select id, 'single', 'Je wilt rechtsaf slaan op een kruising. Waar let je vooral op?', 'Bij rechtsaf slaan moet je goed letten op (brom)fietsers die rechtdoor gaan en zich rechts naast of achter je kunnen bevinden (dode hoek). Zij gaan voor.', 2, 'published'
  from public.categories where slug = 'verkeersregels'
  returning id
)
insert into public.question_options (question_id, label, is_correct, sort_order)
select q.id, v.label, v.is_correct, v.ord from q,
  (values
      ('Op fietsers en bromfietsers die rechtdoor gaan en rechts naast of achter je rijden', true, 0),
      ('Alleen op tegemoetkomend verkeer', false, 1),
      ('Nergens speciaal op, rechtsaf is altijd veilig', false, 2)
  ) as v(label, is_correct, ord);

-- q033
with q as (
  insert into public.questions (category_id, type, stem, explanation, difficulty, status)
  select id, 'single', 'Wat geeft een onderbord (rechthoekig wit bordje onder een verkeersbord) aan?', 'Een onderbord geeft extra informatie bij het hoofdbord, bijvoorbeeld op welke tijden of voor welke voertuigen het bord geldt, of over welke afstand.', 1, 'published'
  from public.categories where slug = 'verkeersregels'
  returning id
)
insert into public.question_options (question_id, label, is_correct, sort_order)
select q.id, v.label, v.is_correct, v.ord from q,
  (values
      ('Een aanvulling of beperking op het bord erboven', true, 0),
      ('Een geheel los bord zonder verband met het bord erboven', false, 1),
      ('Altijd een snelheidslimiet', false, 2)
  ) as v(label, is_correct, ord);

-- q034
with q as (
  insert into public.questions (category_id, type, stem, explanation, difficulty, status)
  select id, 'single', 'Je nadert een gelijkwaardige kruising en wilt linksaf slaan. Er komt verkeer recht tegemoet. Wie gaat voor?', 'Bij linksaf slaan moet je tegemoetkomend verkeer dat rechtdoor gaat of rechtsaf slaat voor laten gaan. Je kruist immers hun rijrichting.', 2, 'published'
  from public.categories where slug = 'verkeersregels'
  returning id
)
insert into public.question_options (question_id, label, is_correct, sort_order)
select q.id, v.label, v.is_correct, v.ord from q,
  (values
      ('Het tegemoetkomende verkeer dat rechtdoor gaat of rechtsaf slaat, gaat voor', true, 0),
      ('Jij gaat voor omdat je linksaf slaat', false, 1),
      ('Wie het hardst rijdt, gaat voor', false, 2)
  ) as v(label, is_correct, ord);

-- q035
with q as (
  insert into public.questions (category_id, type, stem, explanation, difficulty, status)
  select id, 'single', 'Wat betekent een omgekeerde driehoek (punt naar beneden) als verkeersbord, het bord ''B6''?', 'De omgekeerde driehoek (B6) betekent: voorrang verlenen aan bestuurders op de kruisende weg. Vaak liggen er ook haaientanden op het wegdek.', 1, 'published'
  from public.categories where slug = 'verkeersregels'
  returning id
)
insert into public.question_options (question_id, label, is_correct, sort_order)
select q.id, v.label, v.is_correct, v.ord from q,
  (values
      ('Verleen voorrang aan bestuurders op de kruisende weg', true, 0),
      ('Je hebt voorrang', false, 1),
      ('Verboden in te rijden', false, 2)
  ) as v(label, is_correct, ord);

-- q036
with q as (
  insert into public.questions (category_id, type, stem, explanation, difficulty, status)
  select id, 'single', 'Welke vuistregel gebruik je voor een veilige volgafstand achter je voorganger bij droog weer?', 'Met de 2-secondenregel houd je voldoende afstand: als je voorganger een vast punt passeert, moet jij dat punt pas minstens 2 seconden later bereiken. Bij slecht weer of gladheid neem je meer afstand.', 2, 'published'
  from public.categories where slug = 'verkeersinzicht'
  returning id
)
insert into public.question_options (question_id, label, is_correct, sort_order)
select q.id, v.label, v.is_correct, v.ord from q,
  (values
      ('De 2-secondenregel', true, 0),
      ('De 0,5-secondenregel', false, 1),
      ('Altijd precies 10 meter', false, 2)
  ) as v(label, is_correct, ord);

-- q037
with q as (
  insert into public.questions (category_id, type, stem, explanation, difficulty, status)
  select id, 'single', 'Hoe verandert je totale stopafstand als je snelheid hoger wordt?', 'De reactieafstand neemt recht evenredig toe met de snelheid, maar de remweg neemt kwadratisch toe. Bij dubbele snelheid is de remweg dus ongeveer vier keer zo lang. Daarom is snelheid zo bepalend voor je stopafstand.', 2, 'published'
  from public.categories where slug = 'verkeersinzicht'
  returning id
)
insert into public.question_options (question_id, label, is_correct, sort_order)
select q.id, v.label, v.is_correct, v.ord from q,
  (values
      ('De remweg wordt sterker langer dan de snelheidstoename: bij dubbele snelheid wordt de remweg ongeveer vier keer zo lang', true, 0),
      ('De stopafstand blijft gelijk', false, 1),
      ('Bij dubbele snelheid wordt de remweg precies twee keer zo lang', false, 2)
  ) as v(label, is_correct, ord);

-- q038
with q as (
  insert into public.questions (category_id, type, stem, explanation, difficulty, status)
  select id, 'single', 'Wat is ''reactietijd'' en hoe lang duurt die gemiddeld bij een oplettende bestuurder?', 'De reactietijd is de tijd tussen het waarnemen van een gevaar en het daadwerkelijk reageren (remmen). Die is gemiddeld ongeveer 1 seconde, maar wordt langer door vermoeidheid, afleiding of alcohol.', 2, 'published'
  from public.categories where slug = 'verkeersinzicht'
  returning id
)
insert into public.question_options (question_id, label, is_correct, sort_order)
select q.id, v.label, v.is_correct, v.ord from q,
  (values
      ('De tijd tussen het zien van het gevaar en het beginnen met remmen; gemiddeld ongeveer 1 seconde', true, 0),
      ('De tijd die de auto nodig heeft om stil te staan; ongeveer 5 seconden', false, 1),
      ('De tijd om de motor te starten; ongeveer 2 seconden', false, 2)
  ) as v(label, is_correct, ord);

-- q039
with q as (
  insert into public.questions (category_id, type, stem, explanation, difficulty, status)
  select id, 'single', 'Wat is aquaplaning?', 'Bij aquaplaning kan het water niet snel genoeg worden afgevoerd en ''drijft'' de band op een laag water. Je verliest grip. Voorkom dit door snelheid te minderen bij veel water en je banden op spanning en profiel te houden.', 2, 'published'
  from public.categories where slug = 'verkeersinzicht'
  returning id
)
insert into public.question_options (question_id, label, is_correct, sort_order)
select q.id, v.label, v.is_correct, v.ord from q,
  (values
      ('De banden verliezen door een laag water het contact met het wegdek, waardoor sturen en remmen niet meer werken', true, 0),
      ('Het beslaan van de ruiten bij regen', false, 1),
      ('Het slippen van de banden door olie op de weg', false, 2)
  ) as v(label, is_correct, ord);

-- q040
with q as (
  insert into public.questions (category_id, type, stem, explanation, difficulty, status)
  select id, 'single', 'Je rijdt naast een vrachtwagen die rechtsaf wil slaan. Waarom is dit gevaarlijk?', 'Naast en rechts vóór een vrachtwagen ligt een grote dode hoek. Een afslaande vrachtwagen kan je over het hoofd zien. Blijf uit de dode hoek of zorg dat je oogcontact hebt met de chauffeur.', 2, 'published'
  from public.categories where slug = 'verkeersinzicht'
  returning id
)
insert into public.question_options (question_id, label, is_correct, sort_order)
select q.id, v.label, v.is_correct, v.ord from q,
  (values
      ('Je kunt in de dode hoek van de vrachtwagen rijden, waar de chauffeur je niet ziet', true, 0),
      ('Vrachtwagens hebben altijd voorrang, dus jij moet remmen', false, 1),
      ('Er is geen gevaar, de chauffeur ziet alles via de spiegels', false, 2)
  ) as v(label, is_correct, ord);

-- q041
with q as (
  insert into public.questions (category_id, type, stem, explanation, difficulty, status)
  select id, 'single', 'Je nadert een onoverzichtelijke bocht naar rechts. Wanneer pas je je snelheid aan?', 'Je remt vóór de bocht af tot een snelheid waarbij je veilig door de bocht kunt. In de bocht zelf remmen vermindert je grip en kan je laten slippen. Pas na de bocht trek je weer op.', 2, 'published'
  from public.categories where slug = 'verkeersinzicht'
  returning id
)
insert into public.question_options (question_id, label, is_correct, sort_order)
select q.id, v.label, v.is_correct, v.ord from q,
  (values
      ('Vóór de bocht afremmen, in de bocht gelijkmatig sturen en daarna weer optrekken', true, 0),
      ('In de bocht hard remmen', false, 1),
      ('Pas snelheid aanpassen als je iets ziet aankomen', false, 2)
  ) as v(label, is_correct, ord);

-- q042
with q as (
  insert into public.questions (category_id, type, stem, explanation, difficulty, status)
  select id, 'single', 'Voordat je van rijstrook wisselt, in welke volgorde kijk je het beste?', 'Goede kijktechniek: eerst spiegels, dan een schouderblik voor de dode hoek, richting aangeven en pas daarna rustig van rijstrook wisselen. Zo verras je geen verkeer dat je niet in de spiegel zag.', 1, 'published'
  from public.categories where slug = 'verkeersinzicht'
  returning id
)
insert into public.question_options (question_id, label, is_correct, sort_order)
select q.id, v.label, v.is_correct, v.ord from q,
  (values
      ('Binnenspiegel, buitenspiegel, dode hoek (schouderblik), richting aangeven, dan pas wisselen', true, 0),
      ('Alleen even in de buitenspiegel kijken', false, 1),
      ('Eerst van rijstrook wisselen, dan kijken', false, 2)
  ) as v(label, is_correct, ord);

-- q043
with q as (
  insert into public.questions (category_id, type, stem, explanation, difficulty, status)
  select id, 'single', 'Waarom is anticiperen (vooruitkijken en voorspellen) belangrijk in het verkeer?', 'Door ver vooruit te kijken en situaties in te schatten, herken je gevaar eerder. Je hoeft dan minder vaak hard te remmen, rijdt zuiniger en veiliger en hebt meer tijd om te reageren.', 2, 'published'
  from public.categories where slug = 'verkeersinzicht'
  returning id
)
insert into public.question_options (question_id, label, is_correct, sort_order)
select q.id, v.label, v.is_correct, v.ord from q,
  (values
      ('Je herkent gevaar eerder en kunt rustiger en veiliger reageren', true, 0),
      ('Je kunt harder rijden', false, 1),
      ('Het is alleen handig op de snelweg', false, 2)
  ) as v(label, is_correct, ord);

-- q044
with q as (
  insert into public.questions (category_id, type, stem, explanation, difficulty, status)
  select id, 'single', 'Je nadert een school rond schooltijd. Wat is verstandig?', 'Kinderen zijn onvoorspelbaar en overzien het verkeer nog niet goed. Rond scholen verminder je je snelheid en houd je rekening met plotseling overstekende of stilstaande kinderen.', 2, 'published'
  from public.categories where slug = 'verkeersinzicht'
  returning id
)
insert into public.question_options (question_id, label, is_correct, sort_order)
select q.id, v.label, v.is_correct, v.ord from q,
  (values
      ('Snelheid minderen en extra alert zijn op overstekende kinderen', true, 0),
      ('Je snelheid behouden, kinderen kijken zelf wel uit', false, 1),
      ('Toeteren zodat kinderen wegblijven', false, 2)
  ) as v(label, is_correct, ord);

-- q045
with q as (
  insert into public.questions (category_id, type, stem, explanation, difficulty, status)
  select id, 'single', 'In de herfst liggen er natte bladeren op de weg. Welk effect heeft dit?', 'Natte bladeren maken het wegdek glad, vergelijkbaar met ijzel. Je grip neemt af en je remweg wordt langer. Pas je snelheid aan en houd meer afstand.', 2, 'published'
  from public.categories where slug = 'verkeersinzicht'
  returning id
)
insert into public.question_options (question_id, label, is_correct, sort_order)
select q.id, v.label, v.is_correct, v.ord from q,
  (values
      ('De weg kan glad zijn; je remweg wordt langer en je grip minder', true, 0),
      ('Geen effect, bladeren zijn ongevaarlijk', false, 1),
      ('De weg wordt juist stroever', false, 2)
  ) as v(label, is_correct, ord);

-- q046
with q as (
  insert into public.questions (category_id, type, stem, explanation, difficulty, status)
  select id, 'single', 'Je wilt op een 80 km/u-weg een trekker (landbouwvoertuig) inhalen. Wat is het belangrijkste dat je moet inschatten?', 'Inhalen kost veel ruimte en tijd, zeker bij een groot snelheidsverschil. Je moet de afstand én de snelheid van tegemoetkomend verkeer goed inschatten en alleen inhalen als je voldoende zicht en vrije ruimte hebt.', 3, 'published'
  from public.categories where slug = 'verkeersinzicht'
  returning id
)
insert into public.question_options (question_id, label, is_correct, sort_order)
select q.id, v.label, v.is_correct, v.ord from q,
  (values
      ('Of er voldoende vrije ruimte en zicht is, en hoe snel eventueel tegemoetkomend verkeer nadert', true, 0),
      ('Alleen of de trekker richting aangeeft', false, 1),
      ('Alleen je eigen snelheid', false, 2)
  ) as v(label, is_correct, ord);

-- q047
with q as (
  insert into public.questions (category_id, type, stem, explanation, difficulty, status)
  select id, 'single', 'Waarom is oogcontact maken met andere weggebruikers nuttig?', 'Oogcontact helpt je inschatten of de ander jou heeft opgemerkt, bijvoorbeeld bij een voetganger die wil oversteken of een automobilist die wil invoegen. Het vervangt echter nooit het verlenen van voorrang volgens de regels.', 2, 'published'
  from public.categories where slug = 'verkeersinzicht'
  returning id
)
insert into public.question_options (question_id, label, is_correct, sort_order)
select q.id, v.label, v.is_correct, v.ord from q,
  (values
      ('Je weet beter of de ander jou heeft gezien en wat hij waarschijnlijk gaat doen', true, 0),
      ('Het is wettelijk verplicht bij elke kruising', false, 1),
      ('Het heeft geen nut', false, 2)
  ) as v(label, is_correct, ord);

-- q048
with q as (
  insert into public.questions (category_id, type, stem, explanation, difficulty, status)
  select id, 'single', 'Je merkt dat je tijdens een lange rit vermoeid raakt. Wat is de beste oplossing?', 'Vermoeidheid verlengt je reactietijd sterk en is een belangrijke oorzaak van ongevallen. De enige echte oplossing is rust nemen. Een raam openzetten of muziek helpt maar heel even.', 2, 'published'
  from public.categories where slug = 'verkeersinzicht'
  returning id
)
insert into public.question_options (question_id, label, is_correct, sort_order)
select q.id, v.label, v.is_correct, v.ord from q,
  (values
      ('Stoppen op een veilige plek en rust nemen (pauze, eventueel kort slapen)', true, 0),
      ('Harder rijden om sneller thuis te zijn', false, 1),
      ('Het raam openzetten en gewoon doorrijden, dat is genoeg', false, 2)
  ) as v(label, is_correct, ord);

-- q049
with q as (
  insert into public.questions (category_id, type, stem, explanation, difficulty, status)
  select id, 'single', 'Je rijdt op de snelweg en wilt invoegen vanaf de invoegstrook. Wat is de juiste techniek?', 'Op de invoegstrook breng je je snelheid op die van het verkeer op de rechterrijstrook. Zo kun je soepel in een gat invoegen zonder dat anderen hard moeten remmen. Stilstaan op de invoegstrook is gevaarlijk.', 2, 'published'
  from public.categories where slug = 'verkeersinzicht'
  returning id
)
insert into public.question_options (question_id, label, is_correct, sort_order)
select q.id, v.label, v.is_correct, v.ord from q,
  (values
      ('Snelheid aanpassen aan het verkeer op de rijbaan, een gat zoeken en soepel invoegen', true, 0),
      ('Aan het eind van de strook vol stilstaan en wachten', false, 1),
      ('Met lage snelheid invoegen en het overige verkeer laten remmen', false, 2)
  ) as v(label, is_correct, ord);

-- q050
with q as (
  insert into public.questions (category_id, type, stem, explanation, difficulty, status)
  select id, 'single', 'Waarom houd je bij het passeren van een file op de andere weghelft of naast je toch afstand en aandacht?', 'Bij stilstaand of langzaam rijdend verkeer kunnen mensen tussen auto''s door oversteken, portieren opengaan of voertuigen plotseling uitvoegen. Houd daarom afstand en je snelheid laag.', 2, 'published'
  from public.categories where slug = 'verkeersinzicht'
  returning id
)
insert into public.question_options (question_id, label, is_correct, sort_order)
select q.id, v.label, v.is_correct, v.ord from q,
  (values
      ('Uit een file kunnen onverwacht voetgangers, deuren of voertuigen komen', true, 0),
      ('Dat hoeft niet, een file is altijd veilig', false, 1),
      ('Alleen omdat het netjes is', false, 2)
  ) as v(label, is_correct, ord);

-- q051
with q as (
  insert into public.questions (category_id, type, stem, explanation, difficulty, status)
  select id, 'single', 'Je ziet ver vooruit dat een verkeerslicht al lang op groen staat. Wat is een verstandige gedachte?', 'Een ''oud'' groen licht (dat al lang groen is) springt waarschijnlijk snel op geel. Door dit te anticiperen voorkom je dat je moet kiezen tussen hard remmen of door rood rijden.', 2, 'published'
  from public.categories where slug = 'verkeersinzicht'
  returning id
)
insert into public.question_options (question_id, label, is_correct, sort_order)
select q.id, v.label, v.is_correct, v.ord from q,
  (values
      ('Het licht kan zo op geel springen; ik anticipeer en ben klaar om te stoppen', true, 0),
      ('Het blijft vast groen, ik geef extra gas', false, 1),
      ('Ik sluit mijn ogen voor de zekerheid', false, 2)
  ) as v(label, is_correct, ord);

-- q052
with q as (
  insert into public.questions (category_id, type, stem, explanation, difficulty, status)
  select id, 'single', 'Een geparkeerde auto vóór je heeft de remlichten uit, maar de uitlaat dampt en de wielen staan iets gedraaid. Wat kun je hieruit afleiden?', 'Aanwijzingen zoals een draaiende motor, brandende lichten of gedraaide wielen kunnen betekenen dat een auto gaat wegrijden. Door deze signalen te lezen, anticipeer je op wat er kan gebeuren.', 2, 'published'
  from public.categories where slug = 'verkeersinzicht'
  returning id
)
insert into public.question_options (question_id, label, is_correct, sort_order)
select q.id, v.label, v.is_correct, v.ord from q,
  (values
      ('De auto kan elk moment wegrijden; ik houd er rekening mee', true, 0),
      ('De auto blijft zeker staan', false, 1),
      ('Dit zegt niets, ik rijd gewoon door zonder op te letten', false, 2)
  ) as v(label, is_correct, ord);

-- q053
with q as (
  insert into public.questions (category_id, type, stem, explanation, difficulty, status)
  select id, 'single', 'Waarom is bumperkleven (te kort op je voorganger rijden) gevaarlijk?', 'Bij te weinig afstand kun je bij plotseling remmen van je voorganger niet op tijd stoppen, met een kop-staartbotsing als gevolg. Houd minimaal de 2-secondenregel aan.', 1, 'published'
  from public.categories where slug = 'verkeersinzicht'
  returning id
)
insert into public.question_options (question_id, label, is_correct, sort_order)
select q.id, v.label, v.is_correct, v.ord from q,
  (values
      ('Je hebt te weinig tijd en ruimte om te reageren als je voorganger plotseling remt', true, 0),
      ('Het is alleen onbeleefd, maar niet gevaarlijk', false, 1),
      ('Het is juist veiliger want je ziet je voorganger goed', false, 2)
  ) as v(label, is_correct, ord);

-- q054
with q as (
  insert into public.questions (category_id, type, stem, explanation, difficulty, status)
  select id, 'single', 'Je nadert in het donker een tegenligger met groot licht. Wat doe je om verblinding te beperken?', 'Kijk bij verblinding naar de rechterkant van je rijstrook (bijvoorbeeld de wegmarkering) in plaats van in de lichten, en minder zo nodig snelheid. Zelf dimmen helpt ook de tegenligger.', 2, 'published'
  from public.categories where slug = 'verkeersinzicht'
  returning id
)
insert into public.question_options (question_id, label, is_correct, sort_order)
select q.id, v.label, v.is_correct, v.ord from q,
  (values
      ('Niet recht in de koplampen kijken maar naar de rechterkant van je rijstrook, en snelheid zo nodig minderen', true, 0),
      ('Zelf ook groot licht aanzetten en aanlaten', false, 1),
      ('Je ogen sluiten tot je hem gepasseerd bent', false, 2)
  ) as v(label, is_correct, ord);

-- q055
with q as (
  insert into public.questions (category_id, type, stem, explanation, difficulty, status)
  select id, 'single', 'Een bal rolt vanaf het trottoir de weg op. Wat is het grootste gevaar dat je verwacht?', 'Achter een bal komt vaak een kind. Door dit te anticiperen rem je af en ben je voorbereid, zodat je op tijd kunt stoppen als er inderdaad een kind de weg op rent.', 2, 'published'
  from public.categories where slug = 'verkeersinzicht'
  returning id
)
insert into public.question_options (question_id, label, is_correct, sort_order)
select q.id, v.label, v.is_correct, v.ord from q,
  (values
      ('Dat er een kind achter de bal aan de weg op rent', true, 0),
      ('Niets, een bal is licht en ongevaarlijk', false, 1),
      ('Dat je band lek raakt', false, 2)
  ) as v(label, is_correct, ord);

-- q056
with q as (
  insert into public.questions (category_id, type, stem, explanation, difficulty, status)
  select id, 'single', 'Wat bedoelen we met ''defensief rijden''?', 'Defensief rijden betekent dat je anticipeert op fouten van anderen, voldoende afstand en marge houdt en niet je gelijk afdwingt. Zo voorkom je ongevallen, ook als een ander een fout maakt.', 3, 'published'
  from public.categories where slug = 'verkeersinzicht'
  returning id
)
insert into public.question_options (question_id, label, is_correct, sort_order)
select q.id, v.label, v.is_correct, v.ord from q,
  (values
      ('Rekening houden met fouten van anderen en daar je rijgedrag op aanpassen', true, 0),
      ('Zo hard mogelijk rijden om uit gevaarlijke situaties te blijven', false, 1),
      ('Altijd je recht opeisen in het verkeer', false, 2)
  ) as v(label, is_correct, ord);

-- q057
with q as (
  insert into public.questions (category_id, type, stem, explanation, difficulty, status)
  select id, 'single', 'Je rijdt achter een fietser op een smalle weg. Er is tegemoetkomend verkeer. Wat doe je?', 'Je passeert een fietser pas als je voldoende ruimte hebt (richtlijn: ongeveer 1,5 meter zijwaarts). Bij tegemoetkomend verkeer wacht je rustig tot het veilig kan.', 2, 'published'
  from public.categories where slug = 'verkeersinzicht'
  returning id
)
insert into public.question_options (question_id, label, is_correct, sort_order)
select q.id, v.label, v.is_correct, v.ord from q,
  (values
      ('Wachten achter de fietser tot je met voldoende ruimte (minstens ongeveer 1,5 m) veilig kunt passeren', true, 0),
      ('Direct passeren, ook al moet de fietser opzij', false, 1),
      ('Toeteren zodat de fietser van de weg gaat', false, 2)
  ) as v(label, is_correct, ord);

-- q058
with q as (
  insert into public.questions (category_id, type, stem, explanation, difficulty, status)
  select id, 'single', 'Het is glad door ijzel. Hoe pas je je rijstijl aan?', 'Bij gladheid heb je veel minder grip. Rijd rustig, vergroot je afstand fors en bedien alles (gas, rem, stuur) zo soepel mogelijk om slippen te voorkomen.', 2, 'published'
  from public.categories where slug = 'verkeersinzicht'
  returning id
)
insert into public.question_options (question_id, label, is_correct, sort_order)
select q.id, v.label, v.is_correct, v.ord from q,
  (values
      ('Rustiger rijden, meer afstand houden en zacht remmen, sturen en optrekken', true, 0),
      ('Hard remmen om te testen of het glad is', false, 1),
      ('Niets aanpassen, moderne auto''s slippen niet', false, 2)
  ) as v(label, is_correct, ord);

-- q059
with q as (
  insert into public.questions (category_id, type, stem, explanation, difficulty, status)
  select id, 'single', 'Waarom geef je op tijd richting aan?', 'Richting aangeven is communicatie: het laat anderen op tijd weten wat je van plan bent, zodat zij erop kunnen reageren. Geef het op tijd en niet te laat aan.', 2, 'published'
  from public.categories where slug = 'verkeersinzicht'
  returning id
)
insert into public.question_options (question_id, label, is_correct, sort_order)
select q.id, v.label, v.is_correct, v.ord from q,
  (values
      ('Zodat andere weggebruikers je bedoeling op tijd weten en daarop kunnen anticiperen', true, 0),
      ('Alleen omdat het anders een boete oplevert', false, 1),
      ('Richting aangeven is eigenlijk niet nodig', false, 2)
  ) as v(label, is_correct, ord);

-- q060
with q as (
  insert into public.questions (category_id, type, stem, explanation, difficulty, status)
  select id, 'single', 'Je nadert een onbewaakte spoorwegovergang (alleen een Andreaskruis, geen bomen of lichten). Wat doe je?', 'Bij een onbewaakte overgang moet je zelf goed opletten: minder snelheid, kijk beide kanten op en steek pas over als je zeker weet dat er geen trein nadert. Stop nooit op het spoor zelf.', 3, 'published'
  from public.categories where slug = 'verkeersinzicht'
  returning id
)
insert into public.question_options (question_id, label, is_correct, sort_order)
select q.id, v.label, v.is_correct, v.ord from q,
  (values
      ('Snelheid minderen, goed naar links en rechts kijken en alleen oversteken als het veilig is', true, 0),
      ('Zonder te kijken oversteken, er rijdt vast geen trein', false, 1),
      ('Op het spoor stoppen om te kijken', false, 2)
  ) as v(label, is_correct, ord);

-- q061
with q as (
  insert into public.questions (category_id, type, stem, explanation, difficulty, status)
  select id, 'single', 'Je rijdt 50 km/u in een woonstraat. Tussen twee geparkeerde auto''s stapt een klein kind onverwacht de weg op, vlak voor je. Wat doe je?', 'Het kind is dichtbij en steekt direct over: dit is een acuut gevaar. Je remt krachtig om een aanrijding te voorkomen.', 2, 'published'
  from public.categories where slug = 'gevaarherkenning'
  returning id
)
insert into public.question_options (question_id, label, is_correct, sort_order)
select q.id, v.label, v.is_correct, v.ord from q,
  (values
      ('Remmen', true, 0),
      ('Gas loslaten', false, 1),
      ('Niets doen', false, 2)
  ) as v(label, is_correct, ord);

-- q062
with q as (
  insert into public.questions (category_id, type, stem, explanation, difficulty, status)
  select id, 'single', 'Je rijdt op een 80 km/u-weg. Ver vooruit zie je een tegenligger die begint in te halen en op jouw weghelft komt. Wat doe je als eerste?', 'Een tegenligger op jouw weghelft is levensgevaarlijk. Rem af en wijk zo nodig naar rechts uit om ruimte te maken en de klap te voorkomen.', 2, 'published'
  from public.categories where slug = 'gevaarherkenning'
  returning id
)
insert into public.question_options (question_id, label, is_correct, sort_order)
select q.id, v.label, v.is_correct, v.ord from q,
  (values
      ('Remmen', true, 0),
      ('Gas loslaten', false, 1),
      ('Niets doen', false, 2)
  ) as v(label, is_correct, ord);

-- q063
with q as (
  insert into public.questions (category_id, type, stem, explanation, difficulty, status)
  select id, 'single', 'Je rijdt 50 km/u. Verderop staat een voetganger bij een zebrapad, maar hij kijkt op zijn telefoon en stapt nog niet de weg op. Wat doe je?', 'Er is nog geen acuut gevaar, maar de voetganger kan elk moment oversteken. Door gas los te laten verlaag je je snelheid en sta je klaar om te remmen als hij de weg op stapt.', 2, 'published'
  from public.categories where slug = 'gevaarherkenning'
  returning id
)
insert into public.question_options (question_id, label, is_correct, sort_order)
select q.id, v.label, v.is_correct, v.ord from q,
  (values
      ('Gas loslaten', true, 0),
      ('Remmen', false, 1),
      ('Niets doen', false, 2)
  ) as v(label, is_correct, ord);

-- q064
with q as (
  insert into public.questions (category_id, type, stem, explanation, difficulty, status)
  select id, 'single', 'Je rijdt op een rustige weg met 50 km/u. Ver vooruit steekt een voetganger over die de overkant ruim haalt voordat jij er bent. Verder is de weg vrij. Wat doe je?', 'De voetganger is ruim weg voordat je er bent en er is geen ander gevaar. Je kunt rustig je snelheid behouden; remmen of versnellen is niet nodig.', 2, 'published'
  from public.categories where slug = 'gevaarherkenning'
  returning id
)
insert into public.question_options (question_id, label, is_correct, sort_order)
select q.id, v.label, v.is_correct, v.ord from q,
  (values
      ('Niets doen', true, 0),
      ('Hard remmen', false, 1),
      ('Gas geven om er snel langs te zijn', false, 2)
  ) as v(label, is_correct, ord);

-- q065
with q as (
  insert into public.questions (category_id, type, stem, explanation, difficulty, status)
  select id, 'single', 'Je nadert een kruising met 50 km/u. Van rechts komt een fietser die geen aanstalten maakt om te stoppen en voorrang lijkt te nemen. Wat doe je?', 'Een fietser van rechts die doorrijdt vormt een direct risico op een aanrijding op de kruising. Rem zodat je hem voor kunt laten gaan en een botsing voorkomt.', 2, 'published'
  from public.categories where slug = 'gevaarherkenning'
  returning id
)
insert into public.question_options (question_id, label, is_correct, sort_order)
select q.id, v.label, v.is_correct, v.ord from q,
  (values
      ('Remmen', true, 0),
      ('Gas loslaten', false, 1),
      ('Niets doen', false, 2)
  ) as v(label, is_correct, ord);

-- q066
with q as (
  insert into public.questions (category_id, type, stem, explanation, difficulty, status)
  select id, 'single', 'Je rijdt achter een lijnbus binnen de bebouwde kom. De bus staat bij een halte en geeft links richting aan om weg te rijden. Wat doe je?', 'Binnen de bebouwde kom moet je de bus voor laten gaan. Laat gas los, verminder snelheid en geef de bus de ruimte om weg te rijden.', 2, 'published'
  from public.categories where slug = 'gevaarherkenning'
  returning id
)
insert into public.question_options (question_id, label, is_correct, sort_order)
select q.id, v.label, v.is_correct, v.ord from q,
  (values
      ('Gas loslaten', true, 0),
      ('Gas geven en er snel langs', false, 1),
      ('Niets doen en met dezelfde snelheid passeren', false, 2)
  ) as v(label, is_correct, ord);

-- q067
with q as (
  insert into public.questions (category_id, type, stem, explanation, difficulty, status)
  select id, 'single', 'Je rijdt 50 km/u langs geparkeerde auto''s. Bij een auto vóór je gaan plotseling de remlichten uit en de bestuurder draait zijn hoofd om. Wat doe je?', 'De signalen wijzen erop dat de auto kan wegrijden of dat een portier opengaat. Laat gas los zodat je snelheid daalt en je direct kunt remmen als dat nodig is.', 3, 'published'
  from public.categories where slug = 'gevaarherkenning'
  returning id
)
insert into public.question_options (question_id, label, is_correct, sort_order)
select q.id, v.label, v.is_correct, v.ord from q,
  (values
      ('Gas loslaten', true, 0),
      ('Gas geven', false, 1),
      ('Niets doen', false, 2)
  ) as v(label, is_correct, ord);

-- q068
with q as (
  insert into public.questions (category_id, type, stem, explanation, difficulty, status)
  select id, 'single', 'Je rijdt op een 30 km/u-weg. Een hond rent zonder lijn de weg op, vlak voor je auto. Wat doe je?', 'De hond is vlakbij en steekt direct over; bovendien kan de eigenaar achter het dier aan komen. Rem om een aanrijding te voorkomen.', 2, 'published'
  from public.categories where slug = 'gevaarherkenning'
  returning id
)
insert into public.question_options (question_id, label, is_correct, sort_order)
select q.id, v.label, v.is_correct, v.ord from q,
  (values
      ('Remmen', true, 0),
      ('Gas loslaten', false, 1),
      ('Niets doen', false, 2)
  ) as v(label, is_correct, ord);

-- q069
with q as (
  insert into public.questions (category_id, type, stem, explanation, difficulty, status)
  select id, 'single', 'Je rijdt 80 km/u buiten de bebouwde kom. Een fietser op het fietspad naast de weg zwalkt en kijkt om. Hij is nog op ruime afstand. Wat doe je?', 'Een zwalkende, omkijkende fietser is onvoorspelbaar en kan zomaar de rijbaan op komen. Laat gas los zodat je snelheid daalt en je klaarstaat om te remmen of uit te wijken.', 2, 'published'
  from public.categories where slug = 'gevaarherkenning'
  returning id
)
insert into public.question_options (question_id, label, is_correct, sort_order)
select q.id, v.label, v.is_correct, v.ord from q,
  (values
      ('Gas loslaten', true, 0),
      ('Niets doen', false, 1),
      ('Toeteren en doorrijden', false, 2)
  ) as v(label, is_correct, ord);

-- q070
with q as (
  insert into public.questions (category_id, type, stem, explanation, difficulty, status)
  select id, 'single', 'Je rijdt op een rechte snelweg met 100 km/u. De auto''s ver vooruit gaan plotseling allemaal remmen (remlichten lichten op). Wat doe je?', 'Veel remlichten vooruit wijzen op een file of stilstaand verkeer. Rem tijdig en geleidelijk om afstand te houden en een kop-staartbotsing te voorkomen; zet zo nodig je alarmlichten aan.', 2, 'published'
  from public.categories where slug = 'gevaarherkenning'
  returning id
)
insert into public.question_options (question_id, label, is_correct, sort_order)
select q.id, v.label, v.is_correct, v.ord from q,
  (values
      ('Remmen', true, 0),
      ('Gas loslaten en afwachten', false, 1),
      ('Niets doen', false, 2)
  ) as v(label, is_correct, ord);

-- q071
with q as (
  insert into public.questions (category_id, type, stem, explanation, difficulty, status)
  select id, 'single', 'Je rijdt 50 km/u in een straat met aan beide kanten geparkeerde auto''s. Tussen de auto''s door zie je de benen van een voetganger die op het punt staat over te steken. Wat doe je?', 'De voetganger is nog niet op de rijbaan, maar staat klaar om over te steken. Laat gas los om snelheid te verminderen, zodat je kunt remmen zodra hij zichtbaar wordt en oversteekt.', 3, 'published'
  from public.categories where slug = 'gevaarherkenning'
  returning id
)
insert into public.question_options (question_id, label, is_correct, sort_order)
select q.id, v.label, v.is_correct, v.ord from q,
  (values
      ('Gas loslaten', true, 0),
      ('Niets doen', false, 1),
      ('Versnellen om er langs te zijn', false, 2)
  ) as v(label, is_correct, ord);

-- q072
with q as (
  insert into public.questions (category_id, type, stem, explanation, difficulty, status)
  select id, 'single', 'Je rijdt op een ruime, lege weg met 50 km/u. Vooruit is alles overzichtelijk en vrij, geen voetgangers, fietsers of kruisingen. Wat doe je?', 'Er is geen waarneembaar gevaar. Je houdt je snelheid en blijft vooruitkijken. Onnodig remmen of gas loslaten kan juist verwarrend zijn voor het verkeer achter je.', 2, 'published'
  from public.categories where slug = 'gevaarherkenning'
  returning id
)
insert into public.question_options (question_id, label, is_correct, sort_order)
select q.id, v.label, v.is_correct, v.ord from q,
  (values
      ('Niets doen', true, 0),
      ('Remmen', false, 1),
      ('Gas loslaten', false, 2)
  ) as v(label, is_correct, ord);

-- q073
with q as (
  insert into public.questions (category_id, type, stem, explanation, difficulty, status)
  select id, 'single', 'Je nadert met 50 km/u een kruising waar het verkeerslicht voor jou groen is, maar van rechts komt een ambulance met zwaailicht en sirene aan. Wat doe je?', 'Ook al heb je groen, een voorrangsvoertuig moet je voor laten gaan. Rem en stop zo nodig om de ambulance vrije doorgang te geven.', 3, 'published'
  from public.categories where slug = 'gevaarherkenning'
  returning id
)
insert into public.question_options (question_id, label, is_correct, sort_order)
select q.id, v.label, v.is_correct, v.ord from q,
  (values
      ('Remmen', true, 0),
      ('Niets doen, want je hebt groen', false, 1),
      ('Gas geven om snel weg te zijn', false, 2)
  ) as v(label, is_correct, ord);

-- q074
with q as (
  insert into public.questions (category_id, type, stem, explanation, difficulty, status)
  select id, 'single', 'Je rijdt 50 km/u en ziet ver vooruit een vrachtwagen die achteruit een inrit in wil steken en de weg blokkeert. Hij staat nog stil met alarmlichten aan. Wat doe je?', 'De situatie kan snel veranderen als de vrachtwagen gaat manoeuvreren. Laat gas los om snelheid te minderen en houd in de gaten of je moet stoppen of veilig kunt passeren.', 2, 'published'
  from public.categories where slug = 'gevaarherkenning'
  returning id
)
insert into public.question_options (question_id, label, is_correct, sort_order)
select q.id, v.label, v.is_correct, v.ord from q,
  (values
      ('Gas loslaten', true, 0),
      ('Niets doen', false, 1),
      ('Versnellen om er nog langs te kunnen', false, 2)
  ) as v(label, is_correct, ord);

-- q075
with q as (
  insert into public.questions (category_id, type, stem, explanation, difficulty, status)
  select id, 'single', 'Je rijdt 50 km/u. Een voetbal stuitert vanaf links de weg op, vlak voor je auto. Wat doe je?', 'Achter de bal kan een kind de weg op rennen, en de bal is vlakbij. Rem direct zodat je kunt stoppen voor een eventueel overstekend kind.', 3, 'published'
  from public.categories where slug = 'gevaarherkenning'
  returning id
)
insert into public.question_options (question_id, label, is_correct, sort_order)
select q.id, v.label, v.is_correct, v.ord from q,
  (values
      ('Remmen', true, 0),
      ('Gas loslaten', false, 1),
      ('Niets doen', false, 2)
  ) as v(label, is_correct, ord);

-- q076
with q as (
  insert into public.questions (category_id, type, stem, explanation, difficulty, status)
  select id, 'single', 'Je rijdt 80 km/u en nadert een file die net is ontstaan; de laatste auto''s staan stil op jouw rijstrook, redelijk dichtbij. Wat doe je?', 'Stilstaand verkeer dichtbij vraagt om direct remmen om een kop-staartbotsing te voorkomen. Zet daarbij zo nodig je alarmlichten aan om het achteropkomende verkeer te waarschuwen.', 2, 'published'
  from public.categories where slug = 'gevaarherkenning'
  returning id
)
insert into public.question_options (question_id, label, is_correct, sort_order)
select q.id, v.label, v.is_correct, v.ord from q,
  (values
      ('Remmen', true, 0),
      ('Gas loslaten', false, 1),
      ('Niets doen', false, 2)
  ) as v(label, is_correct, ord);

-- q077
with q as (
  insert into public.questions (category_id, type, stem, explanation, difficulty, status)
  select id, 'single', 'Je rijdt 50 km/u langs een rij geparkeerde auto''s. Bij een auto verderop lichten de achteruitrijlichten (witte lichten) op. Wat doe je?', 'Witte achteruitrijlichten betekenen dat de auto achteruit de parkeerplek uit wil. Laat gas los, verminder snelheid en wees klaar om te stoppen.', 2, 'published'
  from public.categories where slug = 'gevaarherkenning'
  returning id
)
insert into public.question_options (question_id, label, is_correct, sort_order)
select q.id, v.label, v.is_correct, v.ord from q,
  (values
      ('Gas loslaten', true, 0),
      ('Niets doen', false, 1),
      ('Versnellen', false, 2)
  ) as v(label, is_correct, ord);

-- q078
with q as (
  insert into public.questions (category_id, type, stem, explanation, difficulty, status)
  select id, 'single', 'Je rijdt 30 km/u in een drukke winkelstraat. Een voetganger stapt vlak voor je auto onverwacht de weg op zonder te kijken. Wat doe je?', 'De voetganger is vlakbij en steekt direct over: acuut gevaar. Rem krachtig om een aanrijding te voorkomen.', 3, 'published'
  from public.categories where slug = 'gevaarherkenning'
  returning id
)
insert into public.question_options (question_id, label, is_correct, sort_order)
select q.id, v.label, v.is_correct, v.ord from q,
  (values
      ('Remmen', true, 0),
      ('Gas loslaten', false, 1),
      ('Niets doen', false, 2)
  ) as v(label, is_correct, ord);

-- q079
with q as (
  insert into public.questions (category_id, type, stem, explanation, difficulty, status)
  select id, 'single', 'Je rijdt 80 km/u op een weg met bomen langs de kant. Het waait hard en je ziet vooruit dat takken en bladeren over de weg waaien. Verder is de weg vrij. Wat doe je?', 'Bij harde wind kunnen takken op de weg vallen en kan je auto opzij worden geduwd. Laat gas los om je snelheid te verlagen en houd je stuur goed vast.', 2, 'published'
  from public.categories where slug = 'gevaarherkenning'
  returning id
)
insert into public.question_options (question_id, label, is_correct, sort_order)
select q.id, v.label, v.is_correct, v.ord from q,
  (values
      ('Gas loslaten', true, 0),
      ('Niets doen', false, 1),
      ('Gas geven om snel uit het bos te zijn', false, 2)
  ) as v(label, is_correct, ord);

-- q080
with q as (
  insert into public.questions (category_id, type, stem, explanation, difficulty, status)
  select id, 'single', 'Je rijdt 50 km/u en nadert een onbewaakte oversteekplaats. Vanaf rechts nadert een fietser die richting aangeeft dat hij linksaf jouw weg op wil, maar nog ruim voor de oversteek is. Wat doe je?', 'De fietser is nog op afstand maar wil jouw weg op. Laat gas los om snelheid te minderen en de situatie te beoordelen, zodat je kunt remmen als hij daadwerkelijk oversteekt.', 3, 'published'
  from public.categories where slug = 'gevaarherkenning'
  returning id
)
insert into public.question_options (question_id, label, is_correct, sort_order)
select q.id, v.label, v.is_correct, v.ord from q,
  (values
      ('Gas loslaten', true, 0),
      ('Niets doen', false, 1),
      ('Versnellen om voor de fietser te zijn', false, 2)
  ) as v(label, is_correct, ord);

-- q081
with q as (
  insert into public.questions (category_id, type, stem, explanation, difficulty, status)
  select id, 'single', 'Wat is een gevolg van een te lage bandenspanning?', 'Te lage bandenspanning zorgt voor meer rolweerstand (hoger verbruik), snellere en ongelijke slijtage en een slechter weggedrag met langere remweg. Controleer de spanning regelmatig.', 2, 'published'
  from public.categories where slug = 'voertuig-en-milieu'
  returning id
)
insert into public.question_options (question_id, label, is_correct, sort_order)
select q.id, v.label, v.is_correct, v.ord from q,
  (values
      ('Meer brandstofverbruik, meer slijtage en een langere remweg', true, 0),
      ('Minder brandstofverbruik en betere grip', false, 1),
      ('Geen enkel gevolg', false, 2)
  ) as v(label, is_correct, ord);

-- q082
with q as (
  insert into public.questions (category_id, type, stem, explanation, difficulty, status)
  select id, 'single', 'Wat is de wettelijk minimale profieldiepte van autobanden in Nederland?', 'De wettelijke minimale profieldiepte is 1,6 mm. Voor goede grip, vooral bij regen, wordt vaak geadviseerd om al bij 2 à 3 mm nieuwe banden te overwegen.', 1, 'published'
  from public.categories where slug = 'voertuig-en-milieu'
  returning id
)
insert into public.question_options (question_id, label, is_correct, sort_order)
select q.id, v.label, v.is_correct, v.ord from q,
  (values
      ('1,6 mm', true, 0),
      ('0,5 mm', false, 1),
      ('3,0 mm', false, 2)
  ) as v(label, is_correct, ord);

-- q083
with q as (
  insert into public.questions (category_id, type, stem, explanation, difficulty, status)
  select id, 'single', 'Hoe rijd je zo zuinig en milieuvriendelijk mogelijk (Het Nieuwe Rijden)?', 'Zuinig rijden doe je door vroeg op te schakelen, rustig op te trekken, gelijkmatig te rijden en op tijd gas los te laten. Dat scheelt brandstof, kosten en uitstoot.', 2, 'published'
  from public.categories where slug = 'voertuig-en-milieu'
  returning id
)
insert into public.question_options (question_id, label, is_correct, sort_order)
select q.id, v.label, v.is_correct, v.ord from q,
  (values
      ('Vroeg opschakelen, rustig optrekken en zoveel mogelijk gelijkmatig rijden', true, 0),
      ('Laat opschakelen en hoge toeren draaien', false, 1),
      ('Steeds hard optrekken en afremmen', false, 2)
  ) as v(label, is_correct, ord);

-- q084
with q as (
  insert into public.questions (category_id, type, stem, explanation, difficulty, status)
  select id, 'single', 'Wat is het voordeel van de motorrem gebruiken (gas loslaten in een versnelling) in plaats van uitsluitend op de rem trappen?', 'Bij afremmen op de motor (gas los, in versnelling) sluit de brandstoftoevoer; je verbruikt dan vrijwel geen brandstof en je remmen slijten minder. Het is dus zuinig én veilig.', 2, 'published'
  from public.categories where slug = 'voertuig-en-milieu'
  returning id
)
insert into public.question_options (question_id, label, is_correct, sort_order)
select q.id, v.label, v.is_correct, v.ord from q,
  (values
      ('Je verbruikt geen brandstof tijdens het afremmen en spaart de remmen', true, 0),
      ('De motor draait juist sneller stuk', false, 1),
      ('Het verbruikt veel meer brandstof', false, 2)
  ) as v(label, is_correct, ord);

-- q085
with q as (
  insert into public.questions (category_id, type, stem, explanation, difficulty, status)
  select id, 'truefalse', 'Stelling: Onnodig stationair laten draaien van de motor (bijvoorbeeld lang stilstaan met draaiende motor) is slecht voor het milieu en verspilt brandstof.', 'Onnodig stationair draaien verbruikt brandstof en stoot uitlaatgassen uit zonder dat je rijdt. Bij langer stilstaan kun je beter de motor uitzetten (veel auto''s doen dit automatisch met start-stop).', 1, 'published'
  from public.categories where slug = 'voertuig-en-milieu'
  returning id
)
insert into public.question_options (question_id, label, is_correct, sort_order)
select q.id, v.label, v.is_correct, v.ord from q,
  (values
      ('Waar', true, 0),
      ('Niet waar', false, 1)
  ) as v(label, is_correct, ord);

-- q086
with q as (
  insert into public.questions (category_id, type, stem, explanation, difficulty, status)
  select id, 'single', 'Wanneer verbruikt een auto met benzinemotor relatief het meest per kilometer?', 'Een koude motor verbruikt meer en stoot meer uit, omdat hij nog niet op temperatuur is. Korte ritten zijn daardoor relatief onzuinig. Combineer ritjes waar mogelijk.', 2, 'published'
  from public.categories where slug = 'voertuig-en-milieu'
  returning id
)
insert into public.question_options (question_id, label, is_correct, sort_order)
select q.id, v.label, v.is_correct, v.ord from q,
  (values
      ('Bij een koude start en korte ritten', true, 0),
      ('Bij een warme motor op constante snelheid', false, 1),
      ('Altijd evenveel, ongeacht de situatie', false, 2)
  ) as v(label, is_correct, ord);

-- q087
with q as (
  insert into public.questions (category_id, type, stem, explanation, difficulty, status)
  select id, 'single', 'Wat is de APK?', 'De APK (Algemene Periodieke Keuring) is een wettelijk verplichte keuring waarbij wordt gecontroleerd of je auto veilig en voldoende milieuvriendelijk is. Zonder geldige APK mag je niet de weg op.', 1, 'published'
  from public.categories where slug = 'voertuig-en-milieu'
  returning id
)
insert into public.question_options (question_id, label, is_correct, sort_order)
select q.id, v.label, v.is_correct, v.ord from q,
  (values
      ('Een wettelijk verplichte periodieke keuring van je auto op veiligheid en milieu', true, 0),
      ('Een verzekering tegen pech onderweg', false, 1),
      ('Een vrijwillige servicebeurt bij de garage', false, 2)
  ) as v(label, is_correct, ord);

-- q088
with q as (
  insert into public.questions (category_id, type, stem, explanation, difficulty, status)
  select id, 'single', 'Het waarschuwingslampje van de motortemperatuur (rood) gaat branden tijdens het rijden. Wat doe je?', 'Een brandend rood temperatuurlampje betekent oververhitting; doorrijden kan de motor zwaar beschadigen. Stop zo snel mogelijk veilig, zet de motor uit en laat hem afkoelen of schakel hulp in.', 2, 'published'
  from public.categories where slug = 'voertuig-en-milieu'
  returning id
)
insert into public.question_options (question_id, label, is_correct, sort_order)
select q.id, v.label, v.is_correct, v.ord from q,
  (values
      ('Zo snel mogelijk veilig stoppen en de motor laten afkoelen / hulp inschakelen', true, 0),
      ('Gewoon doorrijden, het lampje gaat vanzelf uit', false, 1),
      ('Harder rijden zodat de motor afkoelt door de wind', false, 2)
  ) as v(label, is_correct, ord);

-- q089
with q as (
  insert into public.questions (category_id, type, stem, explanation, difficulty, status)
  select id, 'single', 'Waarvoor dient de katalysator in de uitlaat?', 'De katalysator zet schadelijke stoffen in de uitlaatgassen (zoals koolmonoxide en stikstofoxiden) om in minder schadelijke stoffen. Hij werkt het best als de motor op bedrijfstemperatuur is.', 2, 'published'
  from public.categories where slug = 'voertuig-en-milieu'
  returning id
)
insert into public.question_options (question_id, label, is_correct, sort_order)
select q.id, v.label, v.is_correct, v.ord from q,
  (values
      ('Het verminderen van schadelijke stoffen in de uitlaatgassen', true, 0),
      ('Het verhogen van het motorvermogen', false, 1),
      ('Het koelen van de motor', false, 2)
  ) as v(label, is_correct, ord);

-- q090
with q as (
  insert into public.questions (category_id, type, stem, explanation, difficulty, status)
  select id, 'single', 'Wat controleer je regelmatig zelf om veilig en zuinig te blijven rijden?', 'Regelmatige eigen controle van bandenspanning, profiel, verlichting, ruitenwissers, olie- en koelvloeistofniveau houdt je auto veilig, zuinig en betrouwbaar. Niet alles wacht tot de volgende beurt.', 2, 'published'
  from public.categories where slug = 'voertuig-en-milieu'
  returning id
)
insert into public.question_options (question_id, label, is_correct, sort_order)
select q.id, v.label, v.is_correct, v.ord from q,
  (values
      ('Onder andere bandenspanning, profiel, verlichting, ruitenwissers en vloeistofniveaus', true, 0),
      ('Alleen de kleur van de auto', false, 1),
      ('Niets, dat doet de garage allemaal', false, 2)
  ) as v(label, is_correct, ord);

-- q091
with q as (
  insert into public.questions (category_id, type, stem, explanation, difficulty, status)
  select id, 'single', 'Je rijdt met een aanhangwagen. Wat verandert er aan je rijgedrag?', 'Met een aanhanger is je voertuig zwaarder en langer: je remweg wordt langer, je moet bochten ruimer nemen en rekening houden met lagere maximumsnelheden voor het rijden met aanhanger.', 2, 'published'
  from public.categories where slug = 'voertuig-en-milieu'
  returning id
)
insert into public.question_options (question_id, label, is_correct, sort_order)
select q.id, v.label, v.is_correct, v.ord from q,
  (values
      ('Je remweg wordt langer, je moet ruimer bochten nemen en rustiger rijden', true, 0),
      ('Niets, een aanhanger heeft geen invloed', false, 1),
      ('Je kunt juist harder rijden', false, 2)
  ) as v(label, is_correct, ord);

-- q092
with q as (
  insert into public.questions (category_id, type, stem, explanation, difficulty, status)
  select id, 'single', 'Waarvoor dient de hoofdsteun in de auto?', 'De hoofdsteun beschermt je nek bij een aanrijding van achteren (whiplash). Stel hem goed af: de bovenkant ongeveer ter hoogte van je kruin en dicht bij je hoofd.', 1, 'published'
  from public.categories where slug = 'voertuig-en-milieu'
  returning id
)
insert into public.question_options (question_id, label, is_correct, sort_order)
select q.id, v.label, v.is_correct, v.ord from q,
  (values
      ('Het beschermen van je nek tegen een whiplash bij een aanrijding van achteren', true, 0),
      ('Alleen voor het comfort tijdens lange ritten', false, 1),
      ('Het ophangen van kleding', false, 2)
  ) as v(label, is_correct, ord);

-- q093
with q as (
  insert into public.questions (category_id, type, stem, explanation, difficulty, status)
  select id, 'single', 'Wat is de juiste manier om de veiligheidsgordel te dragen?', 'De gordel hoort strak te zitten: de schoudergordel plat over je schouder (niet onder de arm) en de heupgordel laag over je heupen. Alleen zo beschermt hij optimaal bij een botsing.', 2, 'published'
  from public.categories where slug = 'voertuig-en-milieu'
  returning id
)
insert into public.question_options (question_id, label, is_correct, sort_order)
select q.id, v.label, v.is_correct, v.ord from q,
  (values
      ('Strak, plat over de schouder en laag over de heupen', true, 0),
      ('Los, met de schoudergordel onder de arm', false, 1),
      ('Alleen de heupgordel, de schoudergordel achter je rug', false, 2)
  ) as v(label, is_correct, ord);

-- q094
with q as (
  insert into public.questions (category_id, type, stem, explanation, difficulty, status)
  select id, 'single', 'Wat betekent het als het rode oliedruklampje tijdens het rijden gaat branden?', 'Het rode oliedruklampje wijst op te lage oliedruk, wat snel tot ernstige motorschade leidt. Stop zo snel mogelijk veilig, zet de motor uit en controleer het oliepeil of schakel hulp in.', 2, 'published'
  from public.categories where slug = 'voertuig-en-milieu'
  returning id
)
insert into public.question_options (question_id, label, is_correct, sort_order)
select q.id, v.label, v.is_correct, v.ord from q,
  (values
      ('Er is mogelijk te weinig oliedruk; stop zo snel mogelijk veilig om motorschade te voorkomen', true, 0),
      ('Je moet juist gas geven', false, 1),
      ('Het is normaal en je kunt het negeren', false, 2)
  ) as v(label, is_correct, ord);

-- q095
with q as (
  insert into public.questions (category_id, type, stem, explanation, difficulty, status)
  select id, 'single', 'Waarom is het belangrijk dat de ruiten, spiegels en verlichting schoon zijn voordat je wegrijdt?', 'Schone ruiten, spiegels en verlichting zorgen ervoor dat je goed ziet én goed gezien wordt. Maak in de winter eerst de ruiten volledig vrij van ijs en condens voordat je gaat rijden.', 2, 'published'
  from public.categories where slug = 'voertuig-en-milieu'
  returning id
)
insert into public.question_options (question_id, label, is_correct, sort_order)
select q.id, v.label, v.is_correct, v.ord from q,
  (values
      ('Voor goed zicht en goede zichtbaarheid; dat is essentieel voor de veiligheid', true, 0),
      ('Alleen voor de netheid van de auto', false, 1),
      ('Het maakt niet uit voor het rijden', false, 2)
  ) as v(label, is_correct, ord);

-- q096
with q as (
  insert into public.questions (category_id, type, stem, explanation, difficulty, status)
  select id, 'single', 'Welke bandenkeuze is verstandig bij winterse omstandigheden (kou, sneeuw, ijzel)?', 'Winterbanden hebben een rubbersamenstelling en profiel dat bij kou, sneeuw en ijzel meer grip geeft dan zomerbanden. In Nederland zijn ze niet verplicht, maar wel veiliger in de winter.', 2, 'published'
  from public.categories where slug = 'voertuig-en-milieu'
  returning id
)
insert into public.question_options (question_id, label, is_correct, sort_order)
select q.id, v.label, v.is_correct, v.ord from q,
  (values
      ('Winterbanden, omdat ze bij lage temperaturen en op sneeuw meer grip geven', true, 0),
      ('Zo glad mogelijke banden voor minder weerstand', false, 1),
      ('Bandenkeuze maakt in de winter niets uit', false, 2)
  ) as v(label, is_correct, ord);

-- q097
with q as (
  insert into public.questions (category_id, type, stem, explanation, difficulty, status)
  select id, 'single', 'Je hebt te veel lading in de auto, boven het toegestane gewicht. Wat is een gevolg?', 'Overbelading verslechtert het weggedrag, verlengt de remweg en belast banden en remmen extra. Het is bovendien wettelijk verboden. Houd je aan het toegestane laadvermogen uit het kentekenbewijs.', 3, 'published'
  from public.categories where slug = 'voertuig-en-milieu'
  returning id
)
insert into public.question_options (question_id, label, is_correct, sort_order)
select q.id, v.label, v.is_correct, v.ord from q,
  (values
      ('Slechter weggedrag, langere remweg en meer slijtage; bovendien is het verboden', true, 0),
      ('Betere wegligging door het extra gewicht', false, 1),
      ('Geen enkel gevolg zolang de deuren dichtgaan', false, 2)
  ) as v(label, is_correct, ord);

-- q098
with q as (
  insert into public.questions (category_id, type, stem, explanation, difficulty, status)
  select id, 'truefalse', 'Stelling: Een elektrische auto stoot tijdens het rijden zelf geen uitlaatgassen uit.', 'Een volledig elektrische auto heeft geen uitlaat en stoot tijdens het rijden geen uitlaatgassen uit. De totale milieu-impact hangt wel af van hoe de elektriciteit is opgewekt en van de productie van de accu.', 1, 'published'
  from public.categories where slug = 'voertuig-en-milieu'
  returning id
)
insert into public.question_options (question_id, label, is_correct, sort_order)
select q.id, v.label, v.is_correct, v.ord from q,
  (values
      ('Waar', true, 0),
      ('Niet waar', false, 1)
  ) as v(label, is_correct, ord);

-- q099
with q as (
  insert into public.questions (category_id, type, stem, explanation, difficulty, status)
  select id, 'single', 'Hoe stel je je buitenspiegels het beste af?', 'Stel de buitenspiegels zo af dat je nog net een klein stukje van je eigen auto ziet en zo veel mogelijk van de rijstrook ernaast. Zo verklein je de dode hoek. Een schouderblik blijft toch nodig.', 2, 'published'
  from public.categories where slug = 'voertuig-en-milieu'
  returning id
)
insert into public.question_options (question_id, label, is_correct, sort_order)
select q.id, v.label, v.is_correct, v.ord from q,
  (values
      ('Zo dat je net een klein stukje van je eigen auto ziet en de dode hoek zo klein mogelijk is', true, 0),
      ('Volledig op je eigen auto gericht', false, 1),
      ('Naar de lucht gericht', false, 2)
  ) as v(label, is_correct, ord);

-- q100
with q as (
  insert into public.questions (category_id, type, stem, explanation, difficulty, status)
  select id, 'single', 'Wat is verstandig met je snelheid op de snelweg als je let op brandstofverbruik en uitstoot?', 'Bij hogere snelheden neemt de luchtweerstand sterk toe, waardoor verbruik en uitstoot flink stijgen. Een rustige, constante snelheid (en bijvoorbeeld cruisecontrol op de snelweg) is zuiniger en schoner.', 2, 'published'
  from public.categories where slug = 'voertuig-en-milieu'
  returning id
)
insert into public.question_options (question_id, label, is_correct, sort_order)
select q.id, v.label, v.is_correct, v.ord from q,
  (values
      ('Een rustige, constante snelheid aanhouden; hard rijden verhoogt verbruik en uitstoot flink', true, 0),
      ('Zo hard mogelijk rijden bespaart juist brandstof', false, 1),
      ('Voortdurend optrekken en afremmen is het zuinigst', false, 2)
  ) as v(label, is_correct, ord);
