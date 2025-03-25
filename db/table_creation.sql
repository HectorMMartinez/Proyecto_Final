DROP DATABASE IF EXISTS empleos;
CREATE DATABASE empleos;
USE empleos;

-- ================================================
-- 1. Tabla base de usuarios
-- ================================================
CREATE TABLE usuarios (
    id INT AUTO_INCREMENT PRIMARY KEY,
    correo VARCHAR(100) UNIQUE NOT NULL,
    contraseña VARCHAR(255) NOT NULL,
    tipo ENUM('candidato', 'empresa') NOT NULL,
    fecha_registro DATETIME DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- ================================================
-- 2. Tablas derivadas: Candidatos y Empresas
-- ================================================
CREATE TABLE candidatos (
    id INT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    FOREIGN KEY (id) REFERENCES usuarios(id) ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE empresas (
    id INT PRIMARY KEY,
    nombre_empresa VARCHAR(255) NOT NULL,
    direccion VARCHAR(255),
    telefono VARCHAR(50),
	sitio_web VARCHAR(255),
    FOREIGN KEY (id) REFERENCES usuarios(id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- ================================================
-- 3. Información adicional del candidato (CV)
-- ================================================
CREATE TABLE cv (
    candidato_id INT PRIMARY KEY,
    titulo_profesional VARCHAR(255) NOT NULL,
    apellido VARCHAR(100) NOT NULL,
    telefono VARCHAR(50),
    direccion VARCHAR(255),
    ciudad VARCHAR(100),
    disponibilidad VARCHAR(50),
    objetivo TEXT,
    foto VARCHAR(255),
    cv_pdf VARCHAR(255),
    FOREIGN KEY (candidato_id) REFERENCES candidatos(id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- ================================================
-- 4. Tablas normalizadas del CV
-- ================================================
CREATE TABLE habilidades (
    id INT AUTO_INCREMENT PRIMARY KEY,
    candidato_id INT,
    habilidad VARCHAR(255) NOT NULL,
    FOREIGN KEY (candidato_id) REFERENCES candidatos(id) ON DELETE CASCADE,
    UNIQUE(candidato_id, habilidad)
) ENGINE=InnoDB;

CREATE TABLE idiomas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    candidato_id INT,
    idioma VARCHAR(100) NOT NULL,
    nivel VARCHAR(100),
    FOREIGN KEY (candidato_id) REFERENCES candidatos(id) ON DELETE CASCADE,
    UNIQUE(candidato_id, idioma)
) ENGINE=InnoDB;

CREATE TABLE logros (
    id INT AUTO_INCREMENT PRIMARY KEY,
    candidato_id INT,
    logro TEXT NOT NULL,
    FOREIGN KEY (candidato_id) REFERENCES candidatos(id) ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE redes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    candidato_id INT,
    plataforma VARCHAR(100),
    url VARCHAR(255),
    FOREIGN KEY (candidato_id) REFERENCES candidatos(id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- ================================================
-- 5. Formación académica y experiencia laboral
-- ================================================
CREATE TABLE formacion_academica (
    id INT AUTO_INCREMENT PRIMARY KEY,
    candidato_id INT,
    institucion VARCHAR(255),
    titulo VARCHAR(255),
    fecha_inicio DATE,
    fecha_fin DATE,
    FOREIGN KEY (candidato_id) REFERENCES candidatos(id) ON DELETE CASCADE,
    KEY idx_candidato (candidato_id)
) ENGINE=InnoDB;

CREATE TABLE experiencia_laboral (
    id INT AUTO_INCREMENT PRIMARY KEY,
    candidato_id INT,
    empresa VARCHAR(255),
    puesto VARCHAR(255),
    fecha_inicio DATE,
    fecha_fin DATE,
    descripcion TEXT,
    FOREIGN KEY (candidato_id) REFERENCES candidatos(id) ON DELETE CASCADE,
    KEY idx_candidato (candidato_id)
) ENGINE=InnoDB;

CREATE TABLE referencias (
    id INT AUTO_INCREMENT PRIMARY KEY,
    candidato_id INT,
    nombre VARCHAR(100) NOT NULL,
    apellido VARCHAR(100) NOT NULL,
    telefono VARCHAR(50),
    relacion VARCHAR(100),
    FOREIGN KEY (candidato_id) REFERENCES candidatos(id) ON DELETE CASCADE,
    KEY idx_candidato (candidato_id)
) ENGINE=InnoDB;

-- ================================================
-- 6. Ofertas de trabajo
-- ================================================
CREATE TABLE categorias (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL
) ENGINE=InnoDB;

CREATE TABLE ofertas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    empresa_id INT,
    categoria_id INT DEFAULT NULL,
    titulo VARCHAR(255) NOT NULL,
    descripcion TEXT NOT NULL,
    requisitos TEXT NOT NULL,
    estado ENUM('activa', 'cerrada', 'suspendida') DEFAULT 'activa',
    fecha_publicacion DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (empresa_id) REFERENCES empresas(id) ON DELETE CASCADE,
    FOREIGN KEY (categoria_id) REFERENCES categorias(id) ON DELETE SET NULL,
    KEY idx_categoria (categoria_id),
    KEY idx_empresa (empresa_id),
    KEY idx_fecha_publicacion (fecha_publicacion),
    UNIQUE KEY uq_empresa_titulo (empresa_id, titulo)
) ENGINE=InnoDB;

-- ================================================
-- 7. Aplicaciones a ofertas
-- ================================================
CREATE TABLE aplicaciones (
    id INT AUTO_INCREMENT PRIMARY KEY,
    candidato_id INT,
    oferta_id INT,
    estado ENUM('pendiente','revisada','aceptada','rechazada') DEFAULT 'pendiente',
    fecha_aplicacion DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (candidato_id) REFERENCES candidatos(id) ON DELETE CASCADE,
    FOREIGN KEY (oferta_id) REFERENCES ofertas(id) ON DELETE CASCADE,
    KEY idx_candidato_oferta (candidato_id, oferta_id)
) ENGINE=InnoDB;

-- ================================================
-- 8. Logs y notificaciones unificados por usuario
-- ================================================
CREATE TABLE logs (
    id INT AUTO_INCREMENT PRIMARY KEY,
    usuario_id INT,
    accion VARCHAR(255) NOT NULL,
    fecha DATETIME DEFAULT CURRENT_TIMESTAMP,
    detalles TEXT,
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id) ON DELETE CASCADE,
    KEY idx_usuario (usuario_id)
) ENGINE=InnoDB;

CREATE TABLE notificaciones (
    id INT AUTO_INCREMENT PRIMARY KEY,
    usuario_id INT,
    mensaje TEXT NOT NULL,
    fecha DATETIME DEFAULT CURRENT_TIMESTAMP,
    leido BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id) ON DELETE CASCADE,
    KEY idx_usuario (usuario_id)
) ENGINE=InnoDB;