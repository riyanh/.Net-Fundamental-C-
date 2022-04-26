CREATE DATABASE Mahasiswa;

USE Mahasiswa;
CREATE TABLE mahasiswa(
	id int primary key identity(1,1),
	kode_mahasiswa char(5) not null,
	nama_mahasiswa varchar(40) not null,
	alamat varchar(200),
	kode_agama char(5),
	kode_jurusan char(5)
)

SELECT * FROM INFORMATION_SCHEMA.TABLES;

INSERT INTO mahasiswa VALUES('M001', 'Budi Gunawan', 'Jl. Mawar No 3 RT 05 Cicalegka, Bandung', 'A001', 'J001');
INSERT INTO mahasiswa VALUES('M002', 'Heri Kusnandar', 'Jl. Kebagusan No. 33 RT 04, Bandung', 'A002', 'J002');
INSERT INTO mahasiswa VALUES('M003', 'Yayan Herdiyat', 'Jl. Sumatera No 12 RT02, Ciamis', 'A001', 'J003');
INSERT INTO mahasiswa VALUES('M004', 'Markonah Hanhan', 'Jl. Jawa No 3 RT 05, Jakarta Pusat', 'A001', 'J001');
INSERT INTO mahasiswa VALUES('M005', 'Cahyo', 'Jl. Niagara No 54 RT 05, Surabaya', 'A003', 'J002');

select * from mahasiswa;

CREATE TABLE agama(
	id int primary key identity(1,1),
	kode_agama char(5),
	deskripsi varchar(20)
);

INSERT INTO agama VALUES ('A001', 'Islam');
INSERT INTO agama VALUES ('A002', 'Kristen');
INSERT INTO agama VALUES ('A003', 'Katolik');
INSERT INTO agama VALUES ('A004', 'Hindu');
INSERT INTO agama VALUES ('A005', 'Budha');

select * from agama;

CREATE TABLE jurusan(
	id int primary key identity(1,1),
	kode_jurusan char(5),
	nama_jurusan varchar(50),
	status_jurusan varchar(100)
);

INSERT INTO jurusan VALUES ('J001', 'Teknik Informatika', 'Aktif');
INSERT INTO jurusan VALUES ('J002', 'Manajemen Informatika', 'Aktif');
INSERT INTO jurusan VALUES ('J003', 'Sistem Informasi', 'Non Aktif');
INSERT INTO jurusan VALUES ('J004', 'Sistem Komputer', 'Aktif');
INSERT INTO jurusan VALUES ('J005', 'Komputer Science', 'Non Aktif');

select * from jurusan;

ALTER TABLE agama DROP CONSTRAINT PK__agama__3213E83F8E2399F6;
ALTER TABLE agama ALTER COLUMN kode_agama char(5) not null;
ALTER TABLE agama ADD PRIMARY KEY(kode_agama);

ALTER TABLE mahasiswa DROP CONSTRAINT [PK__mahasisw__3213E83FDF42A738];
ALTER TABLE mahasiswa ALTER COLUMN kode_mahasiswa char(5) not null;
ALTER TABLE mahasiswa ADD PRIMARY KEY(kode_mahasiswa);

ALTER TABLE mahasiswa ADD FOREIGN KEY (kode_agama) REFERENCES agama(kode_agama);

-- ********************************************************************
SELECT
m.nama_mahasiswa,
a.deskripsi
FROM mahasiswa m, agama a
WHERE m.kode_agama = a.kode_agama

SELECT
m.*,
a.deskripsi
FROM mahasiswa m
LEFT JOIN agama a ON a.kode_agama = m.kode_agama

SELECT
m.*,
a.deskripsi
FROM mahasiswa m
RIGHT JOIN agama a ON a.kode_agama = m.kode_agama

SELECT
m.*,
a.deskripsi,
j.nama_jurusan
FROM mahasiswa m
INNER JOIN agama a ON a.kode_agama = m.kode_agama
INNER JOIN jurusan j ON j.kode_jurusan = m.kode_jurusan;

--SUB QUERY
SELECT
m.*,
(SELECT deskripsi FROM agama WHERE kode_agama=m.kode_agama) as nama_agama,
(SELECT nama_jurusan FROM jurusan WHERE kode_jurusan=m.kode_jurusan) as nama_jurusan
FROM mahasiswa m

