CREATE TABLE vendite (
    IDTransazione INT PRIMARY KEY,
    Categoria TEXT (50),
    Costo DOUBLE,
    ScontoPercentuale DOUBLE
    );

CREATE TABLE dettagli_vendite (
    IDTransazione INT,
    DataTransazione DATETIME,
    Quantita INT
);

INSERT INTO vendite (IDTransazione, Categoria, Costo, ScontoPercentuale) VALUES 
    (1, "LAVATRICE", 600, 53),
    (2, "ASCIUGATRICE", 400, 20.2),
    (3, "PURIFICATORE", 500, 60.4),
    (4, "INFORMATICA", 2030, 14.3),
    (5, "GIARDINAGGIO", 200, 20.6),
    (6, "TELEVISORE", 3000, 33.7),
    (7, "TELEFONIA", 1700, 35),
    (8, "LAVASTOVIGLIE", 700, 17),
    (9, "FORNO", 470, 54),
    (10, "FRIGORIFERO", 800, 10),
    (11, "LAVASTOVIGLIE", 690, 16),
    (12, "INFORMATICA", 3000, 14),
    (13, "LAVATRICE", 660, 32),
    (14, "QUADERNI", 20, 11),
    (15, "ALTOPARLANTI", 200, 58.8),
    (16, "ARREDAMENTO", 900, 55),
    (17, "ARREDAMENTO", 1970, 57.3),
    (18, "FORNO", 400, 12),
    (19, "TELEVISORE", 2000, 14.8),
    (20, "ASCIUGATRICE", 900, 5.5),
    (21, "FRIGORIFERO", 750, 11.3),
    (22, "QUADERNI", 35, 58.9),
    (23, "GIARDINAGGIO", 175, 6),
    (24, "ACCESSORI", 100, 39),
    (25, "ALTOPARLANTI", 250, 44),
    (26, "ACCESSORI", 500, 71.2),
    (27, "BRICOLAGE", 275, 13.3),
    (28, "LAVASTOVIGLIE", 1200, 58.8),
    (29, "ACCESSORI", 200, 18),
    (30, "OTTICA", 450, 66.2)
    ;
#SELECT*FROM vendite;
#DESCRIBE vendite;
#L'IDTransazione è unico ed è associato all'IDCliente

INSERT INTO dettagli_vendite (IDTransazione, DataTransazione, Quantita) VALUES
(1, "2023-01-22 11:17:22", 4),
(2, "2023-02-15 12:33:45", 7),
(3, "2023-03-28 13:03:55", 2),
(4, "2023-04-11 14:40:23", 5),
(5, "2023-05-24", 6),
(6, "2023-06-03", 3),
(7, "2023-07-19 17:11:33", 8),
(8, "2023-08-17 09:35:12", 5),
(9, "2023-09-20 10:15:05", 2),
(10, "2023-10-30 08:34:38",9), 
(11, "2023-11-19 07:59:44",4),
(12, "2023-12-11 18:01:47",7),
(13, "2023-01-22 11:15:30",2),
(14, "2023-02-10 20:30:35",4),
(15, "2023-03-01 10:45:50", 6),
(16, "2023-04-08 12:12:55",8),
(17, "2023-04-08 12:12:55", 5),
(18, "2023-04-16 09:22:54", 7),
(19, "2023-05-09 08:30:31",3),
(20, "2023-05-12 09:55:45", 1),
(21, "2023-06-24 17:48:47",9),
(22, "2023-07-27 16:15:58", 8),
(23, "2023-09-15 18:32:29", 3),
(24, "2023-10-23",7),
(25, "2023-03-01 14:35:30",8),
(26, "2023-10-23",6),
(27, "2023-11-11 18:45:32", 4),
(28, "2023-12-04 14:55:30", 9),
(29, "2023-12-11 13:10:20", 1),
(30, "2024-01-05 12:25:28", 5)
;

#TUTTI I DETTAGLI PER LE VENDITE AVVENUTE PER UNA SPECIFICA DATA (E ORARIO)
SELECT*FROM vendite v JOIN dettagli_vendite d ON v.IDTransazione = d.IDTransazione WHERE d.DataTransazione = "2023-02-15 12:33:45";
SELECT*FROM vendite v  JOIN dettagli_vendite d ON v.IDTransazione = d.IDTransazione WHERE d.DataTransazione = "2023-10-23";
#CATEGORIE E SCONTO IN % SE LO SCONTO STESSO è MAGGIORE DEL 50%
SELECT v.Categoria, v.ScontoPercentuale FROM vendite v WHERE v.ScontoPercentuale > 50;

#QUANTI PRODOTTI SONO STATI VENDUTI PER CATEGORIA?
SELECT v.Categoria, COUNT(*) AS TOTALEPERCATEGORIA FROM vendite v  GROUP BY Categoria;
#SOMMA DEI COSTI COME INDICATO NELL'ESERCIZIO AL PUNTO 4 PER 
#CATEGORIA (NON PER QUANTITÀ) ORDINATI PER SOMMA DESCRESCENTE
SELECT v.Categoria, SUM(v.Costo) AS TOTALEPERCOSTO FROM vendite v 
GROUP BY Categoria ORDER BY TOTALEPERCOSTO DESC;

