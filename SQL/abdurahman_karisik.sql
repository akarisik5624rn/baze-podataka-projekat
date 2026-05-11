USE astronomija;

SELECT 
    o.naziv AS Opservatorija,
    o.drzava AS Drzava,
    COUNT(s.id_sesije) AS Broj_Uspesnih_Sesija,
    ROUND(AVG(s.seeing_lucne_sekunde), 2) AS Prosecan_Seeing
FROM OPSERVATORIJA o
JOIN SESIJA s ON o.id_opservatorije = s.id_opservatorije
JOIN IZVODJENJE i ON s.id_izvodjenja = i.id_izvodjenja
WHERE i.status = 'zavrseno uspesno'
GROUP BY o.id_opservatorije, o.naziv, o.drzava
HAVING AVG(s.seeing_lucne_sekunde) < 1.5
ORDER BY Broj_Uspesnih_Sesija DESC;