CREATE DATABASE IF NOT EXISTS astronomija;
USE astronomija;

CREATE TABLE OPSERVATORIJA (
    id_opservatorije INT PRIMARY KEY AUTO_INCREMENT,
    naziv VARCHAR(100) NOT NULL,
    grad VARCHAR(100) NOT NULL,
    drzava VARCHAR(100) NOT NULL,
    koordinata_latituda DECIMAL(9,6) NOT NULL,
    koordinata_longituda DECIMAL(9,6) NOT NULL,
    nadmorska_visina INT NOT NULL,
    tip_opservatorije VARCHAR(50) NOT NULL
);

CREATE TABLE RESURS (
    id_resursa INT PRIMARY KEY AUTO_INCREMENT,
    naziv VARCHAR(100) NOT NULL,
    tip VARCHAR(50) NOT NULL,
    jedinica_mere VARCHAR(20) NOT NULL,
    dodatni_opis TEXT
);

CREATE TABLE TIP_ALATA (
    id_tipa_alata INT PRIMARY KEY AUTO_INCREMENT,
    naziv VARCHAR(100) NOT NULL,
    opis TEXT
);

CREATE TABLE TEORIJA (
    id_teorije INT PRIMARY KEY AUTO_INCREMENT,
    naziv VARCHAR(100) NOT NULL,
    oznaka VARCHAR(20) NOT NULL,
    dodatni_opis TEXT
);

CREATE TABLE NEBESKI_OBJEKAT (
    id_objekta INT PRIMARY KEY AUTO_INCREMENT,
    naziv VARCHAR(100) NOT NULL,
    tip VARCHAR(50) NOT NULL,
    rektascenzija DECIMAL(10,6) NOT NULL,
    deklinacija DECIMAL(10,6) NOT NULL,
    prividna_magnituda DECIMAL(5,2)
);

CREATE TABLE ISTRAZIVAC (
    id_istrazivaca INT PRIMARY KEY AUTO_INCREMENT,
    ime VARCHAR(50) NOT NULL,
    prezime VARCHAR(50) NOT NULL,
    datum_rodjenja DATE NOT NULL,
    email VARCHAR(100) NOT NULL,
    institucija VARCHAR(100) NOT NULL,
    akademsko_zvanje VARCHAR(50) NOT NULL,
    oblast_specijalizacije VARCHAR(100) NOT NULL,
    godine_iskustva INT NOT NULL
);

CREATE TABLE INVENTAR_RESURSA (
    id_opservatorije INT NOT NULL,
    id_resursa INT NOT NULL,
    kolicina_na_stanju DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (id_opservatorije, id_resursa),
    FOREIGN KEY (id_opservatorije) REFERENCES OPSERVATORIJA(id_opservatorije),
    FOREIGN KEY (id_resursa) REFERENCES RESURS(id_resursa)
);

CREATE TABLE ALAT (
    id_alata INT PRIMARY KEY AUTO_INCREMENT,
    identifikacioni_broj VARCHAR(50) NOT NULL,
    id_tipa_alata INT NOT NULL,
    id_opservatorije INT NOT NULL,
    datum_nabavke DATE NOT NULL,
    datum_proizvodnje DATE,
    FOREIGN KEY (id_tipa_alata) REFERENCES TIP_ALATA(id_tipa_alata),
    FOREIGN KEY (id_opservatorije) REFERENCES OPSERVATORIJA(id_opservatorije)
);

CREATE TABLE EKSPERIMENT (
    id_eksperimenta INT PRIMARY KEY AUTO_INCREMENT,
    naziv VARCHAR(100) NOT NULL,
    tip VARCHAR(50) NOT NULL,
    id_teorije INT NOT NULL,
    FOREIGN KEY (id_teorije) REFERENCES TEORIJA(id_teorije)
);

CREATE TABLE DIZAJNER_EKSPERIMENTA (
    id_eksperimenta INT NOT NULL,
    id_istrazivaca INT NOT NULL,
    PRIMARY KEY (id_eksperimenta, id_istrazivaca),
    FOREIGN KEY (id_eksperimenta) REFERENCES EKSPERIMENT(id_eksperimenta),
    FOREIGN KEY (id_istrazivaca) REFERENCES ISTRAZIVAC(id_istrazivaca)
);