#VENDITE ULTIMI TRE MESI (CON ADDDATE) DA ADESSO AD OTTOBRE SENZA RAGGRUPPAMENTI
SELECT v.Categoria,d.DataTransazione, d.Quantita, v.Costo FROM vendite v JOIN dettagli_vendite d
ON v.IDTransazione = d.IDTransazione 
WHERE d.DataTransazione >= ADDDATE(now(),INTERVAL - 3 MONTH);

#VENDITE RAGGRUPPATE PER MOMENTO (NOME MESE ED ANNO ESTESO) PER CATEGORIA E SOMMA COSTI MENSILI
SELECT DATE_FORMAT(d.DataTransazione,"%M,%Y") AS MOMENTO, v.Categoria, 
SUM(v.Costo) AS TOTALEMESI 
FROM vendite v JOIN dettagli_vendite d ON v.IDTransazione = d.IDTransazione 
GROUP BY MOMENTO, v.Categoria;

#LO SCONTO MEDIO PER OGNI CATEGORIA
SELECT v.Categoria, AVG(v.ScontoPercentuale) AS MEDIASCONTO 
FROM vendite v GROUP BY v.Categoria;
#SCONTI MEDI ORDINATI IN MODO DISCENDENTE LIMITATI AD 1, OSSIA IL MAGGIORE: OTTICA
SELECT v.Categoria, AVG(v.ScontoPercentuale) AS MAXSCONTO FROM vendite v
GROUP BY v.Categoria ORDER BY MAXSCONTO DESC 
LIMIT 1;

#INCREMENTO O DECREMENTO PER MESE USANDO LA FUNZIONE LAG (SUGGERITA DA CHATGPT)
#PER OTTENERE E CONFRONTARE LA RIGA PRECEDENTE PER DETERMINARE
#GLI INCREMENTI PARTENDO DALLA DATA MINIMA
SELECT DATE_FORMAT(d.DataTransazione,"%M,%Y") AS PERIODO, SUM(v.Costo) AS TOTALEVENDITE,
SUM(v.Costo) - LAG(SUM(v.Costo)) OVER (ORDER BY MIN(d.DataTransazione)) AS INCREMENTO
FROM vendite v JOIN dettagli_vendite d ON v.IDTransazione = d.IDTransazione
GROUP BY PERIODO;
# SE AVESSI VOLUTO SCRIVERE L'INCREMENTO PRECENTUALE,SAREBBE STATO: (SUM(v.Costo) - LAG(SUM(v.Costo)) OVER (ORDER BY MIN(d.DataTransazione)))/LAG(SUM(v.Costo)) 
#OVER (ORDER BY MIN(d.DataTransazione)) * 100 AS INCREMENTO

#QUANTITÁ DI VENDITE TOTALI DURANTE LE 4 STAGIONI RAGGRUPPATE PER MESI USANDO BETWEEN E IN
SELECT SUM(d.Quantita) AS STAGIONE, DATE_FORMAT(d.DataTransazione,"%M,%Y") AS INVERNO, SUM(v.Costo) AS COSTOUNITARIO 
FROM vendite v JOIN dettagli_vendite d ON v.IDTransazione = d.IDTransazione
WHERE MONTH(d.DataTransazione) IN ("12","1","2") GROUP BY INVERNO ORDER BY MIN(d.DataTransazione) ;
SELECT SUM(d.Quantita) AS STAGIONE,DATE_FORMAT(d.DataTransazione,"%M,%Y") AS PRIMAVERA
FROM vendite v JOIN dettagli_vendite d ON v.IDTransazione = d.IDTransazione
WHERE MONTH(d.DataTransazione) BETWEEN "3" AND "6" GROUP BY PRIMAVERA;
SELECT SUM(d.Quantita) AS STAGIONE, DATE_FORMAT(d.DataTransazione,"%M,%Y") AS ESTATE
FROM vendite v JOIN dettagli_vendite d ON v.IDTransazione = d.IDTransazione
WHERE MONTH(d.DataTransazione) BETWEEN "7" AND "9" GROUP BY ESTATE;
SELECT SUM(d.Quantita) AS STAGIONE, DATE_FORMAT(d.DataTransazione,"%M,%Y") AS AUTUNNO
FROM vendite v JOIN dettagli_vendite d ON v.IDTransazione = d.IDTransazione
WHERE MONTH(d.DataTransazione) BETWEEN "10" AND "11" GROUP BY AUTUNNO;

#SE NELLA STESSA TABELLA T CI FOSSERO I DUE CAMPI, PROSEGUIREI
#CONTANDO IL NUMERO DI VENITE ASSOCIATO AI CLIENTI E LIMITANDO 
#L'ORDINE DISCENDENTE AI PRIMI 5 (COME IL PUNTO DELLO SCONTO MASSIMO):
#SELECT t.IDCliente, COUNT(t.IDVendite) AS NUMEROVENDITE FROM tabella t 
#GROUP BY t.IDCliente ORDER BY NUMEROVENDITE DESC LIMIT 5;





