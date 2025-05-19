ALTER TABLE signalo_db.azimut ALTER COLUMN offset_x SET DATA TYPE DECIMAL(10, 2) USING offset_x::DECIMAL(10, 2);
ALTER TABLE signalo_db.azimut ALTER COLUMN offset_y SET DATA TYPE DECIMAL(10, 2) USING offset_y::DECIMAL(10, 2);
ALTER TABLE signalo_db.azimut ALTER COLUMN offset_x_verso SET DATA TYPE DECIMAL(10, 2) USING offset_x_verso::DECIMAL(10, 2);
ALTER TABLE signalo_db.azimut ALTER COLUMN offset_y_verso SET DATA TYPE DECIMAL(10, 2) USING offset_y_verso::DECIMAL(10, 2);