CREATE TABLE CILJ_POSMATRANJA (
    id_eksperimenta INT NOT NULL,
    id_objekta INT NOT NULL,
    PRIMARY KEY (id_eksperimenta, id_objekta),
    FOREIGN KEY (id_eksperimenta) REFERENCES EKSPERIMENT(id_eksperimenta),
    FOREIGN KEY (id_objekta) REFERENCES NEBESKI_OBJEKAT(id_objekta)
);

CREATE TABLE POTREBAN_RESURS_ZA_EKSPERIMENT (
    id_eksperimenta INT NOT NULL,
    id_resursa INT NOT NULL,
    procenjena_kolicina DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (id_eksperimenta, id_resursa),
    FOREIGN KEY (id_eksperimenta) REFERENCES EKSPERIMENT(id_eksperimenta),
    FOREIGN KEY (id_resursa) REFERENCES RESURS(id_resursa)
);

CREATE TABLE POTREBAN_ALAT_ZA_EKSPERIMENT (
    id_eksperimenta INT NOT NULL,
    id_tipa_alata INT NOT NULL,
    PRIMARY KEY (id_eksperimenta, id_tipa_alata),
    FOREIGN KEY (id_eksperimenta) REFERENCES EKSPERIMENT(id_eksperimenta),
    FOREIGN KEY (id_tipa_alata) REFERENCES TIP_ALATA(id_tipa_alata)
);

CREATE TABLE IZVODJENJE (
    id_izvodjenja INT PRIMARY KEY AUTO_INCREMENT,
    id_eksperimenta INT NOT NULL,
    id_opservatorije INT NOT NULL,
    datum DATE NOT NULL,
    status VARCHAR(30) NOT NULL,
    FOREIGN KEY (id_eksperimenta) REFERENCES EKSPERIMENT(id_eksperimenta),
    FOREIGN KEY (id_opservatorije) REFERENCES OPSERVATORIJA(id_opservatorije)
);

CREATE TABLE TIM_IZVODJACA (
    id_izvodjenja INT NOT NULL,
    id_istrazivaca INT NOT NULL,
    opis_uloge VARCHAR(100) NOT NULL,
    putanja_do_beleski VARCHAR(255),
    PRIMARY KEY (id_izvodjenja, id_istrazivaca),
    FOREIGN KEY (id_izvodjenja) REFERENCES IZVODJENJE(id_izvodjenja),
    FOREIGN KEY (id_istrazivaca) REFERENCES ISTRAZIVAC(id_istrazivaca)
);

CREATE TABLE SESIJA (
    id_sesije INT PRIMARY KEY AUTO_INCREMENT,
    id_izvodjenja INT NOT NULL,
    id_opservatorije INT NOT NULL,
    datum DATE NOT NULL,
    vreme_pocetka TIME NOT NULL,
    vreme_zavrsetka TIME NOT NULL,
    oblacnost_procenat DECIMAL(5,2),
    seeing_lucne_sekunde DECIMAL(5,2),
    vlaznost_vazduha DECIMAL(5,2),
    temperatura DECIMAL(5,2),
    brzina_vetra DECIMAL(5,2),
    FOREIGN KEY (id_izvodjenja) REFERENCES IZVODJENJE(id_izvodjenja),
    FOREIGN KEY (id_opservatorije) REFERENCES OPSERVATORIJA(id_opservatorije)
);

CREATE TABLE UTROSENI_RESURSI_SESIJE (
    id_sesije INT NOT NULL,
    id_resursa INT NOT NULL,
    utrosena_kolicina DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (id_sesije, id_resursa),
    FOREIGN KEY (id_sesije) REFERENCES SESIJA(id_sesije),
    FOREIGN KEY (id_resursa) REFERENCES RESURS(id_resursa)
);

CREATE TABLE ISKORISCENI_ALATI_SESIJE (
    id_sesije INT NOT NULL,
    id_alata INT NOT NULL,
    PRIMARY KEY (id_sesije, id_alata),
    FOREIGN KEY (id_sesije) REFERENCES SESIJA(id_sesije),
    FOREIGN KEY (id_alata) REFERENCES ALAT(id_alata)
);

CREATE TABLE KORISNIK (
    id_korisnika INT PRIMARY KEY AUTO_INCREMENT,
    korisnicko_ime VARCHAR(50) NOT NULL UNIQUE,
    lozinka VARCHAR(255) NOT NULL
);