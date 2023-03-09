UPDATE signalo_db.vl_coating SET value_de='unbekannt' WHERE id = 1;
UPDATE signalo_db.vl_coating SET value_de='andere' WHERE id = 2;
UPDATE signalo_db.vl_coating SET value_de='zu bestimmen' WHERE id = 3;
UPDATE signalo_db.vl_coating SET description_de='Schild garantiert 10 Jahre' WHERE id = 11;
UPDATE signalo_db.vl_coating SET description_de='Schild garantiert 13 Jahre' WHERE id = 12;
UPDATE signalo_db.vl_coating SET description_de='Schild garantiert 15 Jahre' WHERE id = 13;
UPDATE signalo_db.vl_coating SET description_de='beleuchtete Innenpaneele' WHERE id = 14;

UPDATE signalo_db.vl_durability SET value_de='unbekannt' WHERE id = 1;
UPDATE signalo_db.vl_durability SET value_de='andere' WHERE id = 2;
UPDATE signalo_db.vl_durability SET value_de='zu bestimmen' WHERE id = 3;
UPDATE signalo_db.vl_durability SET value_de='dauerhaft' WHERE id = 10;
UPDATE signalo_db.vl_durability SET value_de='temporär' WHERE id = 11;
UPDATE signalo_db.vl_durability SET value_de='Winter' WHERE id = 12;

UPDATE signalo_db.vl_frame_fixing_type SET value_de='unbekannt' WHERE id = 1;
UPDATE signalo_db.vl_frame_fixing_type SET value_de='andere' WHERE id = 2;
UPDATE signalo_db.vl_frame_fixing_type SET value_de='zu bestimmen' WHERE id = 3;
UPDATE signalo_db.vl_frame_fixing_type SET value_de='für Rahmen mit Schienen' WHERE id = 10;
UPDATE signalo_db.vl_frame_fixing_type SET value_de='für Rahmen mit seitlicher Befestigung' WHERE id = 11;
UPDATE signalo_db.vl_frame_fixing_type SET value_de='zur Befestigung des Rahmens mit Tespa-Band' WHERE id = 12;
UPDATE signalo_db.vl_frame_fixing_type SET value_de='rechteckig für die Montage auf IPE' WHERE id = 13;

UPDATE signalo_db.vl_frame_type SET value_de='unbekannt' WHERE id = 1;
UPDATE signalo_db.vl_frame_type SET value_de='andere' WHERE id = 2;
UPDATE signalo_db.vl_frame_type SET value_de='zu bestimmen' WHERE id = 3;
UPDATE signalo_db.vl_frame_type SET value_de='Direktmontage' WHERE id = 10;
UPDATE signalo_db.vl_frame_type SET value_de='verschweisst' WHERE id = 11;
UPDATE signalo_db.vl_frame_type SET value_de='gesteckt' WHERE id = 12;
UPDATE signalo_db.vl_frame_type SET value_de='mit Schiene' WHERE id = 13;
UPDATE signalo_db.vl_frame_type SET value_de='seitliche Montage' WHERE id = 14;

UPDATE signalo_db.vl_lighting SET value_de='unbekannt' WHERE id = 1;
UPDATE signalo_db.vl_lighting SET value_de='andere' WHERE id = 2;
UPDATE signalo_db.vl_lighting SET value_de='zu bestimmen' WHERE id = 3;
UPDATE signalo_db.vl_lighting SET value_de='keine' WHERE id = 10;
UPDATE signalo_db.vl_lighting SET value_de='Glühbirne' WHERE id = 11;
UPDATE signalo_db.vl_lighting SET value_de='LED' WHERE id = 12;
UPDATE signalo_db.vl_lighting SET value_de='Neon' WHERE id = 13;

UPDATE signalo_db.vl_marker_type SET value_de='unbekannt' WHERE id = 1;
UPDATE signalo_db.vl_marker_type SET value_de='andere' WHERE id = 2;
UPDATE signalo_db.vl_marker_type SET value_de='zu bestimmen' WHERE id = 3;
UPDATE signalo_db.vl_marker_type SET value_de='Leitpfeil' WHERE id = 12;
UPDATE signalo_db.vl_marker_type SET value_de='Leitmarkierung' WHERE id = 13;
UPDATE signalo_db.vl_marker_type SET value_de='Leitbake' WHERE id = 14;
UPDATE signalo_db.vl_marker_type SET value_de='Verkehrsteiler' WHERE id = 16;   

