USE astronomija;

SELECT
    t.naziv AS Naziv_Teorije,
    t.oznaka AS Oznaka,
    COUNT(DISTINCT e.id_eksperimenta) AS Broj_Eksperimenata,
    COUNT(s.id_sesije) AS Ukupno_Sesija,
    ROUND(AVG(s.seeing_lucne_sekunde), 2) AS Prosecan_Seeing
FROM TEORIJA t
JOIN EKSPERIMENT e ON t.id_teorije = e.id_teorije
JOIN IZVODJENJE iz ON e.id_eksperimenta = iz.id_eksperimenta
JOIN SESIJA s ON iz.id_izvodjenja = s.id_izvodjenja
WHERE iz.status != 'otkazano'
GROUP BY t.id_teorije, t.naziv, t.oznaka
HAVING COUNT(s.id_sesije) > 2
ORDER BY Ukupno_Sesija DESC;
