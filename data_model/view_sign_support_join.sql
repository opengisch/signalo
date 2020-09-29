SELECT signal.*, support.geometry 
FROM signal
LEFT JOIN cadre ON cadrei.id = signal.fk_cadre
LEFT JOIN support ON support.id = cadre.fk_support