UPDATE signalo_db.vl_mirror_shape SET value_de='andere' WHERE id = 2;
UPDATE signalo_db.vl_mirror_shape SET value_de='rechteckig' WHERE id = 11;
UPDATE signalo_db.vl_mirror_shape SET value_de='rund' WHERE id = 12;    


UPDATE signalo_db.vl_official_sign SET value_de='Wegweiser zu Autobahnen oder Autostrassen (1 Linie, Pfeil links)' WHERE id = '4.31-1-l';	
UPDATE signalo_db.vl_official_sign SET value_de='Wegweiser zu Autobahnen oder Autostrassen (1 Linie, Pfeil rechts)' WHERE id = '4.31-1-r';
UPDATE signalo_db.vl_official_sign SET value_de='Wegweiser zu Autobahnen oder Autostrassen (2 Linien, Pfeil links)' WHERE id = '4.31-2-l';
UPDATE signalo_db.vl_official_sign SET value_de='Wegweiser zu Autobahnen oder Autostrassen (2 Linien, Pfeil rechts)' WHERE id = '4.31-2-r';
UPDATE signalo_db.vl_official_sign SET value_de='Wegweiser zu Autobahnen oder Autostrassen (3 Linien, Pfeil links)' WHERE id = '4.31-3-l';
UPDATE signalo_db.vl_official_sign SET value_de='Wegweiser zu Autobahnen oder Autostrassen (3 Linien, Pfeil rechts)'  WHERE id = '4.31-3-r';
UPDATE signalo_db.vl_official_sign SET value_de='Wegweiser für Hauptstrassen (1 Linie, Pfeil links)' WHERE id = '4.32-1-l';
UPDATE signalo_db.vl_official_sign SET value_de='Wegweiser für Hauptstrassen (1 Linie, Pfeil rechts)' WHERE id = '4.32-1-r';
UPDATE signalo_db.vl_official_sign SET value_de='Wegweiser für Hauptstrassen (2 Linien, Pfeil links)' WHERE id = '4.32-2-l';
UPDATE signalo_db.vl_official_sign SET value_de='Wegweiser für Hauptstrassen (2 Linien, Pfeil rechts)' WHERE id = '4.32-2-r';
UPDATE signalo_db.vl_official_sign SET value_de='Wegweiser für Hauptstrassen (3 Linien, Pfeil links)' WHERE id = '4.32-3-l';
UPDATE signalo_db.vl_official_sign SET value_de='Wegweiser für Hauptstrassen (3 Linien, Pfeil rechts)' WHERE id = '4.32-3-r';
UPDATE signalo_db.vl_official_sign SET value_de='Wegweiser für Nebenstrassen (1 Linie, Pfeil links)' WHERE id = '4.33-1-l';
UPDATE signalo_db.vl_official_sign SET value_de='Wegweiser für Nebenstrassen (1 Linie, Pfeil rechts)' WHERE id = '4.33-1-r';
UPDATE signalo_db.vl_official_sign SET value_de='Wegweiser für Nebenstrassen (2 Linien, Pfeil links)' WHERE id = '4.33-2-l';
UPDATE signalo_db.vl_official_sign SET value_de='Wegweiser für Nebenstrassen (2 Linien, Pfeil rechts)' WHERE id = '4.33-2-r';
UPDATE signalo_db.vl_official_sign SET value_de='Wegweiser für Nebenstrassen (3 Linien, Pfeil links)' WHERE id = '4.33-3-l';
UPDATE signalo_db.vl_official_sign SET value_de='Wegweiser für Nebenstrassen (3 Linien, Pfeil rechts)' WHERE id = '4.33-3-r';
UPDATE signalo_db.vl_official_sign SET value_de='Wegweiser bei Umleitungen (1 Linie, Pfeil links)' WHERE id = '4.34-l';
UPDATE signalo_db.vl_official_sign SET value_de='Wegweiser bei Umleitungen (1 Linie, Pfeil rechts)' WHERE id = '4.34-r';

UPDATE signalo_db.vl_sign_type SET value_de='unbekannt' WHERE id = 1;
UPDATE signalo_db.vl_sign_type SET value_de='andere' WHERE id = 2;
UPDATE signalo_db.vl_sign_type SET value_de='zu bestimmen' WHERE id = 3;
UPDATE signalo_db.vl_sign_type SET value_de='offiziell' WHERE id = 11;
UPDATE signalo_db.vl_sign_type SET value_de='Markierung' WHERE id = 12;
UPDATE signalo_db.vl_sign_type SET value_de='Spiegel' WHERE id = 13;
UPDATE signalo_db.vl_sign_type SET value_de='Strassenschild' WHERE id = 14;    