CREATE TABLE nilai  (
  KODE_NILAI char(5),
  KODE_MAHASISWA char(5),
  KODE_UJIAN char(5),
  NILAI decimal(10, 0)
);

INSERT INTO nilai VALUES ('N001', 'M004', 'U001', 90);
INSERT INTO nilai VALUES ('N002', 'M001', 'U001', 80);
INSERT INTO nilai VALUES ('N003', 'M002', 'U003', 85);
INSERT INTO nilai VALUES ('N004', 'M004', 'U002', 95);
INSERT INTO nilai VALUES ('N005', 'M005', 'U005', 70);

select * from nilai;

CREATE TABLE ujian  (
  KODE_UJIAN char(5),
  NAMA_UJIAN varchar(50),
  STATUS_UJIAN varchar(100)
);

INSERT INTO ujian VALUES ('U001', 'Algoritma', 'Aktif');
INSERT INTO ujian VALUES ('U002', 'Aljabar', 'Aktif');
INSERT INTO ujian VALUES ('U003', 'Statistika', 'Non Aktif');
INSERT INTO ujian VALUES ('U004', 'Etika Profesi', 'Non Aktif');
INSERT INTO ujian VALUES ('U005', 'Bahasa Inggris', 'Aktif');

SELECT KODE_MAHASISWA, SUM(NILAI) as total FROM nilai GROUP BY KODE_MAHASISWA
SELECT KODE_MAHASISWA, MIN(NILAI) as min_nilai FROM nilai GROUP BY KODE_MAHASISWA
SELECT KODE_MAHASISWA, MAX(NILAI) as max_nilai FROM nilai GROUP BY KODE_MAHASISWA
SELECT KODE_MAHASISWA, AVG(NILAI) as avg_nilai FROM nilai GROUP BY KODE_MAHASISWA
SELECT KODE_MAHASISWA, COUNT(*) as min_nilai FROM nilai GROUP BY KODE_MAHASISWA

SELECT
n.KODE_MAHASISWA, m.nama_mahasiswa,
u.NAMA_UJIAN,
AVG(n.NILAI) as avg_nilai
FROM nilai n
INNER JOIN mahasiswa m ON n.KODE_MAHASISWA = m.KODE_MAHASISWA
INNER JOIN ujian u ON n.KODE_UJIAN = u.KODE_UJIAN
GROUP BY n.kode_mahasiswa, m.nama_mahasiswa, u.NAMA_UJIAN ORDER BY n.KODE_MAHASISWA ASC;

CREATE VIEW view_nilai AS
SELECT
(SELECT nama_mahasiswa FROM mahasiswa WHERE kode_mahasiswa = n.kode_mahasiswa) AS nama,
(SELECT nama_ujian FROM ujian WHERE KODE_UJIAN = n.kode_ujian) AS nama_ujian,
AVG(NILAI) as total
FROM nilai n GROUP BY KODE_MAHASISWA,KODE_UJIAN

SELECT * FROM view_nilai;

SELECT kode_mahasiswa, kode_ujian,
CASE
	WHEN nilai >= 90 AND nilai <= 100 THEN 'A'
	WHEN nilai >= 80 AND nilai <= 89 THEN 'B'
	--WHEN nilai >= 70 AND nilai <= 79 THEN 'C'
	ELSE 'Tidak lulus'
END AS nilai_huruf
FROM nilai

SELECT *, 'Tidak lulus' AS status FROM nilai WHERE nilai < 80
union
SELECT *, 'Lulus' AS Status FROM nilai WHERE nilai >= 80 AND nilai <= 100

SELECT kode_mahasiswa, COUNT(*) as total FROM nilai GROUP BY kode_mahasiswa HAVING COUNT(*) > 1;

SELECT KODE_MAHASISWA, IIF(nilai < 80, 'Tidak Lulus', 'Lulus') FROM nilai;

SELECT CONCAT('Bootcamp', 'Astra');
SELECT CONCAT(kode_mahasiswa, kode_agama, kode_jurusan) FROM mahasiswa;

SELECT kode_mahasiswa, nilai FROM nilai WHERE nilai BETWEEN 70 AND 90;

CREATE TABLE dosen  (
  KODE_DOSEN char(5),
  NAMA_DOSEN varchar(100),
  KODE_JURUSAN char(5),
  KODE_TYPE_DOSEN char(5)
);

