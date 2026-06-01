USE astronomija;

-- BTREE
-- Kreira se kao BTREE jer su datumi podaci visoke kardinalnosti i često se koriste za pretragu po opsezima.
-- Neklasterovan. Tabela već ima klasterovani indeks (primarni ključ id_izvodjenja).
-- Značajno ubrzava pretrage i izveštaje koji traže sva izvođenja eksperimenata u određenom vremenskom periodu.
CREATE INDEX IX_Izvodjenje_Datum ON IZVODJENJE(datum);

-- BITMAP
-- Kreira se kao BITMAP jer kolona ima veoma nisku kardinalnost (malo mogućih vrednosti statusa).
-- Neklasterovan. Statusi se često menjaju (UPDATE), pa bi klasterovani indeks izazvao preskupo fizičko premeštanje redova.
-- Ekstremno ubrzava filtriranje eksperimenata po statusu.
CREATE INDEX IX_Izvodjenje_Status ON IZVODJENJE(status);

-- BITMAP
-- Tipovi nebeskih objekata se često ponavljaju (zvezda, galaksija...), što znači da je kardinalnost mala.
-- Neklasterovan. Tabela se već fizički sortira po primarnom ključu id_objekta.
-- Pomaže pri brzom grupisanju i prebrojavanju objekata određenog tipa u katalogu.
CREATE INDEX IX_NebeskiObjekat_Tip ON NEBESKI_OBJEKAT(tip);

-- BTREE
-- Magnituda je decimalni broj sa mnogo različitih vrednosti, savršen za BTREE stablo.
-- Neklasterovan.
-- Ubrzava sortiranje objekata po sjaju i pronalaženje najsjajnijih objekata.
CREATE INDEX IX_NebeskiObjekat_Magnituda ON NEBESKI_OBJEKAT(prividna_magnituda);

-- BITMAP
-- Postoji samo nekoliko definisanih zvanja, što kolonu čini pogodnom za BITMAP.
-- Neklasterovan. Primarni ključ drži fizički raspored.
-- Ubrzava pretrage poput pronalaženja svih profesora koji mogu biti nosioci eksperimenta.
CREATE INDEX IX_Istrazivac_Zvanje ON ISTRAZIVAC(akademsko_zvanje);

-- BTREE
-- Godine iskustva su numerička vrednost koja se često ispituje kroz upite poređenja (veće, manje).
-- Neklasterovan.
-- Omogućava brzo filtriranje iskusnih posmatrača pri formiranju timova.
CREATE INDEX IX_Istrazivac_Iskustvo ON ISTRAZIVAC(godine_iskustva);

-- BTREE
-- Obuhvata dve kolone (oblacnost i seeing) koje su decimalnog tipa i visoke kardinalnosti.
-- Neklasterovan.
-- Složeni upiti koji traže savršene vremenske uslove sada ne moraju da čitaju celu tabelu (Table Scan).
CREATE INDEX IX_Sesija_VremenskiUslovi ON SESIJA(oblacnost_procenat, seeing_lucne_sekunde);

-- BTREE
-- Datumski tip podataka zahteva BTREE kako bi se lako radile operacije vezane za raspone datuma.
-- Neklasterovan.
-- Ubrzava izveštaje o inventaru, naročito kada se pretražuje oprema nabavljena pre određenog datuma.
CREATE INDEX IX_Alat_DatumNabavke ON ALAT(datum_nabavke);

-- BTREE
-- Kreira se kao BTREE zbog brze pretrage tekstualnih stringova.
-- Neklasterovan.
-- Ubrzava geografsko filtriranje, odnosno prikazivanje svih dostupnih opservatorija po specifičnoj državi.
CREATE INDEX IX_Opservatorija_Drzava ON OPSERVATORIJA(drzava);

-- BITMAP
-- Oblast eksperimenta je podatak niske kardinalnosti (samo nekoliko tipova).
-- Neklasterovan. Tabela je fizički sortirana po ID-ju.
-- Ubrzava filtriranje eksperimenata na aplikaciji korisnika, kada u padajućem meniju izabere da vidi samo npr. spektroskopske eksperimente.
CREATE INDEX IX_Eksperiment_Tip ON EKSPERIMENT(tip);