UPDATE signalo_db.vl_status SET value_de='unbekannt' WHERE id = 1;
UPDATE signalo_db.vl_status SET value_de='andere' WHERE id = 2;
UPDATE signalo_db.vl_status SET value_de='zu bestimmen' WHERE id = 3;
UPDATE signalo_db.vl_status SET value_de='in Ordnung' WHERE id = 10;
UPDATE signalo_db.vl_status SET value_de='beschädigt' WHERE id = 11;
UPDATE signalo_db.vl_status SET value_de='kaputt' WHERE id = 12;

UPDATE signalo_db.vl_support_base_type SET value_de='unbekannt' WHERE id = 1;
UPDATE signalo_db.vl_support_base_type SET value_de='andere' WHERE id = 2;
UPDATE signalo_db.vl_support_base_type SET value_de='zu bestimmen' WHERE id = 3;
UPDATE signalo_db.vl_support_base_type SET value_de='röhrenförmiger Metallsockel' WHERE id = 11;
UPDATE signalo_db.vl_support_base_type SET value_de='röhrenförmiger Metallsockel mit Klingen' WHERE id = 12;
UPDATE signalo_db.vl_support_base_type SET value_de='gebohrter Sockel' WHERE id = 13;
UPDATE signalo_db.vl_support_base_type SET value_de='Montageflansch mit Sockel' WHERE id = 14;
UPDATE signalo_db.vl_support_base_type SET value_de='Fertigbeton' WHERE id = 15;
UPDATE signalo_db.vl_support_base_type SET value_de='TBA-Typ 3', value_fr='SPCH-Type 3' WHERE id = 16;
UPDATE signalo_db.vl_support_base_type SET value_de='TBA-Typ 4', value_fr='SPCH-Type 4' WHERE id = 17;
UPDATE signalo_db.vl_support_base_type SET value_de='TBA-Typ 5' WHERE id = 18;
UPDATE signalo_db.vl_support_base_type SET value_de='TBA-Typ 6' WHERE id = 19;
UPDATE signalo_db.vl_support_base_type SET value_de='ASTRA-Typ A' WHERE id = 20;
UPDATE signalo_db.vl_support_base_type SET value_de='ASTRA-Typ B' WHERE id = 21;
UPDATE signalo_db.vl_support_base_type SET value_de='ASTRA-Typ C' WHERE id = 22;
UPDATE signalo_db.vl_support_base_type SET value_de='ASTRA-Typ D' WHERE id = 23;
UPDATE signalo_db.vl_support_base_type SET value_de='ASTRA-Typ E' WHERE id = 24;
UPDATE signalo_db.vl_support_base_type SET value_de='ASTRA-Typ F' WHERE id = 25;
UPDATE signalo_db.vl_support_base_type SET value_de='ASTRA-Typ 100' WHERE id = 26;
UPDATE signalo_db.vl_support_base_type SET value_de='ASTRA-Typ 150' WHERE id = 27;
UPDATE signalo_db.vl_support_base_type SET value_de='ASTRA-Typ 200' WHERE id = 28;
UPDATE signalo_db.vl_support_base_type SET value_de='ASTRA-Typ 250' WHERE id = 29;
UPDATE signalo_db.vl_support_base_type SET value_de='ASTRA-Typ 300' WHERE id = 30;
UPDATE signalo_db.vl_support_base_type SET value_de='ASTRA-Typ 300 DS' WHERE id = 31;
UPDATE signalo_db.vl_support_base_type SET value_de='Pfosten Leitplanke' WHERE id = 32;

UPDATE signalo_db.vl_support_type SET value_de='unbekannt' WHERE id = 1;
UPDATE signalo_db.vl_support_type SET value_de='andere' WHERE id = 2;
UPDATE signalo_db.vl_support_type SET value_de='zu bestimmen' WHERE id = 3;
UPDATE signalo_db.vl_support_type SET value_de='röhrenförmig'    WHERE id = 10;
UPDATE signalo_db.vl_support_type SET value_de='dreieckig'    WHERE id = 11;
UPDATE signalo_db.vl_support_type SET value_de='Portal' WHERE id = 12;
UPDATE signalo_db.vl_support_type SET value_de='Kandelaber' WHERE id = 13;
UPDATE signalo_db.vl_support_type SET value_de='Galgen' WHERE id = 14;
UPDATE signalo_db.vl_support_type SET value_de='Fassade' WHERE id = 15;
UPDATE signalo_db.vl_support_type SET value_de='Mauer' WHERE id = 16;


