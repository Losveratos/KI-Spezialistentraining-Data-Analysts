-- Übungsdatei Modul 1 – Azure-SQL-View für den Power-BI-Bericht (fiktiv, DBS Training)
-- Wird im Bericht per DirectQuery abgefragt. Aufgabe in Ü1.5: formatieren, kommentieren,
-- Schwachstellen benennen und eine verbesserte Fassung vorschlagen lassen.
--
-- Tabellenstruktur (Auszug, so wie sie in der Datenbank steht):
--   dbo.Leistung        (Monat DATE, Kostenstelle VARCHAR(10), Werk VARCHAR(4), RegionID INT,
--                        LeistungsartID INT, Ist_Stunden DECIMAL(12,2), Plan_Stunden DECIMAL(12,2),
--                        Plan_Kosten DECIMAL(14,2), Leistungseinheiten INT, Bemerkung NVARCHAR(400),
--                        Erfasst_von NVARCHAR(100), Geaendert_am DATETIME2)
--                        Clustered Index auf (Monat, Kostenstelle)
--   dbo.SAP_Kosten      (Belegnummer BIGINT, Kostenstelle NVARCHAR(10), Kostenart INT,
--                        Buchungsdatum DATE, Betrag DECIMAL(14,2), Menge DECIMAL(12,2), ME NVARCHAR(3))
--                        ca. 40 Mio. Zeilen, Nonclustered Index auf (Kostenstelle, Buchungsdatum)
--   dbo.Region          (RegionID INT, Region NVARCHAR(50))
--   dbo.Leistungsart    (LeistungsartID INT, Leistungsart NVARCHAR(50), Geschaeftsfeld NVARCHAR(50))
--   Werk: Werte wie '1000', '1100', 'X200' (Text!)

create view dbo.vw_Leistung_PowerBI as
select top 100 percent * from (
select l.*, r.Region, la.Leistungsart, la.Geschaeftsfeld,
(select sum(k.Betrag) from dbo.SAP_Kosten k with (nolock) where k.Kostenstelle = l.Kostenstelle and year(k.Buchungsdatum) = year(l.Monat) and month(k.Buchungsdatum) = month(l.Monat) and k.Kostenart between 600000 and 699999) as Ist_Kosten,
(select sum(k2.Menge) from dbo.SAP_Kosten k2 with (nolock) where k2.Kostenstelle = l.Kostenstelle and year(k2.Buchungsdatum) = year(l.Monat) and month(k2.Buchungsdatum) = month(l.Monat) and k2.ME = 'STD') as Ist_Stunden_SAP,
(select sum(k.Betrag) from dbo.SAP_Kosten k with (nolock) where k.Kostenstelle = l.Kostenstelle and year(k.Buchungsdatum) = year(l.Monat) and month(k.Buchungsdatum) = month(l.Monat) and k.Kostenart between 600000 and 699999) - l.Plan_Kosten as Abw_Kosten,
case when l.Plan_Kosten = 0 then null else ((select sum(k.Betrag) from dbo.SAP_Kosten k with (nolock) where k.Kostenstelle = l.Kostenstelle and year(k.Buchungsdatum) = year(l.Monat) and month(k.Buchungsdatum) = month(l.Monat) and k.Kostenart between 600000 and 699999) - l.Plan_Kosten) / l.Plan_Kosten end as Abw_Kosten_Prozent
from dbo.Leistung l with (nolock)
left join dbo.Region r with (nolock) on r.RegionID = l.RegionID
left join dbo.Leistungsart la with (nolock) on la.LeistungsartID = l.LeistungsartID
where (year(l.Monat) = 2025 or year(l.Monat) = 2026) and l.Werk = 1000
) x
order by x.Monat, x.Region