INSERT INTO dosen VALUES ('D001', 'Prof. Dr. Retno Wahyuningsih', 'J001', 'T002');
INSERT INTO dosen VALUES ('D002', 'Prof. Roy M. Soetikno', 'J002', 'T001');
INSERT INTO dosen VALUES ('D003', 'Prof. Hendri A. Verbrugh', 'J003', 'T002');
INSERT INTO dosen VALUES ('D004', 'Prof. Risma Suparwata', 'J004', 'T002');
INSERT INTO dosen VALUES ('D005', 'Prof. Amir Sjarifuddin Madjid, MM, MBA', 'J005', 'T001');

CREATE TABLE type_dosen  (
  KODE_TYPE_DOSEN char(5),
  DESKRIPSI varchar(20)
);

INSERT INTO type_dosen VALUES ('T001', 'Tetap');
INSERT INTO type_dosen VALUES ('T002', 'Honoroer');
INSERT INTO type_dosen VALUES ('T003', 'Expertise');

--------------------- TUGAS SQL QUERY -------------------------
--No 2
ALTER TABLE dosen ALTER COLUMN nama_dosen Varchar(200); 

--No 3
SELECT
m.kode_mahasiswa, m.nama_mahasiswa, j.nama_jurusan, a.deskripsi
FROM mahasiswa m
JOIN jurusan j ON m.kode_jurusan = j.kode_jurusan
JOIN agama a ON m.kode_agama = a.kode_agama
WHERE m.kode_mahasiswa = 'M001';

--No 4
SELECT
m.*, j.status_jurusan
FROM mahasiswa m
JOIN jurusan j ON m.kode_jurusan = j.kode_jurusan
WHERE j.status_jurusan = 'Non Aktif';

--No 5
SELECT
n.kode_mahasiswa, m.nama_mahasiswa, n.nilai, j.status_jurusan 
FROM nilai n
JOIN mahasiswa m ON n.kode_mahasiswa = m.kode_mahasiswa
JOIN jurusan j ON m.kode_jurusan = j.kode_jurusan
WHERE nilai >= 80 AND j.status_jurusan = 'Aktif';

--No 6
SELECT *
FROM jurusan 
WHERE nama_jurusan LIKE '%sistem%';

--No 7
SELECT n.kode_mahasiswa, m.nama_mahasiswa, 
COUNT(*) as total 
FROM nilai n 
JOIN mahasiswa m ON n.kode_mahasiswa = m.kode_mahasiswa
GROUP BY n.kode_mahasiswa, m.nama_mahasiswa
HAVING COUNT(*) > 1;

--No 8
SELECT
m.kode_mahasiswa, m.nama_mahasiswa, j.nama_jurusan, a.deskripsi,
d.nama_dosen, j.status_jurusan, td.deskripsi
FROM mahasiswa m
JOIN agama a ON m.kode_agama = a.kode_agama
JOIN jurusan j ON m.kode_jurusan = j.kode_jurusan
JOIN dosen d ON j.kode_jurusan = d.kode_jurusan
JOIN type_dosen td ON d.kode_type_dosen = td.kode_type_dosen
WHERE m.kode_mahasiswa = 'M001' AND j.status_jurusan = 'Aktif' AND td.deskripsi = 'Honoroer';

--No 9
CREATE VIEW view_data AS
SELECT
m.kode_mahasiswa, m.nama_mahasiswa, j.nama_jurusan, a.deskripsi AS agama,
d.nama_dosen, j.status_jurusan, td.deskripsi AS deskripsi_dosen
FROM mahasiswa m
INNER JOIN agama a ON m.kode_agama = a.kode_agama
INNER JOIN jurusan j ON m.kode_jurusan = j.kode_jurusan
INNER JOIN dosen d ON j.kode_jurusan = d.kode_jurusan
INNER JOIN type_dosen td ON d.kode_type_dosen = td.kode_type_dosen
WHERE m.kode_mahasiswa = 'M001' AND j.status_jurusan = 'Aktif' AND td.deskripsi = 'Honoroer';

SELECT * FROM view_data;

--No 10
SELECT *
FROM nilai
RIGHT JOIN mahasiswa ON mahasiswa.kode_mahasiswa = nilai.KODE_MAHASISWA;