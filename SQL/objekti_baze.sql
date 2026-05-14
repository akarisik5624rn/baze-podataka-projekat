USE astronomija;

-- Prikazuje statistiku eksperimenata grupisanu po teorijskom
-- okviru koji prate. Za svaki eksperiment prikazuje naziv,
-- teoriju koju prati i broj istraživača koji su ga dizajnirali.
CREATE OR REPLACE VIEW V_Eksperimenti_Statistika AS
SELECT 
    e.naziv AS Ime_Eksperimenta, 
    t.naziv AS Naziv_Teorije, 
    COUNT(de.id_istrazivaca) AS Broj_Dizajnera
FROM EKSPERIMENT e
JOIN TEORIJA t ON e.id_teorije = t.id_teorije
JOIN DIZAJNER_EKSPERIMENTA de ON e.id_eksperimenta = de.id_eksperimenta
GROUP BY 
    e.id_eksperimenta, e.naziv, t.naziv
HAVING 
    COUNT(de.id_istrazivaca) > 1;

-- Beleži potrošnju resursa tokom posmatračke sesije i
-- automatski ažurira inventar opservatorije. Ako na stanju
-- nema dovoljno resursa, transakcija se poništava (ROLLBACK) i inventar ostaje nepromenjen.
DELIMITER //
CREATE PROCEDURE ZabeleziUtrosakResursa (
    IN p_id_sesije INT,
    IN p_id_resursa INT,
    IN p_kolicina DECIMAL(10,2)
)
BEGIN
    DECLARE v_trenutno_stanje DECIMAL(10,2);
    DECLARE v_id_opservatorije INT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SELECT 'Greska: Transakcija je prekinuta.' AS Poruka;
    END;

    START TRANSACTION;

    SELECT id_opservatorije INTO v_id_opservatorije
    FROM SESIJA
    WHERE id_sesije = p_id_sesije;

    SELECT kolicina_na_stanju INTO v_trenutno_stanje
    FROM INVENTAR_RESURSA
    WHERE id_opservatorije = v_id_opservatorije AND id_resursa = p_id_resursa;

    IF v_trenutno_stanje >= p_kolicina THEN
        INSERT INTO UTROSENI_RESURSI_SESIJE (id_sesije, id_resursa, utrosena_kolicina)
        VALUES (p_id_sesije, p_id_resursa, p_kolicina);

        UPDATE INVENTAR_RESURSA
        SET kolicina_na_stanju = kolicina_na_stanju - p_kolicina
        WHERE id_opservatorije = v_id_opservatorije AND id_resursa = p_id_resursa;

        COMMIT;
        SELECT 'Uspesno zabelezeno.' AS Poruka;
    ELSE
        ROLLBACK;
        SELECT 'Nema dovoljno resursa na stanju!' AS Poruka;
    END IF;

END //
DELIMITER ;


-- Vraća ukupan broj posmatračkih sesija koje su održane
-- u okviru svih izvođenja datog eksperimenta.
DELIMITER //
CREATE FUNCTION BrojSesijaZaEksperiment (p_id_eksperimenta INT)
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE v_broj_sesija INT;

    SELECT COUNT(s.id_sesije) INTO v_broj_sesija
    FROM SESIJA s
    JOIN IZVODJENJE i ON s.id_izvodjenja = i.id_izvodjenja
    WHERE i.id_eksperimenta = p_id_eksperimenta;

    IF v_broj_sesija IS NULL THEN
        SET v_broj_sesija = 0;
    END IF;

    RETURN v_broj_sesija;
END //
DELIMITER ;

DELIMITER //
CREATE FUNCTION Test_BrojSesijaZaEksperiment()
RETURNS BOOLEAN
DETERMINISTIC
BEGIN
    DECLARE v_pass BOOLEAN DEFAULT TRUE;
    DECLARE v_expected INT;
    DECLARE v_actual INT;
    DECLARE i INT DEFAULT 1;

    WHILE i <= 5 DO
        SELECT COUNT(s.id_sesije) INTO v_expected
        FROM SESIJA s
        JOIN IZVODJENJE izv ON s.id_izvodjenja = izv.id_izvodjenja
        WHERE izv.id_eksperimenta = i;

        SET v_actual = BrojSesijaZaEksperiment(i);

        IF v_expected != v_actual THEN
            SET v_pass = FALSE;
        END IF;

        SET i = i + 1;
    END WHILE;

    RETURN v_pass;
END //
DELIMITER ;